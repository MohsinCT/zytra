import 'package:flutter/material.dart';

class OrderProduct {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final double rating;
  final int ratingCount;
  final String deliveryTime;
  final String quantity;

  OrderProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.ratingCount,
    required this.deliveryTime,
    required this.quantity,
  });
}

class OrderAgainProvider extends ChangeNotifier {
  List<OrderProduct> products = [];
  bool isLoading = true;

  OrderAgainProvider() {
    _fetchProducts();
  }

  void _fetchProducts() async {
    // Simulate API fetch delay
    await Future.delayed(const Duration(milliseconds: 800));

    products = [
      OrderProduct(
        id: "1",
        name: "Luxe Velvet Matte Lipstick",
        price: 499,
        imageUrl: "https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=300",
        rating: 4.8,
        ratingCount: 452,
        deliveryTime: "8 mins",
        quantity: "1 unit",
      ),
      OrderProduct(
        id: "2",
        name: "Glow Dewy Finishing Setting Spray",
        price: 349,
        imageUrl: "https://images.unsplash.com/photo-1625093742435-6fa192b6fb10?q=80&w=300",
        rating: 4.6,
        ratingCount: 128,
        deliveryTime: "9 mins",
        quantity: "1 unit",
      ),
      OrderProduct(
        id: "3",
        name: "Vitamin C Glow Face Serum",
        price: 599,
        imageUrl: "https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=300",
        rating: 4.7,
        ratingCount: 320,
        deliveryTime: "8 mins",
        quantity: "50 ml",
      ),
      OrderProduct(
        id: "4",
        name: "Rose Water & Mist Toner",
        price: 199,
        imageUrl: "https://images.unsplash.com/photo-1556229010-aa3f7ff66b24?q=80&w=300",
        rating: 4.5,
        ratingCount: 180,
        deliveryTime: "10 mins",
        quantity: "100 ml",
      ),
      OrderProduct(
        id: "5",
        name: "Coconut Hair Repair Mask",
        price: 429,
        imageUrl: "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=300",
        rating: 4.8,
        ratingCount: 230,
        deliveryTime: "12 mins",
        quantity: "200 ml",
      ),
      OrderProduct(
        id: "6",
        name: "Luxury Velvet Powder Puff",
        price: 149,
        imageUrl: "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=300",
        rating: 4.4,
        ratingCount: 95,
        deliveryTime: "11 mins",
        quantity: "1 pack",
      ),
    ];

    isLoading = false;
    notifyListeners();
  }
}
