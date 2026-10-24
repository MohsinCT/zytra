import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zytranow/controllers/cart_provider.dart';
import 'package:zytranow/controllers/order_again_provider.dart';
import 'package:zytranow/models/product.dart';
import 'package:zytranow/core/utils/responsive.dart';
import 'package:zytranow/view/screens/categories/product_details_screen.dart';
import 'package:zytranow/view/screens/home/widgets/shimmer_loader.dart';

/// Standard product card used in the Order Again screen.
/// Matches the exact design, interactions, wishlist toggling, quantity controls,
/// and full navigation to ProductDetailsScreen as other product cards in the app.
class OrderProductCard extends StatelessWidget {
  final Product product;
  final double imageHeight;

  const OrderProductCard({
    super.key,
    required this.product,
    this.imageHeight = 110,
  });

  factory OrderProductCard.fromOrderProduct({
    Key? key,
    required OrderProduct orderProduct,
    double imageHeight = 110,
  }) {
    return OrderProductCard(
      key: key,
      product: orderProduct.toProduct(),
      imageHeight: imageHeight,
    );
  }

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
              // 1. Image + Wishlist Button
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color:
                            isDark ? const Color(0xFF2C2C32) : Colors.grey[100],
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
                              color: isDark
                                  ? const Color(0xFF1E1E24)
                                  : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 4,
                                ),
                              ],
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
                                    : (isDark
                                        ? Colors.white70
                                        : Colors.black87),
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

              // 2. Unit details
              Text(
                product.unit,
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),

              // 3. Delivery speed
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

              // 4. Tags / Delivered badge
              if (product.tags.isNotEmpty)
                Wrap(
                  spacing: 4,
                  children: product.tags
                      .take(1)
                      .map(
                        (t) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFFF2D6F).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            t,
                            style: const TextStyle(
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

              // 5. Bottom row: Price, Name & Add/Qty button
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
            color: const Color(0xFFFF2D6F).withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => cart.removeOne(product.id),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Icon(Icons.remove, size: 14, color: Colors.white),
            ),
          ),
          Text(
            '$qty',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 11,
            ),
          ),
          InkWell(
            onTap: () => cart.add(product),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Icon(Icons.add, size: 14, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
