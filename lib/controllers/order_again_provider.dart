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
        name: "Havells Extension Board 4 Sockets",
        price: 349,
        imageUrl: "", // Handled by icon placeholder in UI
        rating: 4.5,
        ratingCount: 120,
        deliveryTime: "12 mins",
        quantity: "1 unit",
      ),
      OrderProduct(
        id: "2",
        name: "Anchor Extension Box 3 Sockets with Switch",
        price: 299,
        imageUrl: "",
        rating: 4.2,
        ratingCount: 85,
        deliveryTime: "10 mins",
        quantity: "1 unit",
      ),
      OrderProduct(
        id: "3",
        name: "GM Modular Spike Guard",
        price: 499,
        imageUrl: "",
        rating: 4.8,
        ratingCount: 230,
        deliveryTime: "15 mins",
        quantity: "1 unit",
      ),
      OrderProduct(
        id: "4",
        name: "Syska Power Strip 4 Way",
        price: 399,
        imageUrl: "",
        rating: 4.3,
        ratingCount: 94,
        deliveryTime: "12 mins",
        quantity: "1 unit",
      ),
      OrderProduct(
        id: "5",
        name: "Wipro Extension Board Heavy Duty",
        price: 549,
        imageUrl: "",
        rating: 4.6,
        ratingCount: 156,
        deliveryTime: "14 mins",
        quantity: "1 unit",
      ),
      OrderProduct(
        id: "6",
        name: "Bajaj Extension Cord 5 Sockets",
        price: 429,
        imageUrl: "",
        rating: 4.4,
        ratingCount: 110,
        deliveryTime: "11 mins",
        quantity: "1 unit",
      ),
    ];

    isLoading = false;
    notifyListeners();
  }
}
