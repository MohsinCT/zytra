import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zytranow/models/product.dart';
import 'package:zytranow/controllers/cart_provider.dart';
import 'package:zytranow/view/screens/categories/product_details_screen.dart';
import 'package:zytranow/view/screens/home/widgets/shimmer_loader.dart';

class PopularProductList extends StatelessWidget {
  final List<Product> products;

  const PopularProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: products.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, i) {
          final product = products[i];
          final isNetworkImage = product.imageAsset.isNotEmpty &&
              (product.imageAsset.startsWith('http://') || product.imageAsset.startsWith('https://'));

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
              margin: const EdgeInsets.only(left: 6, right: 6, bottom: 8, top: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.vertical(
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
                                      placeholder: (context, url) => const ShimmerLoader(
                                        width: double.infinity,
                                        height: double.infinity,
                                        borderRadius: 16,
                                      ),
                                      errorWidget: (context, url, error) => const Icon(
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
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            height: 1.2,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "₹${product.price.toInt()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Consumer<CartProvider>(
                              builder: (context, cart, child) {
                                final qty = cart.quantityOf(product.id);

                                return qty > 0
                                    ? Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFF2D6F),
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFFFF2D6F).withOpacity(0.2),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () => cart.removeOne(product.id),
                                              child: const Padding(
                                                padding: EdgeInsets.all(6.0),
                                                child: Icon(Icons.remove, size: 12, color: Colors.white),
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
                                                child: Icon(Icons.add, size: 12, color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : GestureDetector(
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
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              color: const Color(0xFFFF2D6F),
                                              width: 1.5,
                                            ),
                                            borderRadius: BorderRadius.circular(8),
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
