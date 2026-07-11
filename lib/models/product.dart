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

  static String _getFallbackImage(String name, String category) {
    final lower = "${name.toLowerCase()} ${category.toLowerCase()}";
    if (lower.contains('lipstick') || lower.contains('lip') || lower.contains('gloss') || lower.contains('balm')) {
      return 'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=600';
    } else if (lower.contains('foundation') || lower.contains('concealer') || lower.contains('powder') || lower.contains('blush') || lower.contains('makeup') || lower.contains('primer') || lower.contains('face')) {
      return 'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=600';
    } else if (lower.contains('eye') || lower.contains('kajal') || lower.contains('liner') || lower.contains('mascara')) {
      return 'https://images.unsplash.com/photo-1617897903246-719242758050?q=80&w=600';
    } else if (lower.contains('nail') || lower.contains('polish') || lower.contains('lacquer') || lower.contains('manicure')) {
      return 'https://images.unsplash.com/photo-1604654894610-df490651e56c?q=80&w=600';
    } else if (lower.contains('shampoo') || lower.contains('hair') || lower.contains('conditioner') || lower.contains('oil') || lower.contains('straightener') || lower.contains('dryer')) {
      return 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600';
    } else if (lower.contains('wear') || lower.contains('dress') || lower.contains('clothing') || lower.contains('apparel') || lower.contains('top') || lower.contains('pants')) {
      return 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=600';
    } else if (lower.contains('perfume') || lower.contains('fragrance') || lower.contains('scent') || lower.contains('mist')) {
      return 'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=600';
    } else if (lower.contains('bag') || lower.contains('wallet') || lower.contains('purse') || lower.contains('clutch')) {
      return 'https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=600';
    } else if (lower.contains('footwear') || lower.contains('shoe') || lower.contains('sneaker') || lower.contains('heel') || lower.contains('sandal')) {
      return 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?q=80&w=600';
    } else if (lower.contains('book') || lower.contains('novel') || lower.contains('read')) {
      return 'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=600';
    } else if (lower.contains('art') || lower.contains('paint') || lower.contains('sketch') || lower.contains('craft')) {
      return 'https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=600';
    } else if (lower.contains('travel') || lower.contains('luggage') || lower.contains('cases')) {
      return 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=600';
    }
    return 'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=600';
  }

  /// Parses a MongoDB document / JSON object into a Product object.
  /// Handles both standard MongoDB '_id' and serialized 'id' transparently.
  factory Product.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? '';
    final category = json['category'] ?? '';

    var imageAsset = json['imageAsset'] ?? json['image_asset'] ?? '';
    if (imageAsset.isEmpty) {
      imageAsset = _getFallbackImage(name, category);
    }

    var imagesList = List<String>.from(json['images'] ?? []);
    if (imagesList.isEmpty) {
      imagesList = [imageAsset];
    }

    return Product(
      id: json['id'] ?? json['_id'] ?? '',
      name: name,
      imageAsset: imageAsset,
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
      category: category,
      images: imagesList,
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
