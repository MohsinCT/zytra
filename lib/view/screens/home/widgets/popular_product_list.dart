import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zytranow/models/product.dart';
import 'package:zytranow/models/quiz_models.dart';
import 'package:zytranow/controllers/cart_provider.dart';
import 'package:zytranow/view/screens/categories/product_details_screen.dart';
import 'package:zytranow/view/screens/home/widgets/shimmer_loader.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class PopularProductList extends StatelessWidget {
  final List<Product> products;
  final bool isPersonalized;
  final UserProfile? profile;

  const PopularProductList({
    super.key,
    required this.products,
    this.isPersonalized = false,
    this.profile,
  });

  List<Product> _getProcessedProducts() {
    if (!isPersonalized || profile == null) {
      return products;
    }

    final avoid = profile!.avoidIngredients.map((e) {
      final s = e.toLowerCase().trim();
      return s.endsWith('s') ? s.substring(0, s.length - 1) : s;
    }).toList();
    final userSkin = profile!.skinType.toLowerCase();
    final userConcerns = profile!.concerns.map((e) => e.toLowerCase()).toList();
    final isBudget = profile!.budgetRange == 'budget';

    // 1. Filter out all products containing any avoided ingredient
    List<Product> filtered = products.where((p) {
      for (var ing in p.ingredients) {
        final ingLower = ing.toLowerCase();
        for (var a in avoid) {
          if (ingLower.contains(a)) {
            return false;
          }
        }
      }
      return true;
    }).toList();

    if (filtered.isEmpty) {
      filtered = List.from(products);
    }

    // 2. Score & Sort products matching user skinType, concerns, cleanFormula, budget
    filtered.sort((a, b) {
      int scoreA = 0;
      int scoreB = 0;

      // Skin type match (+10)
      if (a.suitableSkinTypes.any(
        (s) =>
            s.toLowerCase().contains(userSkin) ||
            userSkin.contains(s.toLowerCase()),
      )) {
        scoreA += 10;
      }
      if (b.suitableSkinTypes.any(
        (s) =>
            s.toLowerCase().contains(userSkin) ||
            userSkin.contains(s.toLowerCase()),
      )) {
        scoreB += 10;
      }

      // Concern match (+5 each)
      for (var c in userConcerns) {
        if (a.targetedConcerns.any(
          (tc) => tc.toLowerCase().contains(c) || c.contains(tc.toLowerCase()),
        )) {
          scoreA += 5;
        }
        if (b.targetedConcerns.any(
          (tc) => tc.toLowerCase().contains(c) || c.contains(tc.toLowerCase()),
        )) {
          scoreB += 5;
        }
      }

      // Clean formula (+2)
      if (a.isCleanFormula) scoreA += 2;
      if (b.isCleanFormula) scoreB += 2;

      // Budget-friendly priority
      if (isBudget) {
        if (a.price <= 499) scoreA += 5;
        if (b.price <= 499) scoreB += 5;
      }

      return scoreB.compareTo(scoreA);
    });

    return filtered;
  }

  Widget? _buildPersonalizedBadge(Product product, UserProfile profile) {
    // Check if product contains any avoided ingredient
    final avoid = profile.avoidIngredients;
    for (var ing in product.ingredients) {
      for (var a in avoid) {
        if (ing.toLowerCase().contains(a.toLowerCase())) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3CD),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFFC107), width: 0.8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 10,
                  color: Color(0xFF856404),
                ),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    "⚠ Contains $a",
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF856404),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }
      }
    }

    // Match badge
    final userSkin = profile.skinType.toLowerCase();
    final isSkinMatch = product.suitableSkinTypes.any(
      (s) =>
          s.toLowerCase().contains(userSkin) ||
          userSkin.contains(s.toLowerCase()),
    );

    final badgeText = isSkinMatch
        ? "✓ ${profile.skinTypeCapitalized} Pick"
        : "✓ Safe for You";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF4CAF50), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check, size: 10, color: Color(0xFF2E7D32)),
          const SizedBox(width: 3),
          Flexible(
            child: Text(
              badgeText,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: Color(0xFF2E7D32),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayProducts = _getProcessedProducts();

    return SizedBox(
      height: isPersonalized ? 245 : 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: displayProducts.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          final product = displayProducts[i];
          final isNetworkImage =
              product.imageAsset.isNotEmpty &&
              (product.imageAsset.startsWith('http://') ||
                  product.imageAsset.startsWith('https://'));

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(product: product),
                ),
              );
            },
            child: Container(
              width: 140,
              margin: const EdgeInsets.only(
                left: 6,
                right: 6,
                bottom: 8,
                top: 4,
              ),
              decoration: BoxDecoration(
                color: context.cardBackground,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: context.isDark ? 0.01 : 0.04,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: context.borderTheme),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: context.inputFill,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: Hero(
                              tag: 'product_image_${product.id}',
                              child: product.imageAsset.isNotEmpty
                                  ? (isNetworkImage
                                        ? CachedNetworkImage(
                                            imageUrl: product.imageAsset,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const ShimmerLoader(
                                                  width: double.infinity,
                                                  height: double.infinity,
                                                  borderRadius: 16,
                                                ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.grey,
                                                      size: 20,
                                                    ),
                                          )
                                        : Image.asset(
                                            product.imageAsset,
                                            fit: BoxFit.cover,
                                          ))
                                  : const Center(
                                      child: Icon(
                                        Icons.image_outlined,
                                        color: Colors.black12,
                                        size: 30,
                                      ),
                                    ),
                            ),
                          ),
                        ),

                        // Personalized card badge overlay
                        if (isPersonalized && profile != null)
                          Positioned(
                            top: 6,
                            left: 6,
                            right: 6,
                            child:
                                _buildPersonalizedBadge(product, profile!) ??
                                const SizedBox.shrink(),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            height: 1.2,
                            color: context.textDark,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹${product.price.toInt()}",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: context.textDark,
                              ),
                            ),
                            Consumer<CartProvider>(
                              builder: (context, cart, child) {
                                final qty = cart.quantityOf(product.id);

                                return qty > 0
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF2D6F),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(
                                                0xFFFF2D6F,
                                              ).withValues(alpha: 0.2),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () =>
                                                  cart.removeOne(product.id),
                                              child: const Padding(
                                                padding: EdgeInsets.all(6.0),
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              qty.toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => cart.add(product),
                                              child: const Padding(
                                                padding: EdgeInsets.all(6.0),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          cart.add(product);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).clearSnackBars();
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              backgroundColor: const Color(
                                                0xFF1E1E24,
                                              ),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 120,
                                                  ),
                                              duration: const Duration(
                                                seconds: 1,
                                              ),
                                              content: Text(
                                                'Added ${product.name} to Cart!',
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: context.cardBackground,
                                            border: Border.all(
                                              color: const Color(0xFFFF2D6F),
                                              width: 1.5,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: const Text(
                                            'ADD',
                                            style: TextStyle(
                                              color: Color(0xFFFF2D6F),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                      );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
