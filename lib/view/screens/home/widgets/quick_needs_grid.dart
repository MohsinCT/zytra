import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zytranow/controllers/home_provider.dart';
import 'package:zytranow/models/quiz_models.dart';
import 'package:zytranow/view/screens/home/widgets/shimmer_loader.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class QuickNeedsGrid extends StatelessWidget {
  final List<Category> categories;
  final int columns;
  final bool isPersonalized;
  final UserProfile? profile;

  const QuickNeedsGrid({
    super.key,
    required this.categories,
    required this.columns,
    this.isPersonalized = false,
    this.profile,
  });

  // Dynamic Image mapping for Quick Needs categories
  String _getImageForCategory(String categoryName) {
    final lower = categoryName.toLowerCase();
    if (lower.contains('ethnic')) {
      return 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?q=80&w=400';
    } else if (lower.contains('western')) {
      return 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=400';
    } else if (lower.contains('fashion')) {
      return 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=400';
    } else if (lower.contains('lip')) {
      return 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=400';
    } else if (lower.contains('eye')) {
      return 'https://images.unsplash.com/photo-1617897903246-719242758050?q=80&w=400';
    } else if (lower.contains('hair')) {
      return 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=400';
    } else if (lower.contains('serum') || lower.contains('treatment')) {
      return 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=400';
    } else if (lower.contains('perfume')) {
      return 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=400';
    } else if (lower.contains('maternity') || lower.contains('mom')) {
      return 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=400';
    } else if (lower.contains('sun') || lower.contains('spf')) {
      return 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=400';
    } else if (lower.contains('barrier') || lower.contains('balm')) {
      return 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=400';
    }
    return 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=400'; // default fallback
  }

  List<Category> _resolveCategories() {
    if (!isPersonalized || profile == null) {
      return categories;
    }

    final concerns = profile!.concerns.join(' ').toLowerCase();
    final isOily = profile!.skinType.toLowerCase().contains('oily');
    final isDry = profile!.skinType.toLowerCase().contains('dry');

    // Tile 1: Targeted concern
    Category tile1;
    if (concerns.contains('acne') ||
        concerns.contains('blemish') ||
        concerns.contains('pimple')) {
      tile1 = Category(
        name: 'Blemish Care',
        imageUrl:
            'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=400',
        icon: Icons.healing,
      );
    } else if (concerns.contains('sleep') ||
        concerns.contains('dark') ||
        concerns.contains('eye')) {
      tile1 = Category(
        name: 'Eye De-Puff',
        imageUrl:
            'https://images.unsplash.com/photo-1617897903246-719242758050?q=80&w=400',
        icon: Icons.remove_red_eye,
      );
    } else {
      tile1 = Category(
        name: 'Targeted Glow',
        imageUrl:
            'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=400',
        icon: Icons.auto_awesome,
      );
    }

    // Tile 2: Hydration tailored to skin type
    Category tile2;
    if (isOily) {
      tile2 = Category(
        name: 'Oil-Free Gels',
        imageUrl:
            'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=400',
        icon: Icons.water_drop,
      );
    } else if (isDry) {
      tile2 = Category(
        name: 'Ceramide Creams',
        imageUrl:
            'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=400',
        icon: Icons.shield,
      );
    } else {
      tile2 = Category(
        name: 'Hydra Balance',
        imageUrl:
            'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=400',
        icon: Icons.spa,
      );
    }

    // Tile 3: Routine makeup vibe match
    Category tile3;
    if (profile!.lifeStage == LifeStage.professional) {
      tile3 = Category(
        name: 'Long-Wear Matte',
        imageUrl:
            'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=400',
        icon: Icons.face,
      );
    } else if (profile!.lifeStage == LifeStage.newlywed) {
      tile3 = Category(
        name: 'Bridal Radiance',
        imageUrl:
            'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=400',
        icon: Icons.diamond,
      );
    } else {
      tile3 = Category(
        name: 'Dewy Tints',
        imageUrl:
            'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=400',
        icon: Icons.brush,
      );
    }

    // Tile 4: Daily Shield
    final tile4 = Category(
      name: 'Clean Sunscreens',
      imageUrl:
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=400',
      icon: Icons.wb_sunny,
    );

    // Tile 5: Night recovery
    final tile5 = Category(
      name: 'Barrier Balms',
      imageUrl:
          'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=400',
      icon: Icons.nightlight_round,
    );

    // Tile 6: Targeted Treatment
    final tile6 = Category(
      name: 'Active Serums',
      imageUrl:
          'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=400',
      icon: Icons.science,
    );

    return [tile1, tile2, tile3, tile4, tile5, tile6];
  }

  @override
  Widget build(BuildContext context) {
    final displayCategories = _resolveCategories();

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 18,
        crossAxisSpacing: 14,
        childAspectRatio:
            0.78, // Ratio for square squircle image + 8px space + bold label
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final cat = displayCategories[index];
        final imageUrl = cat.imageUrl.isNotEmpty
            ? cat.imageUrl
            : _getImageForCategory(cat.name);

        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 200 + (index * 50)),
          curve: Curves.easeOutCubic,
          builder: (context, val, child) {
            return Opacity(
              opacity: val,
              child: Transform.translate(
                offset: Offset(0, 16 * (1 - val)),
                child: child,
              ),
            );
          },
          child: _QuickNeedCard(category: cat, imageUrl: imageUrl),
        );
      }, childCount: displayCategories.length),
    );
  }
}

// Private stateless card widget matching the clean reference image:
// Top: Large rounded rectangle squircle image filling the container
// Bottom: Bold category name directly below the image
class _QuickNeedCard extends StatelessWidget {
  final Category category;
  final String imageUrl;

  const _QuickNeedCard({required this.category, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final isPressedNotifier = ValueNotifier<bool>(false);

    return ValueListenableBuilder<bool>(
      valueListenable: isPressedNotifier,
      builder: (context, isPressed, child) {
        return AnimatedScale(
          scale: isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: GestureDetector(
            onTapDown: (_) => isPressedNotifier.value = true,
            onTapUp: (_) {
              isPressedNotifier.value = false;
              Navigator.of(
                context,
              ).pushNamed('/category', arguments: category.name);
            },
            onTapCancel: () => isPressedNotifier.value = false,
            behavior: HitTestBehavior.opaque,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 1. Squircle Image Container (as shown in reference image)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: context.isDark ? 0.22 : 0.06,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Container(
                            color: context.isDark
                                ? const Color(0xFF1E1E22)
                                : const Color(0xFFF3F3F5),
                          ),
                          Hero(
                            tag: 'quick_category_${category.name}',
                            child: imageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const ShimmerLoader(
                                          width: double.infinity,
                                          height: double.infinity,
                                          borderRadius: 18,
                                        ),
                                    errorWidget: (context, url, error) =>
                                        Center(
                                          child: Icon(
                                            category.icon ??
                                                Icons.shopping_bag_outlined,
                                            color: const Color(0xFFFF2D6F),
                                            size: 32,
                                          ),
                                        ),
                                  )
                                : Center(
                                    child: Icon(
                                      category.icon ??
                                          Icons.shopping_bag_outlined,
                                      color: const Color(0xFFFF2D6F),
                                      size: 32,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // 2. Bold Category Name below the image
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: context.isDark
                        ? Colors.white
                        : const Color(0xFF1E2038),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
