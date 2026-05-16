import 'dart:async';
import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final String imageUrl;

  Product({required this.name, required this.price, required this.imageUrl});
}

class Category {
  final String name;
  final String imageUrl;
  final IconData? icon;

  Category({required this.name, required this.imageUrl, this.icon});
}

class BannerModel {
  final String title;
  final String category;
  final IconData icon;

  BannerModel({required this.title, required this.category, required this.icon});
}

class HomeProvider extends ChangeNotifier {
  List<Category> allCategories = [];
  List<Category> quickCategories = [];
  List<Product> popularProducts = [];
  List<BannerModel> banners = [];
  
  bool isLoading = true;
  int currentBannerIndex = 0;
  Timer? _bannerTimer;
  
  bool isSensitiveHidden = true; // State for sensitive items toggle
  
  final PageController bannerController = PageController();

  HomeProvider() {
    fetchHomeData();
  }

  void toggleSensitiveItems(bool value) {
    isSensitiveHidden = value;
    notifyListeners();
  }
  Future<void> fetchHomeData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    allCategories = [
      Category(name: 'Cleaning Essentials', imageUrl: 'assets/images/cleaning.png', icon: Icons.cleaning_services),
      Category(name: 'Laundry Needs', imageUrl: '', icon: Icons.local_laundry_service),
      Category(name: 'Kitchen Quick Needs', imageUrl: '', icon: Icons.kitchen),
      Category(name: 'Basic Electrical', imageUrl: 'assets/images/electrical.png', icon: Icons.electrical_services),
      Category(name: 'Bathroom Essentials', imageUrl: 'assets/images/bathroom.png', icon: Icons.bathtub),
      Category(name: 'Bedding Small Items', imageUrl: '', icon: Icons.bed),
      Category(name: 'Weather Essentials', imageUrl: 'assets/images/weather.png', icon: Icons.umbrella),
      Category(name: 'Emergency Items', imageUrl: 'assets/images/emergency.png', icon: Icons.flash_on),
      Category(name: 'Small Utility Items', imageUrl: '', icon: Icons.build),
      Category(name: 'Home Comfort', imageUrl: 'assets/images/comfort.png', icon: Icons.chair),
    ];

    quickCategories = [
      Category(name: 'Fashion & Clothing', imageUrl: '', icon: Icons.checkroom),
      Category(name: 'Lip Cosmetics', imageUrl: '', icon: Icons.auto_fix_high),
      Category(name: 'Eye Makeup', imageUrl: '', icon: Icons.remove_red_eye),
      Category(name: 'Hair Styling', imageUrl: '', icon: Icons.content_cut),
      Category(name: 'Luxury Beauty', imageUrl: '', icon: Icons.workspace_premium),
      Category(name: 'Perfumes & Gift Sets', imageUrl: '', icon: Icons.local_florist),
    ];

    popularProducts = [
      Product(name: 'Detergent Powder 1kg', price: 199, imageUrl: ''),
      Product(name: 'LED Bulb 9W', price: 99, imageUrl: ''),
      Product(name: 'Umbrella Black', price: 299, imageUrl: ''),
      Product(name: 'Floor Cleaner 1L', price: 149, imageUrl: ''),
      Product(name: 'Emergency Light', price: 499, imageUrl: ''),
    ];

    banners = [
      BannerModel(title: "Power cut? Get candles in minutes", category: "Emergency Items", icon: Icons.lightbulb_outline),
      BannerModel(title: "Rain started? Umbrellas in 10 mins", category: "Weather Essentials", icon: Icons.umbrella_outlined),
      BannerModel(title: "Out of detergent? Laundry sorted fast", category: "Laundry Needs", icon: Icons.local_laundry_service_outlined),
      BannerModel(title: "Kitchen mess? Cleaning essentials delivered", category: "Cleaning Essentials", icon: Icons.cleaning_services_outlined),
      BannerModel(title: "Need bulbs now? Electricals delivered fast", category: "Basic Electrical", icon: Icons.electrical_services_outlined),
    ];

    isLoading = false;
    notifyListeners();
    
    _startBannerTimer();
  }

  void _startBannerTimer() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (banners.isNotEmpty && bannerController.hasClients) {
        currentBannerIndex = (currentBannerIndex + 1) % banners.length;
        bannerController.animateToPage(
          currentBannerIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
        notifyListeners();
      }
    });
  }

  void setBannerIndex(int index) {
    currentBannerIndex = index;
    notifyListeners();
    // Restart timer on manual swipe to avoid instant auto-scroll
    _startBannerTimer();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    bannerController.dispose();
    super.dispose();
  }
}
