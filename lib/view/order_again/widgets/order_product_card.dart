import 'package:flutter/material.dart';
import 'package:zytranow/controller/order_again_provider.dart';

class OrderProductCard extends StatelessWidget {
  final OrderProduct product;

  const OrderProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Image Section
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.electrical_services,
                      size: 44,
                      color: Colors.black38,
                    ),
                  ),
                ),
              ),
              
              // 2. Details Section
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Timer and Quantity Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.timer_outlined, size: 12, color: Colors.black54),
                              const SizedBox(width: 4),
                              Text(
                                product.deliveryTime,
                                style: const TextStyle(fontSize: 10, color: Colors.black54, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              product.quantity,
                              style: const TextStyle(fontSize: 10, color: Colors.black87, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 6),
                      
                      // Product Name
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.2,
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "${product.rating} (${product.ratingCount})",
                            style: const TextStyle(fontSize: 11, color: Colors.black54),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 8),
                      
                      // Price and Add Button Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "₹${product.price.toInt()}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: const Color(0xFFFF2D6F), width: 1.5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "ADD",
                              style: TextStyle(
                                color: Color(0xFFFF2D6F),
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Absolute Positioned Wishlist Icon
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
                ],
              ),
              child: const Icon(
                Icons.favorite_border,
                size: 16,
                color: Colors.black45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
