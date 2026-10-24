import 'package:flutter/material.dart';
import 'package:zytranow/models/product.dart';

/// Legacy model retained for backward compatibility if referenced elsewhere
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

  Product toProduct() {
    return Product(
      id: id,
      name: name,
      imageAsset: imageUrl,
      unit: quantity,
      price: price,
      deliveryTime: deliveryTime,
      rating: rating,
      reviews: ratingCount,
      tags: const ['Delivered'],
    );
  }
}

class OrderAgainProvider extends ChangeNotifier {
  List<Product> products = [];
  bool isLoading = true;

  OrderAgainProvider() {
    _fetchProducts();
  }

  void addRecentlyOrderedProducts(List<Product> newProducts) {
    for (final p in newProducts) {
      products.removeWhere((existing) => existing.id == p.id);
      final deliveredProduct = Product(
        id: p.id,
        name: p.name,
        imageAsset: p.imageAsset,
        unit: p.unit,
        price: p.price,
        deliveryTime: p.deliveryTime,
        tags: p.tags.contains('Delivered') ? p.tags : ['Delivered', ...p.tags],
        rating: p.rating,
        reviews: p.reviews,
        description: p.description,
        mrp: p.mrp,
        soldCount: p.soldCount,
        brand: p.brand,
        category: p.category,
        images: p.images,
        specifications: p.specifications,
        variants: p.variants,
        similarProducts: p.similarProducts,
        suitableSkinTypes: p.suitableSkinTypes,
        targetedConcerns: p.targetedConcerns,
        ingredients: p.ingredients,
        isCleanFormula: p.isCleanFormula,
      );
      products.insert(0, deliveredProduct);
    }
    notifyListeners();
  }

  void syncDeliveredProducts(List<Product> delivered) {
    bool changed = false;
    for (final p in delivered) {
      final exists = products.any((existing) => existing.id == p.id);
      if (!exists) {
        final deliveredProduct = Product(
          id: p.id,
          name: p.name,
          imageAsset: p.imageAsset,
          unit: p.unit,
          price: p.price,
          deliveryTime: p.deliveryTime,
          tags: p.tags.contains('Delivered') ? p.tags : ['Delivered', ...p.tags],
          rating: p.rating,
          reviews: p.reviews,
          description: p.description,
          mrp: p.mrp,
          soldCount: p.soldCount,
          brand: p.brand,
          category: p.category,
          images: p.images,
          specifications: p.specifications,
          variants: p.variants,
          similarProducts: p.similarProducts,
          suitableSkinTypes: p.suitableSkinTypes,
          targetedConcerns: p.targetedConcerns,
          ingredients: p.ingredients,
          isCleanFormula: p.isCleanFormula,
        );
        products.insert(0, deliveredProduct);
        changed = true;
      }
    }
    if (changed) {
      notifyListeners();
    }
  }

  void _fetchProducts() async {
    // Quick async simulation
    await Future.delayed(const Duration(milliseconds: 200));

    // Curated initial delivered products with full product models
    products = [
      Product(
        id: "velvet_matte_lipstick",
        name: "Luxe Velvet Matte Lipstick",
        price: 399,
        imageAsset:
            "https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=600",
        rating: 4.8,
        reviews: 452,
        deliveryTime: "8 mins",
        unit: "1 unit",
        brand: "MAC",
        category: "Lip Color",
        tags: const ["Delivered", "Bestseller"],
        description:
            "Rich velvet matte finish that delivers bold, fade-proof color.",
      ),
      Product(
        id: "niacinamide_serum",
        name: "Advanced Niacinamide Serum",
        price: 599,
        imageAsset:
            "https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=600",
        rating: 4.6,
        reviews: 128,
        deliveryTime: "9 mins",
        unit: "30 ml",
        brand: "Minimalist",
        category: "Face Serums",
        tags: const ["Delivered"],
        description:
            "Pure 10% Niacinamide formula that reduces sebum and balances blemishes.",
      ),
      Product(
        id: "glow_setting_spray",
        name: "Glow Dewy Finishing Setting Spray",
        price: 349,
        imageAsset:
            "https://images.unsplash.com/photo-1625093742435-6fa192b6fb10?q=80&w=600",
        rating: 4.6,
        reviews: 128,
        deliveryTime: "9 mins",
        unit: "1 unit",
        brand: "evermi",
        category: "Face Base",
        tags: const ["Delivered"],
        description:
            "Ultra-fine micro mist that locks in makeup for 16-hour hydration.",
      ),
      Product(
        id: "rose_mist_toner",
        name: "Rose Water & Mist Toner",
        price: 199,
        imageAsset:
            "https://images.unsplash.com/photo-1556229010-aa3f7ff66b24?q=80&w=600",
        rating: 4.5,
        reviews: 180,
        deliveryTime: "10 mins",
        unit: "100 ml",
        brand: "evermi",
        category: "Serums & Toners",
        tags: const ["Delivered"],
        description:
            "Pure steam-distilled rose water to refresh, balance, and calm skin.",
      ),
      Product(
        id: "coconut_hair_mask",
        name: "Coconut Hair Repair Mask",
        price: 429,
        imageAsset:
            "https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600",
        rating: 4.8,
        reviews: 230,
        deliveryTime: "12 mins",
        unit: "200 ml",
        brand: "evermi",
        category: "Hair Masks & Serums",
        tags: const ["Delivered"],
        description:
            "Deep conditioning hair repair mask enriched with pure cold-pressed coconut oil.",
      ),
      Product(
        id: "powder_puff",
        name: "Luxury Velvet Powder Puff",
        price: 149,
        imageAsset:
            "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=600",
        rating: 4.4,
        reviews: 95,
        deliveryTime: "11 mins",
        unit: "1 pack",
        brand: "evermi",
        category: "Beauty Accessories",
        tags: const ["Delivered"],
        description:
            "Ultra-soft velvet triangular puff for flawless baking and setting.",
      ),
    ];

    isLoading = false;
    notifyListeners();
  }
}

