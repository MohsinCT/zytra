import 'package:flutter/material.dart';
import 'dart:async';

class CarouselProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  Timer? _timer;
  int currentIndex = 0;

  final List<String> images = [
    'https://images.unsplash.com/photo-1590156546946-ce55a12a6a5d?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1522337660859-02fbefca4702?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1612817288484-6f916006741a?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1599305090598-fe179d501227?auto=format&fit=crop&w=800&q=80',
  ];

  CarouselProvider() {
    _startCarousel();
  }

  void setIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void _startCarousel() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (pageController.hasClients) {
        currentIndex = (currentIndex + 1) % images.length;
        pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    pageController.dispose();
    super.dispose();
  }
}
