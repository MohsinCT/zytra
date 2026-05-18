import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zytranow/controllers/home_provider.dart';
import 'package:zytranow/view/screens/home/widgets/shimmer_loader.dart';

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
        crossAxisCount: 3, // Always 2 cards per row as requested
        mainAxisSpacing: 20,
        crossAxisSpacing: 16,
        childAspectRatio: 0.85, // Perfect ratio for top image + bottom text
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final cat = categories[index];
        final imageUrl = _getImageForCategory(cat.name);

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

// Stateful card widget to handle the tap scale bounce animations locally
class _QuickNeedCard extends StatefulWidget {
  final Category category;
  final String imageUrl;

  const _QuickNeedCard({required this.category, required this.imageUrl});

  @override
  State<_QuickNeedCard> createState() => _QuickNeedCardState();
}

class _QuickNeedCardState extends State<_QuickNeedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    Navigator.of(
      context,
    ).pushNamed('/category', arguments: widget.category.name);
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(
                0xFFFF2D7A,
              ).withOpacity(0.06), // Soft pink shadow
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFFF2D7A).withOpacity(0.08), // Elegant borders
            width: 1.5,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Soft feminine themed image/banner
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
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
                          tag: 'quick_category_${widget.category.name}',
                          child: CachedNetworkImage(
                            imageUrl: widget.imageUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const ShimmerLoader(
                              width: double.infinity,
                              height: double.infinity,
                              borderRadius: 20,
                            ),
                            errorWidget: (context, url, error) => const Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),

                      // Touch ink response overlay
                      Positioned.fill(
                        child: Material(
                          color: Colors.transparent,
                          child: GestureDetector(
                            onTapDown: _onTapDown,
                            onTapUp: _onTapUp,
                            onTapCancel: _onTapCancel,
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
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Text(
                widget.category.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900, // Bold modern typography
                  color: Colors.black87,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
