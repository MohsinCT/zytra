import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zytranow/models/product.dart';
import 'package:zytranow/services/product_service.dart';

class SearchProvider extends ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  String _query = '';
  List<Product> _results = [];
  bool _isSearching = false;

  String get query => _query;
  List<Product> get results => _results;
  bool get isSearching => _isSearching;

  SearchProvider() {
    controller.addListener(_onSearchQueryChanged);
  }

  void _onSearchQueryChanged() {
    performSearch(controller.text);
  }

  Future<void> performSearch(String newQuery, {String? category}) async {
    final queryText = newQuery.trim();
    if (_query == queryText) return;
    _query = queryText;

    if (queryText.isEmpty) {
      _results = [];
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    final searchResults = await ProductService.searchProducts(queryText, category: category);

    // Guard against race conditions
    if (_query == queryText) {
      _results = searchResults;
      _isSearching = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    controller.clear();
    _query = '';
    _results = [];
    _isSearching = false;
    notifyListeners();
  }

  @override
  void dispose() {
    controller.removeListener(_onSearchQueryChanged);
    controller.dispose();
    super.dispose();
  }
}
