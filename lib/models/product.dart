class Product {
  final String id;
  final String name;
  final String imageAsset; // local asset path or primary network image URL
  final String unit; // e.g. "1 Pack", "100 ml"
  final double price;
  final String deliveryTime; // e.g. "8 mins"
  final List<String> tags;
  final double rating;
  final int reviews;

  // New fields requested for Product Details Screen
  final String description;
  final double mrp;
  final int soldCount;
  final String brand;
  final String category;
  final List<String> images;
  final Map<String, String> specifications;
  final List<String> variants;
  final List<Product> similarProducts;

  Product({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.unit,
    required this.price,
    required this.deliveryTime,
    this.tags = const [],
    this.rating = 4.5,
    this.reviews = 120,
    this.description = '',
    this.mrp = 0.0,
    this.soldCount = 0,
    this.brand = '',
    this.category = '',
    this.images = const [],
    this.specifications = const {},
    this.variants = const [],
    this.similarProducts = const [],
  });

  int get ratingCount => reviews;

  /// Parses a MongoDB document / JSON object into a Product object.
  /// Handles both standard MongoDB '_id' and serialized 'id' transparently.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      imageAsset: json['imageAsset'] ?? json['image_asset'] ?? '',
      unit: json['unit'] ?? '1 Unit',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      deliveryTime: json['deliveryTime'] ?? json['delivery_time'] ?? '10 mins',
      tags: List<String>.from(json['tags'] ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviews: (json['reviews'] as num?)?.toInt() ?? 120,
      description: json['description'] ?? '',
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      soldCount: (json['soldCount'] as num?)?.toInt() ?? 0,
      brand: json['brand'] ?? '',
      category: json['category'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      specifications: Map<String, String>.from(json['specifications'] ?? {}),
      variants: List<String>.from(json['variants'] ?? []),
      similarProducts:
          (json['similarProducts'] as List?)
              ?.map((p) => Product.fromJson(Map<String, dynamic>.from(p)))
              .toList() ??
          [],
    );
  }

  /// Converts a Product object to JSON format.
  /// Recursion-safe mapping for Similar Products to prevent memory overflows.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageAsset': imageAsset,
      'unit': unit,
      'price': price,
      'deliveryTime': deliveryTime,
      'tags': tags,
      'rating': rating,
      'reviews': reviews,
      'description': description,
      'mrp': mrp,
      'soldCount': soldCount,
      'brand': brand,
      'category': category,
      'images': images,
      'specifications': specifications,
      'variants': variants,
      'similarProducts': similarProducts
          .map((p) => p.toJsonWithoutSimilar())
          .toList(),
    };
  }

  /// Helper serialization without sub-similar products list to prevent infinite loop.
  Map<String, dynamic> toJsonWithoutSimilar() {
    return {
      'id': id,
      'name': name,
      'imageAsset': imageAsset,
      'unit': unit,
      'price': price,
      'deliveryTime': deliveryTime,
      'tags': tags,
      'rating': rating,
      'reviews': reviews,
      'description': description,
      'mrp': mrp,
      'soldCount': soldCount,
      'brand': brand,
      'category': category,
      'images': images,
      'specifications': specifications,
      'variants': variants,
    };
  }
}
