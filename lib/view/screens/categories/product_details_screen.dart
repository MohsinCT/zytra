import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zytranow/models/product.dart';
import 'package:zytranow/controllers/cart_provider.dart';
import 'package:zytranow/controllers/product_details_provider.dart';
import 'package:zytranow/view/screens/home/widgets/shimmer_loader.dart';
import 'package:zytranow/view/widgets/floating_cart_capsule.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  // Helper to color shades if makeup categories
  Color _getColorForShade(String variantName) {
    final lower = variantName.toLowerCase();
    if (lower.contains('rose') || lower.contains('pink'))
      return const Color(0xFFFF6B8B);
    if (lower.contains('red') || lower.contains('crimson'))
      return const Color(0xFFD32F2F);
    if (lower.contains('coral') || lower.contains('gold'))
      return const Color(0xFFFF8A65);
    if (lower.contains('nude') || lower.contains('velvet'))
      return const Color(0xFFD7CCC8);
    if (lower.contains('plum')) return const Color(0xFF4A148C);
    return const Color(0xFFFF2D6F); // fallback
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final qty = cart.quantityOf(product.id);
    final isBeautyFashion =
        product.category.toLowerCase().contains('lipstick') ||
        product.category.toLowerCase().contains('gloss') ||
        product.category.toLowerCase().contains('blush') ||
        product.category.toLowerCase().contains('tint') ||
        product.category.toLowerCase().contains('t-shirt') ||
        product.category.toLowerCase().contains('pants') ||
        product.category.toLowerCase().contains('dress') ||
        product.category.toLowerCase().contains('top') ||
        product.category.toLowerCase().contains('jeans') ||
        product.category.toLowerCase().contains('skincare') ||
        product.category.toLowerCase().contains('serum') ||
        product.category.toLowerCase().contains('sunscreen');

    final discountPercent = product.mrp > 0
        ? (((product.mrp - product.price) / product.mrp) * 100).round()
        : 0;

    return ChangeNotifierProvider(
      create: (_) => ProductDetailsProvider(product),
      child: Consumer<ProductDetailsProvider>(
        builder: (context, provider, child) {
          final currentImageIndex = provider.currentImageIndex;
          final selectedVariant = provider.selectedVariant;
          final isLiked = provider.isLiked;

          return Scaffold(
            backgroundColor: const Color(0xFFF8F9FA),
            body: Stack(
              children: [
                // Main Scroll Content
                Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Image Carousel Block
                        Stack(
                          children: [
                            Hero(
                              tag: 'product_image_${product.id}',
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(32),
                                    bottomRight: Radius.circular(32),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(32),
                                    bottomRight: Radius.circular(32),
                                  ),
                                  child: (product.images.isNotEmpty || product.imageAsset.isNotEmpty)
                                      ? Builder(
                                          builder: (context) {
                                            final displayImages = product.images.isNotEmpty
                                                ? product.images
                                                : [product.imageAsset];
                                            return PageView.builder(
                                              controller: provider.pageController,
                                              itemCount: displayImages.length,
                                              onPageChanged: (idx) {
                                                provider.setImageIndex(idx);
                                              },
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding: const EdgeInsets.all(20.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: displayImages[index],
                                                    fit: BoxFit.contain,
                                                    placeholder: (context, url) =>
                                                        const ShimmerLoader(
                                                          width: double.infinity,
                                                          height: double.infinity,
                                                          borderRadius: 0,
                                                        ),
                                                    errorWidget: (context, url, error) => const Icon(
                                                          Icons.image_not_supported,
                                                          size: 50,
                                                          color: Colors.grey,
                                                        ),
                                                  ),
                                                );
                                              },
                                            );
                                          }
                                        )
                                      : const SizedBox.shrink(),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 24,
                              left: 0,
                              right: 0,
                              child: Builder(
                                builder: (context) {
                                  final displayImages = product.images.isNotEmpty
                                      ? product.images
                                      : [product.imageAsset];
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      displayImages.length,
                                      (index) => AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    height: 6,
                                    width: currentImageIndex == index ? 20 : 6,
                                    decoration: BoxDecoration(
                                      color: currentImageIndex == index
                                          ? const Color(0xFFFF2D6F)
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                            if (isBeautyFashion)
                              Positioned(
                                left: 16,
                                bottom: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFF2D6F),
                                        Color(0xFFFF6A9A),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFFF2D6F,
                                        ).withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.flash_on,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'TRENDING NOW',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // 2. Primary Information Block
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    product.brand.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                  if (product.soldCount > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '🔥 ${product.soldCount}k+ sold recently',
                                        style: TextStyle(
                                          color: Colors.grey.shade800,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.name,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  height: 1.2,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E1E24),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${product.rating}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 14,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${product.reviews} Verified Ratings',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${product.price.toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (product.mrp > product.price) ...[
                                    Text(
                                      'MRP ₹${product.mrp.toStringAsFixed(0)}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFFF2D6F,
                                        ).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '$discountPercent% OFF',
                                        style: const TextStyle(
                                          color: Color(0xFFFF2D6F),
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'inclusive of all taxes',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x05000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFFFF2D6F,
                                        ).withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.bolt,
                                        color: Color(0xFFFF2D6F),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Superfast Delivery in ${product.deliveryTime}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          const Text(
                                            'Guaranteed quick delivery right at your doorstep!',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 3. Variant Shade/Size Selector
                        if (product.variants.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      product.category.toLowerCase().contains(
                                                't-shirt',
                                              ) ||
                                              product.category
                                                  .toLowerCase()
                                                  .contains('pants') ||
                                              product.category
                                                  .toLowerCase()
                                                  .contains('dress')
                                          ? 'SELECT SIZE'
                                          : 'CHOOSE SHADE / VARIANT',
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    if (selectedVariant != null)
                                      Text(
                                        selectedVariant,
                                        style: const TextStyle(
                                          color: Color(0xFFFF2D6F),
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 48,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: product.variants.length,
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final variant = product.variants[index];
                                      final isSelected =
                                          variant == selectedVariant;
                                      final isShade =
                                          product.category
                                              .toLowerCase()
                                              .contains('lipstick') ||
                                          product.category
                                              .toLowerCase()
                                              .contains('gloss') ||
                                          product.category
                                              .toLowerCase()
                                              .contains('blush') ||
                                          product.category
                                              .toLowerCase()
                                              .contains('tint');

                                      if (isShade) {
                                        final shadeColor = _getColorForShade(
                                          variant,
                                        );
                                        return GestureDetector(
                                          onTap: () =>
                                              provider.selectVariant(variant),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            margin: const EdgeInsets.only(
                                              right: 12,
                                            ),
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: isSelected
                                                    ? const Color(0xFFFF2D6F)
                                                    : Colors.transparent,
                                                width: 2,
                                              ),
                                            ),
                                            child: Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: shadeColor,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: shadeColor
                                                        .withValues(alpha: 0.4),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: isSelected
                                                  ? const Icon(
                                                      Icons.check,
                                                      color: Colors.white,
                                                      size: 16,
                                                    )
                                                  : const SizedBox.shrink(),
                                            ),
                                          ),
                                        );
                                      } else {
                                        return GestureDetector(
                                          onTap: () =>
                                              provider.selectVariant(variant),
                                          child: AnimatedContainer(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            margin: const EdgeInsets.only(
                                              right: 12,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? const Color(0xFFFF2D6F)
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: isSelected
                                                    ? Colors.transparent
                                                    : Colors.grey.shade300,
                                                width: 1.5,
                                              ),
                                              boxShadow: isSelected
                                                  ? [
                                                      BoxShadow(
                                                        color:
                                                            const Color(
                                                              0xFFFF2D6F,
                                                            ).withValues(
                                                              alpha: 0.3,
                                                            ),
                                                        blurRadius: 6,
                                                        offset: const Offset(
                                                          0,
                                                          3,
                                                        ),
                                                      ),
                                                    ]
                                                  : [],
                                            ),
                                            child: Center(
                                              child: Text(
                                                variant,
                                                style: TextStyle(
                                                  color: isSelected
                                                      ? Colors.white
                                                      : Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        if (isBeautyFashion) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFFF2D6F,
                                ).withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: const Color(
                                    0xFFFF2D6F,
                                  ).withValues(alpha: 0.1),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Row(
                                    children: [
                                      Icon(
                                        Icons.tips_and_updates_outlined,
                                        color: Color(0xFFFF2D6F),
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'BEAUTY TIP & USAGE NOTE',
                                        style: TextStyle(
                                          color: Color(0xFFFF2D6F),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.category.toLowerCase().contains(
                                              'lipstick',
                                            ) ||
                                            product.category
                                                .toLowerCase()
                                                .contains('tint')
                                        ? 'Exfoliate lips gently before application. Start at the center of the upper lip and glide towards the corners. For fashion dress-up, pair with a premium dewy highlighter to pull off that glossy classic Nykaa glow!'
                                        : 'Apply 3-4 drops evenly onto cleansed facial skin. Gently pat with fingers until fully absorbed. Follow up with SPF 50 sunscreen during daytime to lock in maximum barrier protection.',
                                    style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 12,
                                      height: 1.5,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // 4. Horizontal Specifications Cards Section
                        if (product.specifications.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'SPECIFICATIONS',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemCount: product.specifications.length,
                              itemBuilder: (context, index) {
                                final key = product.specifications.keys
                                    .elementAt(index);
                                final value = product.specifications[key]!;

                                return Container(
                                  width: 170,
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E1E24),
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x1F000000),
                                        blurRadius: 6,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        key.toUpperCase(),
                                        style: TextStyle(
                                          color: Colors.grey.shade400,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        value,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          height: 1.3,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],

                        // 5. Product Description Block
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'PRODUCT DESCRIPTION',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.description,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 6. Brand Section Container
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade200),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x03000000),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFF2D6F),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      product.brand.isNotEmpty
                                          ? product.brand[0]
                                          : 'Z',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.brand,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Text(
                                        'Explore all products from same brand',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: const Color(
                                          0xFFFF2D6F,
                                        ),
                                        content: Text(
                                          'Exploring premium products from ${product.brand}',
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // 7. Reusable Features Row Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                _buildFeatureCard(
                                  Icons.refresh,
                                  '7 Days\nReplacement',
                                ),
                                _buildFeatureCard(
                                  Icons.payments_outlined,
                                  'Cash on\nDelivery',
                                ),
                                _buildFeatureCard(
                                  Icons.verified_user_outlined,
                                  'Secure\nPayment',
                                ),
                                _buildFeatureCard(
                                  Icons.shield_outlined,
                                  'Cruelty Free\nWarranty',
                                ),
                                _buildFeatureCard(
                                  Icons.assignment_return_outlined,
                                  'Easy\nReturns',
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // 8. Similar Products Horizontal List
                        if (product.similarProducts.isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'SIMILAR PRODUCTS',
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 230,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemCount: product.similarProducts.length,
                              itemBuilder: (context, index) {
                                final p = product.similarProducts[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider(
                                              create: (_) =>
                                                  ProductDetailsProvider(p),
                                              child: ProductDetailsScreen(
                                                product: p,
                                              ),
                                            ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 140,
                                    margin: const EdgeInsets.only(right: 14),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.grey.shade200,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: CachedNetworkImage(
                                              imageUrl: p.imageAsset,
                                              width: double.infinity,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const ShimmerLoader(
                                                    width: double.infinity,
                                                    height: double.infinity,
                                                    borderRadius: 12,
                                                  ),
                                              errorWidget:
                                                  (
                                                    context,
                                                    url,
                                                    error,
                                                  ) => const Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey,
                                                    size: 20,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          p.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '₹${p.price.toStringAsFixed(0)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 13,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 3,
                                                  ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFFF2D6F,
                                                  ),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: const Text(
                                                'ADD',
                                                style: TextStyle(
                                                  color: Color(0xFFFF2D6F),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 9,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // 9. Premium Translucent Floating Header
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        color: Colors.white.withValues(alpha: 0.7),
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 4,
                          bottom: 12,
                          left: 8,
                          right: 8,
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back_ios_new,
                                color: Colors.black,
                                size: 20,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 22,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                isLiked
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: isLiked
                                    ? const Color(0xFFFF2D6F)
                                    : Colors.black,
                                size: 22,
                              ),
                              onPressed: () {
                                provider.toggleLike();
                                cart.toggleWishlist(product.id);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.share_outlined,
                                color: Colors.black,
                                size: 22,
                              ),
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Product link copied to clipboard!',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // 10. Sticky Bottom Glassmorphic Cart Bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                      child: Container(
                        padding: EdgeInsets.only(
                          top: 16,
                          bottom: MediaQuery.of(context).padding.bottom + 12,
                          left: 20,
                          right: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(28),
                            topRight: Radius.circular(28),
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 20,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Row(
                                    children: [
                                      Text(
                                        '₹${product.price.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      if (product.mrp > product.price)
                                        Text(
                                          '₹${product.mrp.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 13,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const Text(
                                    'inclusive of all taxes',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            qty > 0
                                ? Container(
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF2D6F),
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFFF2D6F,
                                          ).withValues(alpha: 0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          onPressed: () =>
                                              cart.removeOne(product.id),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          child: Text(
                                            qty.toString(),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          onPressed: () => cart.add(product),
                                        ),
                                      ],
                                    ),
                                  )
                                : _AddToCartButton(product: product),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: MediaQuery.of(context).padding.bottom + 90,
                  child: const FloatingCartCapsule(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title) {
    return Container(
      width: 100,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFFF2D6F), size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddToCartButton extends StatelessWidget {
  final Product product;
  const _AddToCartButton({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final isPressedNotifier = ValueNotifier<bool>(false);

    return ValueListenableBuilder<bool>(
      valueListenable: isPressedNotifier,
      builder: (context, isPressed, child) {
        return AnimatedScale(
          scale: isPressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: GestureDetector(
            onTapDown: (_) => isPressedNotifier.value = true,
            onTapCancel: () => isPressedNotifier.value = false,
            onTapUp: (_) async {
              isPressedNotifier.value = false;
              cart.add(product);

              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF1E1E24),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 100,
                  ),
                  duration: const Duration(seconds: 2),
                  content: Row(
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        color: Color(0xFFFF2D6F),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Added ${product.name} to Cart!',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF2D6F), Color(0xFFFF6A9A)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF2D6F).withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'ADD TO CART',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
