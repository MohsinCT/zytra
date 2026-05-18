class Product {
  final String id;
  final String name;
  final String imageAsset; // local asset path or primary image
  final String unit; // e.g. "1 pc", "500 ml"
  final double price;
  final String deliveryTime; // e.g. "10 mins"
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
}
