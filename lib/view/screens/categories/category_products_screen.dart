import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zytranow/controllers/category_products_provider.dart';
import 'package:zytranow/controllers/cart_provider.dart';
import 'package:zytranow/models/product.dart';
import 'package:zytranow/core/utils/responsive.dart';
import 'package:zytranow/view/screens/categories/product_details_screen.dart';
import 'package:zytranow/view/screens/home/widgets/shimmer_loader.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryName;

  const CategoryProductsScreen({super.key, required this.categoryName});

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
                    // Optional: Trigger provider logic here
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
    final prov = Provider.of<CategoryProductsProvider>(context);

    // Ensure category loaded if not already
    if (!prov.loaded || prov.category != categoryName) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => prov.loadCategory(categoryName),
      );
    }

    final products = prov.products;
    final resp = Responsive.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          categoryName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.black),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.tune, color: Colors.black),
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters row
          SizedBox(
            height: resp.scale(55),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: resp.scale(12),
                vertical: resp.scale(8),
              ),
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
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Type',
                  icon: Icons.keyboard_arrow_down,
                  onTap: () {
                    _showOptionsModal(context, 'Type', [
                      'Type 1',
                      'Type 2',
                      'Type 3',
                    ]);
                  },
                ),
              ],
            ),
          ),

          // Banner
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: resp.scale(12.0),
              vertical: resp.scale(8),
            ),
            child: _CategoryBanner(category: categoryName),
          ),

          // Products grid
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: resp.scale(12),
                vertical: resp.scale(10),
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: resp.gridColumns,
                mainAxisSpacing: resp.scale(12),
                crossAxisSpacing: resp.scale(12),
                childAspectRatio: resp.isDesktop ? 0.75 : 0.66,
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300),
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
                color: Colors.grey[800],
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 4),
              Icon(icon, size: 16, color: Colors.grey[800]),
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
    final text = _bannerTextFor(category);
    final resp = Responsive.of(context);

    return Container(
      padding: EdgeInsets.all(resp.scale(16)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF2D7A), Color(0xFFFF6A9A)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          // small illustration placeholder
          SizedBox(width: resp.scale(12)),
          Container(
            width: resp.scale(48),
            height: resp.scale(48),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
    );
  }

  String _bannerTextFor(String category) {
    final c = category.toLowerCase();
    if (c.contains('weather'))
      return 'Rainy Day Essentials Delivered in Minutes';
    if (c.contains('electrical'))
      return 'Daily Electrical Needs Instantly Available';
    return '$category Delivered in Minutes';
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final double imageHeight;
  const _ProductCard({required this.product, this.imageHeight = 110});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CategoryProductsProvider>(context);
    final qty = prov.quantityFor(product.id);
    final resp = Responsive.of(context);

    return Material(
      color: Colors.white,
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
          padding: EdgeInsets.all(resp.scale(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image + wishlist
              Stack(
                children: [
                  Container(
                    height: imageHeight,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: product.imageAsset.isNotEmpty
                        ? Hero(
                            tag: 'product_image_${product.id}',
                            child: product.imageAsset.startsWith('http')
                                ? CachedNetworkImage(
                                    imageUrl: product.imageAsset,
                                    width: resp.scale(90),
                                    height: resp.scale(90),
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => const ShimmerLoader(
                                      width: double.infinity,
                                      height: double.infinity,
                                      borderRadius: 10,
                                    ),
                                    errorWidget: (context, url, error) => const Icon(
                                      Icons.image_not_supported,
                                      size: 30,
                                      color: Colors.grey,
                                    ),
                                  )
                                : Image.asset(
                                    product.imageAsset,
                                    width: resp.scale(90),
                                    height: resp.scale(90),
                                    fit: BoxFit.contain,
                                  ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Consumer<CartProvider>(
                      builder: (context, cart, child) {
                        final isFav = cart.isWishlisted(product.id);
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: IconButton(
                            onPressed: () {
                              cart.toggleWishlist(product.id);
                            },
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? const Color(0xFFFF2D6F) : Colors.black87,
                              size: 18,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: resp.scale(8)),
              Text(
                product.unit,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: resp.scale(12),
                ),
              ),
              SizedBox(height: resp.scale(6)),
              Row(
                children: [
                  const Icon(Icons.timer, size: 14, color: Colors.grey),
                  SizedBox(width: resp.scale(4)),
                  Text(
                    product.deliveryTime,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: resp.scale(12),
                    ),
                  ),
                ],
              ),
              SizedBox(height: resp.scale(8)),
              // tags
              if (product.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children: product.tags
                      .map(
                        (t) => Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: resp.scale(8),
                            vertical: resp.scale(4),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pink.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            t,
                            style: TextStyle(
                              fontSize: resp.scale(11),
                              color: Colors.pink,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              const Spacer(),
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
                            fontWeight: FontWeight.bold,
                            fontSize: resp.scale(14),
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: resp.scale(2)),
                        Text(
                          product.name,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: MediaQuery.of(context).size.width * 0.03,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  qty > 0
                      ? _QtyControls(productId: product.id, qty: qty)
                      : _AddButton(productId: product.id),
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
  final String productId;
  const _AddButton({required this.productId});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CategoryProductsProvider>(context, listen: false);
    return GestureDetector(
      onTap: () => prov.increment(productId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFF2D7A)),
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
            color: Color(0xFFFF2D7A),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _QtyControls extends StatelessWidget {
  final String productId;
  final int qty;
  const _QtyControls({required this.productId, required this.qty});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<CategoryProductsProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.remove, size: 18),
            onPressed: () => prov.decrement(productId),
          ),
          Text(
            qty.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.add, size: 18, color: Color(0xFFFF2D7A)),
            onPressed: () => prov.increment(productId),
          ),
        ],
      ),
    );
  }
}
