import 'package:flutter/foundation.dart';
import 'package:zytranow/model/product.dart';
import 'package:zytranow/services/product_service.dart';

class CategoryProductsProvider extends ChangeNotifier {
  String _category = 'Cleaning Essentials';
  List<Product> _products = [];
  final Map<String, int> _quantities = {}; // productId -> qty

  String get category => _category;
  List<Product> get products => List.unmodifiable(_products);
  int quantityFor(String productId) => _quantities[productId] ?? 0;

  void loadCategory(String categoryName) {
    _category = categoryName;
    _products = ProductService.productsForCategory(categoryName);
    notifyListeners();
  }

  void increment(String productId) {
    _quantities[productId] = (_quantities[productId] ?? 0) + 1;
    notifyListeners();
  }

  void decrement(String productId) {
    final current = (_quantities[productId] ?? 0);
    if (current <= 1) {
      _quantities.remove(productId);
    } else {
      _quantities[productId] = current - 1;
    }
    notifyListeners();
  }
}
