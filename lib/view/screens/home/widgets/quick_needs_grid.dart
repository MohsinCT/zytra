import 'package:flutter/material.dart';
import 'package:zytranow/controllers/home_provider.dart';
import 'package:zytranow/view/screens/home/widgets/shimmer_loader.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class QuickNeedsGrid extends StatelessWidget {
  final List<Category> categories;
  final int columns;

  const QuickNeedsGrid({
    super.key,
    required this.categories,
    required this.columns,
  });

  // Dynamic Image mapping for Quick Needs categories
  String _getImageForCategory(String categoryName) {
    final lower = categoryName.toLowerCase();
    if (lower.contains('fashion')) {
      return 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=600';
    } else if (lower.contains('lip')) {
      return 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=600';
    } else if (lower.contains('eye')) {
      return 'https://images.unsplash.com/photo-1617897903246-719242758050?q=80&w=600';
    } else if (lower.contains('hair')) {
      return 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=600';
    } else if (lower.contains('luxury')) {
      return 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=600';
    } else if (lower.contains('perfume')) {
      return 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=600';
    }
    return 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=600'; // default fallback
  }

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Always 3 cards per row
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85, // Perfect ratio for top image + bottom text
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final cat = categories[index];
        final imageUrl = cat.imageUrl.isNotEmpty ? cat.imageUrl : _getImageForCategory(cat.name);

        // Premium Fade-in on Load entrance animation
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 300 + (index * 80)),
          curve: Curves.easeOutCubic,
          builder: (context, val, child) {
            return Opacity(
              opacity: val,
              child: Transform.translate(
                offset: Offset(0, 30 * (1 - val)),
                child: child,
              ),
            );
          },
          child: _QuickNeedCard(category: cat, imageUrl: imageUrl),
        );
      }, childCount: categories.length),
    );
  }
}

// Private stateless card widget to handle the tap scale bounce animations locally
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
          child: Container(
            decoration: BoxDecoration(
              color: context.cardBackground,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF2D7A).withValues(
                    alpha: context.isDark ? 0.01 : 0.06,
                  ), // Soft pink shadow
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: const Color(0xFFFF2D7A).withValues(
                  alpha: context.isDark ? 0.03 : 0.08,
                ), // Elegant borders
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Soft feminine themed image/banner
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        20,
                      ), // 20 radius rounded corner
                      child: Stack(
                        children: [
                          // Pastel background gradient
                          Positioned.fill(
                            child: Container(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFFF0F5),
                                    Color(0xFFFFE4E1),
                                  ], // Lavender blush to Misty Rose
                                ),
                              ),
                            ),
                          ),

                          // Unsplash high-res category banner
                          Positioned.fill(
                            child: Hero(
                              tag: 'quick_category_${category.name}',
                              child: imageUrl.isNotEmpty
                                  ? Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const ShimmerLoader(
                                          width: double.infinity,
                                          height: double.infinity,
                                          borderRadius: 20,
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) => Center(
                                        child: Icon(
                                          category.icon ?? Icons.shopping_bag_outlined,
                                          color: const Color(0xFFFF2D6F),
                                          size: 32,
                                        ),
                                      ),
                                    )
                                  : Center(
                                      child: Icon(
                                        category.icon ?? Icons.shopping_bag_outlined,
                                        color: const Color(0xFFFF2D6F),
                                        size: 32,
                                      ),
                                    ),
                            ),
                          ),

                          // Touch ink response overlay
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: GestureDetector(
                                onTapDown: (_) =>
                                    isPressedNotifier.value = true,
                                onTapUp: (_) {
                                  isPressedNotifier.value = false;
                                  Navigator.of(context).pushNamed(
                                    '/category',
                                    arguments: category.name,
                                  );
                                },
                                onTapCancel: () =>
                                    isPressedNotifier.value = false,
                                behavior: HitTestBehavior.opaque,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 2. Category name centered below the image
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900, // Bold modern typography
                      color: context.textDark,
                      letterSpacing: 0.3,
                    ),
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
