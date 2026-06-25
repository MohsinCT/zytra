import 'dart:math';
import 'package:zytranow/models/product.dart';
import 'package:zytranow/services/api_service.dart';
import 'package:zytranow/controllers/category_provider.dart';

class ProductService {
  /// Fetches products for a specific category asynchronously from the Express/MongoDB server.
  /// Gracefully falls back to high-fidelity local mock data if the API is offline.
  static Future<List<Product>> productsForCategory(String category) async {
    final offlineData = _generateDummyProducts(category);
    return ApiService.getProductsByCategory(category, offlineData);
  }

  /// Searches products matching a query asynchronously from the Express/MongoDB search API.
  /// Gracefully falls back to local query matching if the API is offline.
  static Future<List<Product>> searchProducts(
    String query, {
    String? category,
  }) async {
    final allProducts = _generateAllProducts();

    List<Product> baseList;
    if (category != null && category.isNotEmpty) {
      baseList = _generateDummyProducts(category);
    } else {
      baseList = allProducts;
    }

    final offlineResults = query.isEmpty
        ? baseList
        : baseList
              .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
              .toList();

    return ApiService.searchProducts(query, offlineResults);
  }

  static List<Product> _generateAllProducts() {
    final List<String> subcategories = [];
    final sections = CategoryProvider().sections;
    for (var sec in sections) {
      for (var sub in sec.items) {
        subcategories.addAll(sub.leafCategories);
      }
    }
    List<Product> all = [];
    for (var sub in subcategories) {
      all.addAll(_generateDummyProducts(sub));
    }
    return all;
  }

  static List<Product> _generateDummyProducts(String subcategory) {
    final List<Product> generated = [];
    final random = Random(subcategory.hashCode);

    final prefixes = [
      "Premium",
      "Luxe",
      "Daily",
      "Glow",
      "Matte",
      "Silky",
      "Pro",
      "Ultra",
      "Hydrating",
    ];
    final brands = [
      "Nykaa",
      "L'Oreal",
      "Maybelline",
      "MAC",
      "Huda Beauty",
      "Minimalist",
      "Plum",
      "Sugar",
    ];

    for (int i = 1; i <= 6; i++) {
      final brand = brands[random.nextInt(brands.length)];
      final prefix = prefixes[random.nextInt(prefixes.length)];
      final name = "$brand $prefix $subcategory";

      final price = 150.0 + random.nextInt(1850); // 150 to 2000
      final mrp =
          price +
          (price * (15 + random.nextInt(35)) / 100); // MRP is 15-50% higher
      final rating = 3.8 + (random.nextInt(12) / 10); // 3.8 to 5.0
      final reviews = 120 + random.nextInt(1800);
      final soldCountVal = 10 + random.nextInt(40); // 10k to 50k

      final images = _getImagesForSubcategory(subcategory, i, random);
      final specs = _getSpecsForSubcategory(subcategory);
      final variants = _getVariantsForSubcategory(subcategory);

      final desc =
          "Experience ultimate luxury and quality with this premium $name. Carefully formulated and selected by experts, it is designed to cater perfectly to your self-care, beauty, and fashion desires. Crafted with high-grade, safe, and dermatologically tested components to guarantee a flawless finish and utmost skin-friendly results. Add a touch of elegance and absolute reliability to your lifestyle collection today.";

      generated.add(
        Product(
          id: '${subcategory.replaceAll(' ', '_').toLowerCase()}_$i',
          name: name,
          imageAsset: images.first,
          unit:
              subcategory.toLowerCase().contains('t-shirt') ||
                  subcategory.toLowerCase().contains('pants') ||
                  subcategory.toLowerCase().contains('dress') ||
                  subcategory.toLowerCase().contains('top') ||
                  subcategory.toLowerCase().contains('jeans')
              ? '1 Unit'
              : '50 ml',
          price: price,
          mrp: double.parse(mrp.toStringAsFixed(2)),
          deliveryTime:
              '${8 + random.nextInt(12)} mins', // Zytra 8-20 mins style
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
        ),
      );
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

  static List<String> _getImagesForSubcategory(
    String subcategory,
    int index,
    Random random,
  ) {
    final lower = subcategory.toLowerCase();

    final fashionImages = [
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=600',
      'https://images.unsplash.com/photo-1610030469983-98e550d6193c?q=80&w=600',
      'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=600',
      'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?q=80&w=600',
      'https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=600',
    ];

    final makeupImages = [
      'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=600',
      'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=600',
      'https://images.unsplash.com/photo-1617897903246-719242758050?q=80&w=600',
      'https://images.unsplash.com/photo-1625093742435-6fa192b6fb10?q=80&w=600',
      'https://images.unsplash.com/photo-1604654894610-df490651e56c?q=80&w=600',
    ];

    final skincareImages = [
      'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=600',
      'https://images.unsplash.com/photo-1556228720-195a672e8a03?q=80&w=600',
      'https://images.unsplash.com/photo-1612817288484-6f916007741a?q=80&w=600',
      'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?q=80&w=600',
      'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=600',
    ];

    final haircareImages = [
      'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600',
      'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=600',
    ];

    final booksHobbiesImages = [
      'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=600',
      'https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=600',
      'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=600',
    ];

    List<String> baseList;

    if (lower.contains('wear') ||
        lower.contains('suit') ||
        lower.contains('night') ||
        lower.contains('pant') ||
        lower.contains('bra') ||
        lower.contains('brief') ||
        lower.contains('boxer') ||
        lower.contains('jacket') ||
        lower.contains('coat') ||
        lower.contains('sweater') ||
        lower.contains('apparel') ||
        lower.contains('t-shirt') ||
        lower.contains('dress') ||
        lower.contains('jeans') ||
        lower.contains('skirt') ||
        lower.contains('footwear') ||
        lower.contains('heel') ||
        lower.contains('flat') ||
        lower.contains('juttis') ||
        lower.contains('bag') ||
        lower.contains('wallet') ||
        lower.contains('clutch') ||
        lower.contains('backpack') ||
        lower.contains('pouch')) {
      baseList = fashionImages;
    } else if (lower.contains('lipstick') ||
        lower.contains('gloss') ||
        lower.contains('tint') ||
        lower.contains('liner') ||
        lower.contains('crayon') ||
        lower.contains('primer') ||
        lower.contains('palette') ||
        lower.contains('kit') ||
        lower.contains('foundation') ||
        lower.contains('bb') ||
        lower.contains('cc') ||
        lower.contains('concealer') ||
        lower.contains('powder') ||
        lower.contains('blush') ||
        lower.contains('highlighter') ||
        lower.contains('contour') ||
        lower.contains('remover') ||
        lower.contains('water') ||
        lower.contains('balm') ||
        lower.contains('wipe') ||
        lower.contains('kajal') ||
        lower.contains('eyeliner') ||
        lower.contains('mascara') ||
        lower.contains('lash') ||
        lower.contains('glue') ||
        lower.contains('eyeshadow') ||
        lower.contains('pencil') ||
        lower.contains('pomade') ||
        lower.contains('lacquer') ||
        lower.contains('polish') ||
        lower.contains('top coat') ||
        lower.contains('art') ||
        lower.contains('blender') ||
        lower.contains('sponge') ||
        lower.contains('brush') ||
        lower.contains('tweezer') ||
        lower.contains('razor') ||
        lower.contains('mirror') ||
        lower.contains('case') ||
        lower.contains('henna') ||
        lower.contains('mehandi')) {
      baseList = makeupImages;
    } else if (lower.contains('serum') ||
        lower.contains('toner') ||
        lower.contains('mist') ||
        lower.contains('oil') ||
        lower.contains('ampoule') ||
        lower.contains('peel') ||
        lower.contains('acid') ||
        lower.contains('exfoliator') ||
        lower.contains('scrub') ||
        lower.contains('gel') ||
        lower.contains('cream') ||
        lower.contains('lotion') ||
        lower.contains('sunscreen') ||
        lower.contains('cleanser') ||
        lower.contains('moisturizer') ||
        lower.contains('mask') ||
        lower.contains('butter') ||
        lower.contains('soap') ||
        lower.contains('bath') ||
        lower.contains('salt') ||
        lower.contains('soak') ||
        lower.contains('bubble') ||
        lower.contains('shower') ||
        lower.contains('hygiene') ||
        lower.contains('pad') ||
        lower.contains('cup') ||
        lower.contains('tampon') ||
        lower.contains('lubricant') ||
        lower.contains('massager') ||
        lower.contains('condom') ||
        lower.contains('stimulation') ||
        lower.contains('roller') ||
        lower.contains('steamer') ||
        lower.contains('aroma') ||
        lower.contains('candle') ||
        lower.contains('diffuser')) {
      baseList = skincareImages;
    } else if (lower.contains('hair') ||
        lower.contains('shampoo') ||
        lower.contains('conditioner') ||
        lower.contains('tonic') ||
        lower.contains('dye') ||
        lower.contains('color') ||
        lower.contains('spray') ||
        lower.contains('gel') ||
        lower.contains('wax') ||
        lower.contains('pomade') ||
        lower.contains('clay') ||
        lower.contains('mousse') ||
        lower.contains('foam') ||
        lower.contains('comb') ||
        lower.contains('detangler') ||
        lower.contains('styler') ||
        lower.contains('straightener') ||
        lower.contains('dryer') ||
        lower.contains('curler') ||
        lower.contains('wand') ||
        lower.contains('iron')) {
      baseList = haircareImages;
    } else {
      baseList = booksHobbiesImages;
    }

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
    } else if (lower.contains('serum') ||
        lower.contains('toner') ||
        lower.contains('moisturizer') ||
        lower.contains('cleanser')) {
      return {
        'Skin Type': 'Sensitive & Dry Skin',
        'Key Ingredient': 'Hyaluronic Acid & Niacinamide',
        'Formulation': 'Gel-based, non-sticky',
        'Ph Balance': '5.5 pH level balanced',
      };
    } else if (lower.contains('lipstick') ||
        lower.contains('gloss') ||
        lower.contains('liner') ||
        lower.contains('tint')) {
      return {
        'Finish Type': 'Velvet matte finish',
        'Duration': 'Up to 16 Hours waterproof',
        'Skin Type': 'Dermatologically tested',
        'Features': 'Smudgeproof, highly pigmented',
      };
    } else if (lower.contains('t-shirt') ||
        lower.contains('pants') ||
        lower.contains('dress') ||
        lower.contains('top') ||
        lower.contains('jeans') ||
        lower.contains('jacket')) {
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
    if (lower.contains('t-shirt') ||
        lower.contains('pants') ||
        lower.contains('dress') ||
        lower.contains('top') ||
        lower.contains('jeans') ||
        lower.contains('jacket')) {
      return ["XS", "S", "M", "L", "XL"];
    } else if (lower.contains('lipstick') ||
        lower.contains('gloss') ||
        lower.contains('liner') ||
        lower.contains('blush') ||
        lower.contains('tint')) {
      return [
        "01 Rose Pink",
        "02 Nude Velvet",
        "03 Coral Gold",
        "04 Deep Crimson",
      ];
    } else {
      return ["30 ml", "50 ml", "100 ml"];
    }
  }
}
