import 'dart:async';
import 'package:flutter/material.dart';
import 'package:zytranow/models/product.dart';

class ProductDetailsProvider extends ChangeNotifier {
  final Product product;
  late final PageController pageController;
  Timer? _carouselTimer;
  int _currentImageIndex = 0;
  String? _selectedVariant;
  bool _isLiked = false;

  ProductDetailsProvider(this.product) {
    pageController = PageController(initialPage: 0);
    _selectedVariant = product.variants.isNotEmpty ? product.variants.first : null;

    // Auto slide carousel every 3 seconds
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (product.images.isNotEmpty) {
        int nextIndex = (_currentImageIndex + 1) % product.images.length;
        if (pageController.hasClients) {
          pageController.animateToPage(
            nextIndex,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOutCubic,
          );
        }
      }
    });
  }

  int get currentImageIndex => _currentImageIndex;
  String? get selectedVariant => _selectedVariant;
  bool get isLiked => _isLiked;

  void setImageIndex(int index) {
    _currentImageIndex = index;
    notifyListeners();
  }

  void selectVariant(String variant) {
    _selectedVariant = variant;
    notifyListeners();
  }

  void toggleLike() {
    _isLiked = !_isLiked;
    notifyListeners();
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    pageController.dispose();
    super.dispose();
  }
}
