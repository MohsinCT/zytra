import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/models/mia_models.dart';

/// Dynamic Product Card rendered from structured JSON state.
/// Supports zero-touch voice-guided shade morphing and live skin swatch updates.
class MiaProductCanvasCard extends StatelessWidget {
  final MiaProductCard product;
  final ValueChanged<int> onSelectShade;
  final ValueChanged<String> onVoiceTrigger;
  final VoidCallback? onAddToCart;

  const MiaProductCanvasCard({
    super.key,
    required this.product,
    required this.onSelectShade,
    required this.onVoiceTrigger,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final activeShade = product.activeShade;
    final isDark = context.isDark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: activeShade.color.withValues(alpha: isDark ? 0.25 : 0.15),
            blurRadius: 32,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1C1A24).withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.8),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header: Brand, Voice status pill, and rating
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              runSpacing: 2,
                              children: [
                                Text(
                                  product.brand.toUpperCase(),
                                  style: const TextStyle(
                                    color: kPrimaryPink,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kPrimaryPink.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'AI RECO',
                                    style: TextStyle(
                                      color: kPrimaryPink,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.productName,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDark ? Colors.white : kTextDark,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Rating capsule
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF2C2836)
                              : const Color(0xFFF6F6F9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? Colors.white12
                                : Colors.black.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Color(0xFFFFB800),
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${product.rating}',
                              style: TextStyle(
                                color: isDark ? Colors.white : kTextDark,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' (${product.reviewCount})',
                              style: TextStyle(
                                color: context.textMuted,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Visual Area with Animated Shade Ambient Aura
                _buildProductVisualHero(context, activeShade, isDark),

                const SizedBox(height: 16),

                // Active Shade Details Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Animated Color Circle
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutCubic,
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: activeShade.color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: activeShade.color.withValues(alpha: 0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                          border: Border.all(color: Colors.white, width: 2.5),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  child: Text(
                                    activeShade.name,
                                    key: ValueKey(activeShade.name),
                                    style: TextStyle(
                                      color: isDark ? Colors.white : kTextDark,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF2C2433)
                                        : const Color(0xFFF3E8FF),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    activeShade.finish,
                                    style: const TextStyle(
                                      color: Color(0xFF9333EA),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              activeShade.undertone,
                              style: TextStyle(
                                color: context.textMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Realistic Simulated Skin Swatch Strip
                _buildSkinSwatchVisual(context, activeShade, isDark),

                const SizedBox(height: 16),

                // Interactive Shade Selector Pills
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 8),
                  child: Text(
                    'SELECT SHADE (OR USE VOICE)',
                    style: TextStyle(
                      color: context.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                SizedBox(
                  height: 58,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: product.shades.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final shade = product.shades[index];
                      final isSelected = product.activeShadeIndex == index;

                      return GestureDetector(
                        onTap: () => onSelectShade(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark
                                      ? Colors.white.withValues(alpha: 0.15)
                                      : kPrimaryPinkLight)
                                : (isDark
                                      ? const Color(0xFF23202E)
                                      : const Color(0xFFF8F9FA)),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? kPrimaryPink
                                  : (isDark
                                        ? Colors.white10
                                        : const Color(0xFFE5E7EB)),
                              width: isSelected ? 1.8 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: shade.color,
                                  shape: BoxShape.circle,
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: shade.color.withValues(
                                              alpha: 0.6,
                                            ),
                                            blurRadius: 6,
                                          ),
                                        ]
                                      : [],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                shade.name,
                                style: TextStyle(
                                  color: isSelected
                                      ? (isDark ? Colors.white : kPrimaryPink)
                                      : (isDark
                                            ? Colors.white70
                                            : const Color(0xFF4B5563)),
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),

                // Zero-Touch Voice Demo Quick Action Chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF221927).withValues(alpha: 0.6)
                          : const Color(0xFFFAF5FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFFD8B4FE).withValues(alpha: 0.4),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.auto_awesome,
                              size: 14,
                              color: Color(0xFF9333EA),
                            ),
                            const SizedBox(width: 6),
                            const Expanded(
                              child: Text(
                                'ZERO-TOUCH VOICE TRIGGERS (SIMULATION)',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Color(0xFF9333EA),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _buildVoiceChip(
                              label: '🎤 "Show me Honey Shade"',
                              onTap: () =>
                                  onVoiceTrigger('Show me Honey Shade'),
                            ),
                            _buildVoiceChip(
                              label: '🎤 "Switch to Berry Burst"',
                              onTap: () =>
                                  onVoiceTrigger('Switch to Berry Burst'),
                            ),
                            _buildVoiceChip(
                              label: '🎤 "Switch to Ruby Velvet"',
                              onTap: () =>
                                  onVoiceTrigger('Switch to Ruby Velvet'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Bottom Action Footer: Price + Add To Bag
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: isDark ? Colors.white : kTextDark,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (product.originalPrice != null)
                            Text(
                              '\$${product.originalPrice!.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: context.textMuted,
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: ElevatedButton(
                          onPressed:
                              onAddToCart ??
                              () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Added "${product.productName} - ${activeShade.name}" to cart!',
                                    ),
                                    backgroundColor: kPrimaryPink,
                                    duration: const Duration(seconds: 2),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryPink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.shopping_bag_outlined, size: 18),
                                SizedBox(width: 6),
                                Text(
                                  'Add to Bag',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductVisualHero(
    BuildContext context,
    MiaShade activeShade,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Dynamic ambient color glow that morphs with the active shade
          AnimatedContainer(
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeOutCubic,
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.85,
                colors: [
                  activeShade.color.withValues(alpha: isDark ? 0.35 : 0.22),
                  activeShade.color.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),

          // Product Image Container with fallback beauty asset
          Container(
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isDark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.grey.withValues(alpha: 0.04),
              border: Border.all(
                color: isDark
                    ? Colors.white10
                    : Colors.black.withValues(alpha: 0.05),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Network image with smooth shade crossfade
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: CachedNetworkImage(
                      key: ValueKey(activeShade.imageUrl),
                      imageUrl: activeShade.imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: activeShade.color.withValues(alpha: 0.1),
                        child: Center(
                          child: Icon(
                            Icons.brush_rounded,
                            color: activeShade.color.withValues(alpha: 0.6),
                            size: 40,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: activeShade.color.withValues(alpha: 0.15),
                        child: Center(
                          child: Icon(
                            Icons.auto_awesome,
                            color: activeShade.color,
                            size: 48,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Soft glass gradient vignette
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            (isDark ? Colors.black : Colors.white).withValues(
                              alpha: 0.2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Top right hex code indicator tag
                  Positioned(
                    top: 12,
                    right: 12,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? Colors.white24 : Colors.white,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: activeShade.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                activeShade.hexColor,
                                style: TextStyle(
                                  color: isDark ? Colors.white : kTextDark,
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Photorealistic skin swatch simulation strip showing the shade applied on skin.
  Widget _buildSkinSwatchVisual(
    BuildContext context,
    MiaShade activeShade,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF25212E) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'SKIN SWATCH SIMULATION',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: context.textMuted,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'Arm Undertone Preview',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.black54,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Arm skin tone strip with pigment swatch swipe
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                height: 38,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      activeShade.skinToneColor,
                      activeShade.skinToneColor.withValues(alpha: 0.85),
                    ],
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Pigment swipe in the middle
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      left: 40,
                      right: 40,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        height: 18,
                        decoration: BoxDecoration(
                          color: activeShade.color,
                          borderRadius: BorderRadius.circular(9),
                          boxShadow: [
                            BoxShadow(
                              color: activeShade.color.withValues(alpha: 0.4),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Light reflection specular streak
                    Positioned(
                      left: 60,
                      right: 120,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceChip({required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFC084FC).withValues(alpha: 0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9333EA).withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF7E22CE),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
