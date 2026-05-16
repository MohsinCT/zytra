import 'package:flutter/material.dart';
import 'product_provider.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => _items;

  void add(Product product) {
    _items.add(product);
    notifyListeners();
  }

  double get total => _items.fold(0, (sum, item) => sum + item.price);
}