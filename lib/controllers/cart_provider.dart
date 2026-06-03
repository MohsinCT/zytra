import 'package:flutter/material.dart';
import 'package:zytranow/models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<Product> _items = [];
  final Set<String> _wishlist = {};

  List<Product> get items => _items;

  // Return unique products in the cart for listing on the cart page
  List<Product> get uniqueItems {
    final Map<String, Product> unique = {};
    for (var item in _items) {
      unique[item.id] = item;
    }
    return unique.values.toList();
  }

  int get totalItems => _items.length;
  int get totalQuantity => _items.length;
  double get totalPrice => _items.fold(0.0, (sum, item) => sum + item.price);

  double get total => totalPrice;

  // Cart quantity helpers
  int quantityOf(String productId) {
    return _items.where((item) => item.id == productId).length;
  }

  void add(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeOne(String productId) {
    final index = _items.indexWhere((item) => item.id == productId);
    if (index != -1) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void updateQuantity(Product product, int newQty) {
    _items.removeWhere((item) => item.id == product.id);
    for (int i = 0; i < newQty; i++) {
      _items.add(product);
    }
    notifyListeners();
  }

  void clearProduct(String productId) {
    _items.removeWhere((item) => item.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  // Wishlist helpers
  Set<String> get wishlist => _wishlist;

  bool isWishlisted(String productId) {
    return _wishlist.contains(productId);
  }

  void toggleWishlist(String productId) {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
    } else {
      _wishlist.add(productId);
    }
    notifyListeners();
  }
}