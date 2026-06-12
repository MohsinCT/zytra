import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zytranow/models/product.dart';
import 'package:zytranow/core/utils/responsive.dart';
import 'package:zytranow/view/screens/home/widgets/shimmer_loader.dart';
import 'package:zytranow/controllers/cart_provider.dart';
import 'package:zytranow/controllers/search_provider.dart';
import 'package:zytranow/controllers/product_details_provider.dart';
import 'package:zytranow/view/screens/categories/product_details_screen.dart';

class SearchScreen extends StatelessWidget {
  final String? category;

  const SearchScreen({super.key, this.category});

  @override
  Widget build(BuildContext context) {
    final resp = Responsive.of(context);

    return ChangeNotifierProvider(
      create: (_) => SearchProvider(),
      child: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) {
          final results = searchProvider.results;
          final query = searchProvider.query;
          final isSearching = searchProvider.isSearching;

          return Scaffold(
            backgroundColor: const Color(0xFFF5F5F5), // Light background
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        controller: searchProvider.controller,
                        autofocus: true,
                        onChanged: (text) => searchProvider.performSearch(text, category: category),
                        decoration: InputDecoration(
                          hintText: category != null 
                              ? "Search in $category..." 
                              : "What do you need?",
                          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 15),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.black54),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(minWidth: 40),
                          suffixIcon: query.isNotEmpty 
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.black54),
                                  onPressed: () {
                                    searchProvider.clearSearch();
                                  },
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFFF2D6F),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.search, color: Colors.white, size: 20),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  
                  Expanded(
                    child: query.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search, size: 60, color: Colors.grey.shade300),
                                const SizedBox(height: 16),
                                Text(
                                  category != null 
                                      ? "Search within $category" 
                                      : "Search across all categories",
                                  style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                                ),
                              ],
                            ),
                          )
                        : isSearching
                            ? GridView.builder(
                                padding: EdgeInsets.symmetric(horizontal: resp.scale(12), vertical: resp.scale(10)),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: resp.gridColumns,
                                  mainAxisSpacing: resp.scale(12),
                                  crossAxisSpacing: resp.scale(12),
                                  childAspectRatio: resp.isDesktop ? 0.75 : 0.56,
                                ),
                                itemCount: 6,
                                itemBuilder: (context, index) {
                                  return ShimmerLoader(
                                    width: double.infinity,
                                    height: resp.productImageHeight + 110,
                                    borderRadius: 12,
                                  );
                                },
                              )
                            : results.isEmpty
                                ? Center(
                                    child: Text("No products found for '$query'", style: TextStyle(color: Colors.grey.shade600)),
                                  )
                                : GridView.builder(
                                    padding: EdgeInsets.symmetric(horizontal: resp.scale(12), vertical: resp.scale(10)),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: resp.gridColumns,
                                      mainAxisSpacing: resp.scale(12),
                                      crossAxisSpacing: resp.scale(12),
                                      childAspectRatio: resp.isDesktop ? 0.75 : 0.56,
                                    ),
                                    itemCount: results.length,
                                    itemBuilder: (context, index) {
                                      final p = results[index];
                                      return _SearchProductCard(product: p, imageHeight: resp.productImageHeight);
                                    },
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

// Copy of ProductCard from CategoryProductsScreen
class _SearchProductCard extends StatelessWidget {
  final Product product;
  final double imageHeight;
  const _SearchProductCard({required this.product, this.imageHeight = 110});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final qty = cart.quantityOf(product.id);
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
              builder: (context) => ChangeNotifierProvider(
                create: (_) => ProductDetailsProvider(product),
                child: ProductDetailsScreen(product: product),
              ),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(resp.scale(8.0)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image + wishlist (Expanded to consume leftover space)
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
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
              ),
              SizedBox(height: resp.scale(8)),
              Text(product.unit, style: TextStyle(color: Colors.grey[600], fontSize: resp.scale(12))),
              SizedBox(height: resp.scale(6)),
              Row(
                children: [
                  const Icon(Icons.timer, size: 14, color: Colors.grey),
                  SizedBox(width: resp.scale(4)),
                  Text(product.deliveryTime, style: TextStyle(color: Colors.grey[600], fontSize: resp.scale(12))),
                ],
              ),
              SizedBox(height: resp.scale(8)),
              // tags
              if (product.tags.isNotEmpty)
                Wrap(
                  spacing: 6,
                  children: product.tags.map((t) => Container(
                    padding: EdgeInsets.symmetric(horizontal: resp.scale(8), vertical: resp.scale(4)),
                    decoration: BoxDecoration(color: Colors.pink.shade50, borderRadius: BorderRadius.circular(8)),
                    child: Text(t, style: TextStyle(fontSize: resp.scale(11), color: Colors.pink)),
                  )).toList(),
                ),
              SizedBox(height: resp.scale(8)),
              // bottom row: price + add
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('₹${product.price.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: resp.scale(14), color: Colors.black)),
                        SizedBox(height: resp.scale(2)),
                        Text(
                          product.name, 
                          style: TextStyle(color: Colors.grey[800], fontSize: MediaQuery.of(context).size.width * 0.03), 
                          maxLines: 2, 
                          overflow: TextOverflow.ellipsis
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  qty > 0 ? _SearchQtyControls(product: product, qty: qty) : _SearchAddButton(product: product),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchAddButton extends StatelessWidget {
  final Product product;
  const _SearchAddButton({required this.product});

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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 120),
            duration: const Duration(seconds: 1),
            content: Text('Added ${product.name} to Cart!'),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFF2D6F), width: 1.5),
          boxShadow: const [BoxShadow(color: Color(0x0A000000), blurRadius: 4, offset: Offset(0,2))],
        ),
        child: const Text('ADD', style: TextStyle(color: Color(0xFFFF2D6F), fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }
}

class _SearchQtyControls extends StatelessWidget {
  final Product product;
  final int qty;
  const _SearchQtyControls({required this.product, required this.qty});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFF2D6F),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF2D6F).withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.remove, size: 16, color: Colors.white), 
            onPressed: () => cart.removeOne(product.id)
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              qty.toString(), 
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 13)
            ),
          ),
          IconButton(
            constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.add, size: 16, color: Colors.white), 
            onPressed: () => cart.add(product)
          ),
        ],
      ),
    );
  }
}
