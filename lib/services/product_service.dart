import 'dart:math';
import 'package:zytranow/model/product.dart';

class ProductService {
  static List<Product> productsForCategory(String category) {
    return _generateDummyProducts(category);
  }

  static List<Product> searchProducts(String query, {String? category}) {
    // Generate an expansive list of all possible products to simulate global search
    final allProducts = _generateAllProducts();
    
    List<Product> baseList;
    if (category != null && category.isNotEmpty) {
      baseList = productsForCategory(category);
    } else {
      baseList = allProducts;
    }
    
    if (query.isEmpty) return baseList;
    
    final lowerQuery = query.toLowerCase();
    return baseList.where((p) => p.name.toLowerCase().contains(lowerQuery)).toList();
  }

  static List<Product> _generateAllProducts() {
    final List<String> subcategories = [
      "Oversized T-Shirt", "Cargo Pants", "Summer Dress", "Crop Top", "Hoodie Jacket", "Straight Jeans",
      "Liquid Lipstick", "Lip Gloss", "Lip Liner", "Lip Oil", "Lip Cream", "Lip Tint",
      "Foundation", "Compact Powder", "BB Cream", "Blush", "Highlighter", "Concealer",
      "Eyeliner", "Mascara", "Eyeshadow", "Eyebrow Pencil", "Glitter Pigment", "Kajal",
      "Gel Polish", "Matte Paint", "Nail Remover", "Nail Strengthener", "Glitter Coat", "Nail Art Kit",
      "Vitamin C Serum", "Hyaluronic Serum", "Niacinamide", "Rose Toner", "Green Tea Toner", "Brightening Serum",
      "Sunscreen", "Face Cleanser", "Moisturizer", "Face Wash", "SPF Gel", "Daily Cream",
      "Strawberry Balm", "Overnight Mask", "Shea Balm", "Honey Mask", "Tinted Balm", "Vitamin E Balm",
      "Gold Facial Kit", "Charcoal Mask", "Sheet Masks", "Brightening Kit", "Clay Mask", "Hydrating Mask",
      "Root Spray", "Burgundy Color", "Hair Wax", "Grey Coverage", "Herbal Dye", "Ammonia-Free Color",
      "Keratin Mask", "Argan Serum", "Anti-Frizz Serum", "Coconut Mask", "Smoothening Cream", "Nourish Mask",
      "Styling Wax", "Curl Cream", "Hair Spray", "Heat Protection", "Hair Mousse", "Styling Gel",
      "Anti-Dandruff Shampoo", "Onion Oil", "Herbal Shampoo", "Coconut Oil", "Protein Shampoo", "Ayurvedic Oil",
      "Makeup Organizer", "Makeup Sponge", "Eyelash Curler", "Compact Mirror", "Beauty Blender", "Cotton Pads",
      "Paddle Brush", "Round Brush", "Detangling Comb", "Hair Clips", "Wide Tooth Comb", "Hair Scissors",
      "Luxury Serum", "Premium Foundation", "Designer Lipstick", "Gold Cream", "Perfume Mist", "Makeup Kit",
      "Floral Perfume", "Vanilla Mist", "Gift Box", "Rose Set", "Perfume Combo", "Deo Kit",
      "Eyebrow Razor", "Facial Hair Remover", "Bikini Trimmer", "Razor Kit", "Grooming Scissors", "Wax Strips"
    ];
    List<Product> all = [];
    for (var sub in subcategories) {
      all.addAll(_generateDummyProducts(sub));
    }
    return all;
  }

  static List<Product> _generateDummyProducts(String subcategory) {
    // Generate 6 variations for each subcategory
    final List<Product> generated = [];
    final random = Random(subcategory.hashCode); // stable randomness based on name

    final prefixes = ["Premium", "Luxe", "Daily", "Glow", "Matte", "Silky", "Pro", "Ultra", "Hydrating"];
    final brands = ["Nykaa", "L'Oreal", "Maybelline", "MAC", "Huda Beauty", "Minimalist", "Plum", "Sugar"];

    for (int i = 1; i <= 6; i++) {
      final brand = brands[random.nextInt(brands.length)];
      final prefix = prefixes[random.nextInt(prefixes.length)];
      final name = "$brand $prefix $subcategory";
      
      final price = 100.0 + random.nextInt(1900); // 100 to 2000
      final rating = 3.5 + (random.nextInt(15) / 10); // 3.5 to 5.0
      final reviews = 50 + random.nextInt(950); // 50 to 1000

      generated.add(Product(
        id: '${subcategory.replaceAll(' ', '_').toLowerCase()}_$i',
        name: name,
        imageAsset: '', // Empty asset to show placeholder cleanly
        unit: '1 item',
        price: price,
        deliveryTime: '${10 + random.nextInt(20)} mins',
        rating: rating,
        ratingCount: reviews,
        tags: random.nextBool() ? ['Bestseller'] : [],
      ));
    }

    return generated;
  }
}

