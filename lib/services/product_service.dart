import 'dart:math';
import 'package:zytranow/models/product.dart';
import 'package:zytranow/services/api_service.dart';

class ProductService {
  /// Fetches products for a specific category asynchronously from the Express/MongoDB server.
  /// Gracefully falls back to high-fidelity local mock data if the API is offline.
  static Future<List<Product>> productsForCategory(String category) async {
    final offlineData = _generateDummyProducts(category);
    return ApiService.getProductsByCategory(category, offlineData);
  }

  /// Searches products matching a query asynchronously from the Express/MongoDB search API.
  /// Gracefully falls back to local query matching if the API is offline.
  static Future<List<Product>> searchProducts(String query, {String? category}) async {
    final allProducts = _generateAllProducts();
    
    List<Product> baseList;
    if (category != null && category.isNotEmpty) {
      baseList = _generateDummyProducts(category);
    } else {
      baseList = allProducts;
    }
    
    final offlineResults = query.isEmpty
        ? baseList
        : baseList.where((p) => p.name.toLowerCase().contains(query.toLowerCase())).toList();

    return ApiService.searchProducts(query, offlineResults);
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
    final List<Product> generated = [];
    final random = Random(subcategory.hashCode);

    final prefixes = ["Premium", "Luxe", "Daily", "Glow", "Matte", "Silky", "Pro", "Ultra", "Hydrating"];
    final brands = ["Nykaa", "L'Oreal", "Maybelline", "MAC", "Huda Beauty", "Minimalist", "Plum", "Sugar"];

    for (int i = 1; i <= 6; i++) {
      final brand = brands[random.nextInt(brands.length)];
      final prefix = prefixes[random.nextInt(prefixes.length)];
      final name = "$brand $prefix $subcategory";
      
      final price = 150.0 + random.nextInt(1850); // 150 to 2000
      final mrp = price + (price * (15 + random.nextInt(35)) / 100); // MRP is 15-50% higher
      final rating = 3.8 + (random.nextInt(12) / 10); // 3.8 to 5.0
      final reviews = 120 + random.nextInt(1800);
      final soldCountVal = 10 + random.nextInt(40); // 10k to 50k

      final images = _getImagesForSubcategory(subcategory, i, random);
      final specs = _getSpecsForSubcategory(subcategory);
      final variants = _getVariantsForSubcategory(subcategory);

      final desc = "Experience ultimate luxury and quality with this premium $name. Carefully formulated and selected by experts, it is designed to cater perfectly to your self-care, beauty, and fashion desires. Crafted with high-grade, safe, and dermatologically tested components to guarantee a flawless finish and utmost skin-friendly results. Add a touch of elegance and absolute reliability to your lifestyle collection today.";

      generated.add(Product(
        id: '${subcategory.replaceAll(' ', '_').toLowerCase()}_$i',
        name: name,
        imageAsset: images.first,
        unit: subcategory.toLowerCase().contains('t-shirt') || subcategory.toLowerCase().contains('pants') || subcategory.toLowerCase().contains('dress') || subcategory.toLowerCase().contains('top') || subcategory.toLowerCase().contains('jeans') ? '1 Unit' : '50 ml',
        price: price,
        mrp: double.parse(mrp.toStringAsFixed(2)),
        deliveryTime: '${8 + random.nextInt(12)} mins', // Zytra 8-20 mins style
        rating: double.parse(rating.toStringAsFixed(1)),
        reviews: reviews,
        description: desc,
        soldCount: soldCountVal,
        brand: brand,
        category: subcategory,
        images: images,
        specifications: specs,
        variants: variants,
        tags: random.nextBool() ? ['Bestseller'] : ['Trending'],
      ));
    }

    // Link similar products after creating the main flat list (avoids deep recursions)
    for (int i = 0; i < generated.length; i++) {
      final current = generated[i];
      final List<Product> similar = [];
      for (int j = 0; j < generated.length; j++) {
        if (i != j) {
          similar.add(generated[j]);
        }
        if (similar.length >= 4) break;
      }
      generated[i] = _copyWithSimilarProducts(current, similar);
    }

    return generated;
  }

  static Product _copyWithSimilarProducts(Product p, List<Product> similar) {
    return Product(
      id: p.id,
      name: p.name,
      imageAsset: p.imageAsset,
      unit: p.unit,
      price: p.price,
      mrp: p.mrp,
      deliveryTime: p.deliveryTime,
      rating: p.rating,
      reviews: p.reviews,
      description: p.description,
      soldCount: p.soldCount,
      brand: p.brand,
      category: p.category,
      images: p.images,
      specifications: p.specifications,
      variants: p.variants,
      tags: p.tags,
      similarProducts: similar,
    );
  }

  static List<String> _getImagesForSubcategory(String subcategory, int index, Random random) {
    final lower = subcategory.toLowerCase();
    
    // Fashion images: beautiful clothing & styling
    final fashionImages = [
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=600',
      'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=600',
      'https://images.unsplash.com/photo-1496747611176-843222e1e57c?q=80&w=600',
      'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?q=80&w=600',
      'https://images.unsplash.com/photo-1509631179647-0177331693ae?q=80&w=600',
      'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?q=80&w=600',
      'https://images.unsplash.com/photo-1583743814966-8936f5b7be1a?q=80&w=600',
      'https://images.unsplash.com/photo-1554568218-0f1715e72254?q=80&w=600',
      'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?q=80&w=600',
      'https://images.unsplash.com/photo-1434389677669-e08b4cac3105?q=80&w=600',
    ];

    // Cosmetics & Skincare: lipsticks, serum bottles, luxury jars, mirrors
    final beautyImages = [
      'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=600',
      'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=600',
      'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=600',
      'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=600',
      'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=600',
      'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=600',
      'https://images.unsplash.com/photo-1625093742435-6fa192b6fb10?q=80&w=600',
      'https://images.unsplash.com/photo-1617897903246-719242758050?q=80&w=600',
      'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?q=80&w=600',
      'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?q=80&w=600',
    ];

    final isFashion = lower.contains('t-shirt') || lower.contains('pants') || lower.contains('dress') || lower.contains('top') || lower.contains('jacket') || lower.contains('jeans') || lower.contains('clothing');
    final baseList = isFashion ? fashionImages : beautyImages;

    final List<String> selected = [];
    int startOffset = (index * 3) % baseList.length;
    for (int i = 0; i < 5; i++) {
      selected.add(baseList[(startOffset + i) % baseList.length]);
    }
    return selected;
  }

  static Map<String, String> _getSpecsForSubcategory(String subcategory) {
    final lower = subcategory.toLowerCase();
    
    if (lower.contains('sunscreen') || lower.contains('spf')) {
      return {
        'SPF Level': 'SPF 50 PA+++',
        'Skin Type': 'All skin types, Non-comedogenic',
        'Water Resistant': '80 minutes waterproof',
        'Active Ingredient': 'Zinc Oxide & Titanium Dioxide',
      };
    } else if (lower.contains('serum') || lower.contains('toner') || lower.contains('moisturizer') || lower.contains('cleanser')) {
      return {
        'Skin Type': 'Sensitive & Dry Skin',
        'Key Ingredient': 'Hyaluronic Acid & Niacinamide',
        'Formulation': 'Gel-based, non-sticky',
        'Ph Balance': '5.5 pH level balanced',
      };
    } else if (lower.contains('lipstick') || lower.contains('gloss') || lower.contains('liner') || lower.contains('tint')) {
      return {
        'Finish Type': 'Velvet matte finish',
        'Duration': 'Up to 16 Hours waterproof',
        'Skin Type': 'Dermatologically tested',
        'Features': 'Smudgeproof, highly pigmented',
      };
    } else if (lower.contains('t-shirt') || lower.contains('pants') || lower.contains('dress') || lower.contains('top') || lower.contains('jeans') || lower.contains('jacket')) {
      return {
        'Material': '100% Breathable Organic Cotton',
        'Fit': 'Oversized relaxed premium fit',
        'Thickness': '240 GSM heavy cotton',
        'Wash Care': 'Cold machine wash only',
      };
    } else {
      return {
        'Quality Grade': 'A++ Premium Export Quality',
        'Testing': 'Clinically proven safe',
        'Suitability': 'Hypoallergenic & Unisex',
        'Manufacture': 'Sustainably sourced',
      };
    }
  }

  static List<String> _getVariantsForSubcategory(String subcategory) {
    final lower = subcategory.toLowerCase();
    if (lower.contains('t-shirt') || lower.contains('pants') || lower.contains('dress') || lower.contains('top') || lower.contains('jeans') || lower.contains('jacket')) {
      return ["XS", "S", "M", "L", "XL"];
    } else if (lower.contains('lipstick') || lower.contains('gloss') || lower.contains('liner') || lower.contains('blush') || lower.contains('tint')) {
      return ["01 Rose Pink", "02 Nude Velvet", "03 Coral Gold", "04 Deep Crimson"];
    } else {
      return ["30 ml", "50 ml", "100 ml"];
    }
  }
}
