import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zytranow/controllers/cart_provider.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/models/product.dart';
import 'package:zytranow/models/quiz_models.dart';

class RoutineBundleBanner extends StatelessWidget {
  final UserProfile profile;

  const RoutineBundleBanner({
    super.key,
    required this.profile,
  });

  List<Product> _getCuratedBundleProducts() {
    final concerns = profile.concerns.join(' ').toLowerCase();
    final isOily = profile.skinType.toLowerCase().contains('oily');

    return [
      Product(
        id: 'bundle_step1_cleanser',
        name: isOily ? 'Gentle Salicylic Gel Cleanser' : 'Hydrating Ceramide Milky Cleanser',
        imageAsset: 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=400',
        unit: '100 ml',
        price: 349,
        deliveryTime: '8 mins',
        brand: 'evermi Lab',
        category: 'Cleanser',
        suitableSkinTypes: [profile.skinType],
        targetedConcerns: profile.concerns,
        ingredients: ['Centella', 'Ceramides', 'Glycerin'],
        isCleanFormula: true,
      ),
      Product(
        id: 'bundle_step2_serum',
        name: concerns.contains('blemish') || concerns.contains('acne')
            ? '10% Niacinamide + Zinc Blemish Serum'
            : 'Multi-Peptide & Hyaluronic Glow Serum',
        imageAsset: 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=400',
        unit: '30 ml',
        price: 499,
        deliveryTime: '8 mins',
        brand: 'evermi Lab',
        category: 'Treatment',
        suitableSkinTypes: [profile.skinType],
        targetedConcerns: profile.concerns,
        ingredients: ['Niacinamide', 'Hyaluronic Acid'],
        isCleanFormula: true,
      ),
      Product(
        id: 'bundle_step3_spf',
        name: 'Invisible Water-Gel Daily Sunscreen SPF 50+',
        imageAsset: 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=400',
        unit: '50 g',
        price: 399,
        deliveryTime: '8 mins',
        brand: 'evermi Lab',
        category: 'Protection',
        suitableSkinTypes: [profile.skinType],
        targetedConcerns: ['Sun Protection', 'Barrier Care'],
        ingredients: ['UV Filters', 'Allantoin'],
        isCleanFormula: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bundleProducts = _getCuratedBundleProducts();
    final bundlePrice = bundleProducts.fold<double>(0.0, (sum, p) => sum + p.price) - 150; // Special bundle discount
    final concernsText = profile.concerns.isNotEmpty
        ? profile.concerns.take(2).join(' & ')
        : "${profile.skinTypeCapitalized} Skin Needs";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF2D6F),
            Color(0xFFFF5E8E),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF2D6F).withValues(alpha: 0.32),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Routine Badge
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.white, size: 13),
                    SizedBox(width: 5),
                    Text(
                      "ALGORITHM-CURATED",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  "⚡ Curated Kit",
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Title: {userProfile.fullName}'s Morning Routine
          Text(
            "${profile.fullName.isNotEmpty ? profile.fullName : 'Your'}'s Morning Routine",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle: Curated 3-Step Match for {userProfile.concerns.join(' & ')}
          Text(
            "Curated 3-Step Match for $concernsText",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 16),

          // Visuals: 3 miniature overlapping round product thumbnails
          Row(
            children: [
              SizedBox(
                width: 105,
                height: 46,
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      child: _buildThumbnail(bundleProducts[0].imageAsset, "1. Cleanse"),
                    ),
                    Positioned(
                      left: 28,
                      child: _buildThumbnail(bundleProducts[1].imageAsset, "2. Treat"),
                    ),
                    Positioned(
                      left: 56,
                      child: _buildThumbnail(bundleProducts[2].imageAsset, "3. Protect"),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Cleanse • Treat • SPF",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Full-size essentials",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // CTA Button: White rounded container with pink text: "Add Routine • ₹{bundlePrice}"
              GestureDetector(
                onTap: () {
                  final cart = Provider.of<CartProvider>(context, listen: false);
                  cart.addMultipleItems(bundleProducts);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text("Added 3-Step Routine to your Cart! (₹${bundlePrice.toInt()})"),
                        ],
                      ),
                      backgroundColor: const Color(0xFF1E1E24),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    "Add Routine • ₹${bundlePrice.toInt()}",
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: kPrimaryPink,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThumbnail(String url, String tooltip) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.white, width: 2.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (ctx, url) => Container(color: Colors.grey.shade200),
          errorWidget: (ctx, url, error) => const Icon(Icons.spa, size: 20, color: kPrimaryPink),
        ),
      ),
    );
  }
}
