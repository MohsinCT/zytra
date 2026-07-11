import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zytranow/controllers/category_products_provider.dart';
import 'package:zytranow/controllers/category_provider.dart';
import 'package:zytranow/controllers/cart_provider.dart';
import 'package:zytranow/controllers/tab_press_notifier.dart';
import 'package:zytranow/models/product.dart';
import 'package:zytranow/core/utils/responsive.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/view/screens/categories/product_details_screen.dart';
import 'package:zytranow/view/screens/home/widgets/shimmer_loader.dart';
import 'package:zytranow/view/widgets/floating_cart_capsule.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;

  const CategoryProductsScreen({super.key, required this.categoryName});

  String _getSidebarItemImage(String name) {
    final lower = name.toLowerCase();

    if (lower.contains('lipstick') || lower.contains('lip') || lower.contains('balm') || lower.contains('gloss')) {
      return 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=150';
    } else if (lower.contains('cleanser') || lower.contains('toner') || lower.contains('wash') || lower.contains('serum') || lower.contains('mist') || lower.contains('cream') || lower.contains('acid')) {
      return 'https://images.unsplash.com/photo-1556229010-aa3f7ff66b24?q=80&w=150';
    } else if (lower.contains('foundation') || lower.contains('compact') || lower.contains('powder') || lower.contains('concealer') || lower.contains('bb') || lower.contains('cc') || lower.contains('contour') || lower.contains('primer')) {
      return 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=150';
    } else if (lower.contains('blush') || lower.contains('highlighter')) {
      return 'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=150';
    } else if (lower.contains('kajal') || lower.contains('eyeliner') || lower.contains('mascara') || lower.contains('eye') || lower.contains('shadow') || lower.contains('brow')) {
      return 'https://images.unsplash.com/photo-1617897903246-719242758050?q=80&w=150';
    } else if (lower.contains('nail') || lower.contains('polish') || lower.contains('art') || lower.contains('coffin') || lower.contains('lacquer') || lower.contains('press-on')) {
      return 'https://images.unsplash.com/photo-1604654894610-df490651e56c?q=80&w=150';
    } else if (lower.contains('footwear') || lower.contains('shoe') || lower.contains('sneaker') || lower.contains('heel') || lower.contains('juttis') || lower.contains('flat') || lower.contains('sandal') || lower.contains('slipper')) {
      return 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?q=80&w=150';
    } else if (lower.contains('bag') || lower.contains('wallet') || lower.contains('clutch') || lower.contains('tote') || lower.contains('sling') || lower.contains('purse')) {
      return 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=150';
    } else if (lower.contains('sex') || lower.contains('wellness') || lower.contains('condom') || lower.contains('lubricant') || lower.contains('intimate')) {
      return 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=150';
    } else if (lower.contains('mehandi') || lower.contains('henna')) {
      return 'https://images.unsplash.com/photo-1562184552-997c461abbe6?q=80&w=150';
    } else if (lower.contains('pregnancy') || lower.contains('maternity') || lower.contains('pregnant') || lower.contains('postpartum') || lower.contains('nursing')) {
      return 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=150';
    } else if (lower.contains('hygiene') || lower.contains('pad') || lower.contains('tampon') || lower.contains('cup') || lower.contains('feminine')) {
      return 'https://images.unsplash.com/photo-1526947425960-945c6e72858f?q=80&w=150';
    } else if (lower.contains('straightener') || lower.contains('dryer') || lower.contains('iron') || lower.contains('curler') || lower.contains('styler')) {
      return 'https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=150';
    } else if (lower.contains('t-shirt') || lower.contains('pants') || lower.contains('clothing') || lower.contains('fashion') || lower.contains('wear') || lower.contains('dress') || lower.contains('top') || lower.contains('jeans') || lower.contains('jacket') || lower.contains('suit') || lower.contains('saree') || lower.contains('lehenga') || lower.contains('bra') || lower.contains('panty') || lower.contains('sweater') || lower.contains('hoodie') || lower.contains('robe') || lower.contains('apparel')) {
      return 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=150';
    } else if (lower.contains('hair') || lower.contains('shampoo') || lower.contains('styling') || lower.contains('oil') || lower.contains('conditioner') || lower.contains('spray') || lower.contains('wax') || lower.contains('comb') || lower.contains('brush')) {
      return 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=150';
    } else if (lower.contains('bath') || lower.contains('loofah') || lower.contains('sponge') || lower.contains('scrub') || lower.contains('soap') || lower.contains('shower')) {
      return 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=150';
    } else if (lower.contains('perfume') || lower.contains('gift') || lower.contains('scent') || lower.contains('fragrance') || lower.contains('mist') || lower.contains('deo') || lower.contains('attar')) {
      return 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=150';
    } else if (lower.contains('book') || lower.contains('novel') || lower.contains('read') || lower.contains('journal')) {
      return 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=150';
    } else if (lower.contains('paint') || lower.contains('sketch') || lower.contains('draw') || lower.contains('craft') || lower.contains('diy') || lower.contains('hobby') || lower.contains('yarn') || lower.contains('crochet') || lower.contains('needlework')) {
      return 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=150';
    } else if (lower.contains('travel') || lower.contains('luggage') || lower.contains('flight')) {
      return 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=150';
    } else if (lower.contains('cleaner') || lower.contains('detergent')) {
      return 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?q=80&w=150';
    }
    return 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=150';
  }

  void _showOptionsModal(
    BuildContext context,
    String title,
    List<String> options,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ...options.map(
                (opt) => ListTile(
                  title: Text(opt),
                  trailing: const Icon(
                    Icons.circle_outlined,
                    color: Colors.grey,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final prov = Provider.of<CategoryProductsProvider>(context);

    // Initialize state if not already set or changed
    if (prov.initializedCategoryName != categoryName) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        prov.initCategoryScreen(categoryName, categoryProvider);
      });
      return Scaffold(
        backgroundColor: context.scaffoldBackground,
        body: const Center(
          child: CircularProgressIndicator(
            color: kPrimaryPink,
          ),
        ),
      );
    }

    final products = prov.products;
    final sidebarItems = prov.sidebarItems;
    final selectedSidebarIndex = prov.selectedSidebarIndex;
    final resp = Responsive.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: context.scaffoldBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              categoryName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Delivering to Home",
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share_outlined, color: isDark ? Colors.white : Colors.black, size: 20),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: isDark ? Colors.white : Colors.black, size: 22),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(
            height: 1.0,
            thickness: 1.0,
            color: context.borderTheme,
          ),
        ),
      ),
      body: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          // 1. LEFT SIDEBAR
          Container(
            width: 88,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF141418) : const Color(0xFFF6F7F9),
              border: Border(
                right: BorderSide(
                  color: context.borderTheme,
                  width: 1.0,
                ),
              ),
            ),
            child: ListView.builder(
              itemCount: sidebarItems.length,
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemBuilder: (context, index) {
                final item = sidebarItems[index];
                final isSelected = selectedSidebarIndex == index;

                return _SidebarItem(
                  name: item,
                  imageUrl: _getSidebarItemImage(item),
                  isSelected: isSelected,
                  onTap: () {
                    prov.setSelectedSidebarIndex(index);
                    prov.loadCategory(item);
                  },
                );
              },
            ),
          ),

          // 2. RIGHT CONTENT
          Expanded(
            child: Column(
              children: [
                // Filters row
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    children: [
                      _FilterChip(
                        label: 'Filters',
                        icon: Icons.tune,
                        onTap: () {
                          _showOptionsModal(context, 'All Filters', [
                            'Discounted Items',
                            'Out of Stock',
                          ]);
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Sort',
                        icon: Icons.keyboard_arrow_down,
                        onTap: () {
                          _showOptionsModal(context, 'Sort By', [
                            'Relevance',
                            'Price - Low to High',
                            'Price - High to Low',
                            'Discount',
                          ]);
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Price',
                        icon: Icons.keyboard_arrow_down,
                        onTap: () {
                          _showOptionsModal(context, 'Price Range', [
                            'Under ₹50',
                            '₹50 - ₹100',
                            '₹100 - ₹500',
                            'Over ₹500',
                          ]);
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Brand',
                        icon: Icons.keyboard_arrow_down,
                        onTap: () {
                          _showOptionsModal(context, 'Brands', [
                            'Brand A',
                            'Brand B',
                            'Brand C',
                          ]);
                        },
                      ),
                    ],
                  ),
                ),

                // Curated Glam Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: _CategoryBanner(category: categoryName),
                ),

                // Products Grid
                Expanded(
                  child: !prov.loaded
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: kPrimaryPink,
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: resp.isDesktop ? 3 : 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.52,
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final p = products[index];
                            return _ProductCard(
                              product: p,
                              imageHeight: resp.productImageHeight,
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 24,
        child: const FloatingCartCapsule(),
      ),
    ],
  ),
);
  }
}

class _SidebarItem extends StatelessWidget {
  final String name;
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.name,
    required this.imageUrl,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final textStyle = TextStyle(
      fontSize: 10,
      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
      color: isSelected
          ? kPrimaryPink
          : (isDark ? const Color(0xFFC5C5D2) : const Color(0xFF4A4A5A)),
    );

    final itemBg = isSelected
        ? (isDark ? const Color(0xFF1E1E24) : Colors.white)
        : Colors.transparent;

    return ChangeNotifierProvider(
      create: (_) => TabPressNotifier(),
      child: Consumer<TabPressNotifier>(
        builder: (context, notifier, child) {
          final isPressed = notifier.isPressed;

          return GestureDetector(
            onTapDown: (_) => notifier.setPressed(true),
            onTapUp: (_) {
              notifier.setPressed(false);
              onTap();
            },
            onTapCancel: () => notifier.setPressed(false),
            child: AnimatedScale(
              scale: isPressed ? 0.95 : 1.0,
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                decoration: BoxDecoration(
                  color: itemBg,
                  border: Border(
                    left: BorderSide(
                      color: isSelected ? kPrimaryPink : Colors.transparent,
                      width: 3.5,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? kPrimaryPink : Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: isDark ? Colors.grey[800] : Colors.grey[300],
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.category_outlined,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textStyle,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E24) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: context.borderTheme),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[800],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 4),
              Icon(icon, size: 14, color: isDark ? Colors.grey[300] : Colors.grey[800]),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategoryBanner extends StatelessWidget {
  final String category;
  const _CategoryBanner({required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final bgColor = isDark ? const Color(0xFF2C221E) : const Color(0xFFFFF6E6);
    final titleColor = isDark ? Colors.white : const Color(0xFF1E1E24);
    final subtitleColor = isDark ? Colors.grey[400] : const Color(0xFF5A5A6A);

    return Container(
      height: 110,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : const Color(0xFFFFE0B2).withOpacity(0.4),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Curated Glam",
                  style: TextStyle(
                    color: titleColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "With long-lasting wear",
                  style: TextStyle(
                    color: subtitleColor,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E1E24),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Shop now",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: 'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=200',
              width: 100,
              height: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const SizedBox(width: 100),
              errorWidget: (context, url, error) => const SizedBox(width: 100),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final double imageHeight;
  const _ProductCard({required this.product, this.imageHeight = 110});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final qty = cart.quantityOf(product.id);
    final resp = Responsive.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? const Color(0xFF1E1E24) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsScreen(product: product),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(resp.scale(6.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image + wishlist
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF2C2C32) : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      alignment: Alignment.center,
                      child: product.imageAsset.isNotEmpty
                          ? Hero(
                              tag: 'product_image_${product.id}',
                              child: product.imageAsset.startsWith('http')
                                  ? CachedNetworkImage(
                                      imageUrl: product.imageAsset,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) =>
                                          const ShimmerLoader(
                                            width: double.infinity,
                                            height: double.infinity,
                                            borderRadius: 10,
                                          ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                            Icons.image_not_supported,
                                            size: 24,
                                            color: Colors.grey,
                                          ),
                                    )
                                  : Image.asset(
                                      product.imageAsset,
                                      fit: BoxFit.contain,
                                      ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Consumer<CartProvider>(
                        builder: (context, cart, child) {
                          final isFav = cart.isWishlisted(product.id);
                          return Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E1E24) : Colors.white,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onPressed: () {
                                cart.toggleWishlist(product.id);
                              },
                              icon: Icon(
                                isFav ? Icons.favorite : Icons.favorite_border,
                                color: isFav
                                    ? const Color(0xFFFF2D6F)
                                    : (isDark ? Colors.white70 : Colors.black87),
                                size: 16,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                product.unit,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.timer, size: 12, color: Colors.grey),
                  const SizedBox(width: 3),
                  Text(
                    product.deliveryTime,
                    style: TextStyle(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // tags
              if (product.tags.isNotEmpty)
                Wrap(
                  spacing: 4,
                  children: product.tags
                      .map(
                        (t) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF2D6F).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "Bestseller",
                            style: TextStyle(
                              fontSize: 9,
                              color: Color(0xFFFF2D6F),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              const SizedBox(height: 6),
              // bottom row: price + add
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          product.name,
                          style: TextStyle(
                            color: isDark ? Colors.grey[300] : Colors.grey[800],
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  qty > 0
                      ? _QtyControls(product: product, qty: qty)
                      : _AddButton(product: product),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final Product product;
  const _AddButton({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        cart.add(product);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF1E1E24),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 120),
            duration: const Duration(seconds: 1),
            content: Text('Added ${product.name} to Cart!'),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFF2D6F), width: 1.5),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const Text(
          'ADD',
          style: TextStyle(
            color: Color(0xFFFF2D6F),
            fontWeight: FontWeight.w900,
            fontSize: 11,
          ),
        ),
      ),
    );
  }
}

class _QtyControls extends StatelessWidget {
  final Product product;
  final int qty;
  const _QtyControls({required this.product, required this.qty});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: const Color(0xFFFF2D6F),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF2D6F).withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => cart.removeOne(product.id),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Icon(Icons.remove, size: 12, color: Colors.white),
            ),
          ),
          Text(
            qty.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 11,
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => cart.add(product),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Icon(Icons.add, size: 12, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
