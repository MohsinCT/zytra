class Product {
  final String id;
  final String name;
  final String imageAsset; // local asset path
  final String unit; // e.g. "1 pc", "500 ml"
  final double price;
  final String deliveryTime; // e.g. "10 mins"
  final List<String> tags;
  final double rating;
  final int ratingCount;

  Product({
    required this.id,
    required this.name,
    required this.imageAsset,
    required this.unit,
    required this.price,
    required this.deliveryTime,
    this.tags = const [],
    this.rating = 4.5,
    this.ratingCount = 120,
  });
}
