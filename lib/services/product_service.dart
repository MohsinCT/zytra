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

    // Lip cosmetic products
    final lipImages = [
      'https://images.unsplash.com/photo-1586495777744-4413f21062fa?q=80&w=600',
      'https://images.unsplash.com/photo-1625093742435-6fa192b6fb10?q=80&w=600',
      'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?q=80&w=600',
      'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=600',
    ];

    // Face makeup products (foundation, blush, primer)
    final faceMakeupImages = [
      'https://images.unsplash.com/photo-1596462502278-27bfdc403348?q=80&w=600',
      'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=600',
      'https://images.unsplash.com/photo-1625093742435-6fa192b6fb10?q=80&w=600',
    ];

    // Eye makeup products (eyeliner, eyeshadow, mascara)
    final eyeMakeupImages = [
      'https://images.unsplash.com/photo-1617897903246-719242758050?q=80&w=600',
      'https://images.unsplash.com/photo-1571781926291-c477ebfd024b?q=80&w=600',
      'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?q=80&w=600',
    ];

    // Nail products (classic polish, gel polish, nail art, press-on nails)
    final nailImages = [
      'https://images.unsplash.com/photo-1604654894610-df490651e56c?q=80&w=600',
      'https://images.unsplash.com/photo-1519014816548-bf5fe059798b?q=80&w=600',
      'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600',
    ];

    // Skincare (serums, creams, cleansers, toners, sunscreens)
    final skincareImages = [
      'https://images.unsplash.com/photo-1556229010-aa3f7ff66b24?q=80&w=600',
      'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=600',
      'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=600',
      'https://images.unsplash.com/photo-1601049541289-9b1b7bbbfe19?q=80&w=600',
    ];

    // Haircare (shampoo, hair mask, hair color, hair stylers)
    final haircareImages = [
      'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600',
      'https://images.unsplash.com/photo-1534447677768-be436bb09401?q=80&w=600',
      'https://images.unsplash.com/photo-1556229010-aa3f7ff66b24?q=80&w=600',
    ];

    // Fashion & Apparel
    final fashionImages = [
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?q=80&w=600',
      'https://images.unsplash.com/photo-1610030469983-98e550d6193c?q=80&w=600',
      'https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=600',
      'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?q=80&w=600',
    ];

    // Perfumes
    final perfumeImages = [
      'https://images.unsplash.com/photo-1612817288484-6f916006741a?q=80&w=600',
      'https://images.unsplash.com/photo-1541643600914-78b084683601?q=80&w=600',
      'https://images.unsplash.com/photo-1594035910387-fea47794261f?q=80&w=600',
    ];

    // Footwear
    final footwearImages = [
      'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?q=80&w=600',
      'https://images.unsplash.com/photo-1539185441755-769473a23570?q=80&w=600',
      'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?q=80&w=600',
    ];

    // Bags & Wallets
    final bagsImages = [
      'https://images.unsplash.com/photo-1584917865442-de89df76afd3?q=80&w=600',
      'https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?q=80&w=600',
    ];

    // Travel & mobility
    final travelImages = [
      'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?q=80&w=600',
      'https://images.unsplash.com/photo-1527631746610-bca00a040d60?q=80&w=600',
    ];

    // Arts & Crafts
    final artCraftImages = [
      'https://images.unsplash.com/photo-1513364776144-60967b0f800f?q=80&w=600',
      'https://images.unsplash.com/photo-1519782904885-19641e4029d3?q=80&w=600',
    ];

    // Books
    final bookImages = [
      'https://images.unsplash.com/photo-1544947950-fa07a98d237f?q=80&w=600',
      'https://images.unsplash.com/photo-1512820790803-83ca734da794?q=80&w=600',
    ];

    // Wellness & Sex
    final wellnessSexImages = [
      'https://images.unsplash.com/photo-1515377905703-c4788e51af15?q=80&w=600',
      'https://images.unsplash.com/photo-1608248597481-496100c80836?q=80&w=600',
    ];

    // Mehandi
    final mehandiImages = [
      'https://images.unsplash.com/photo-1562184552-997c461abbe6?q=80&w=600',
      'https://images.unsplash.com/photo-1590156221122-c7b3cd6d21a0?q=80&w=600',
    ];

    // Pregnancy & Maternity
    final pregnancyImages = [
      'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?q=80&w=600',
      'https://images.unsplash.com/photo-1555252333-9f8e92e67df9?q=80&w=600',
    ];

    // Bath, Body & Hygiene
    final hygieneImages = [
      'https://images.unsplash.com/photo-1526947425960-945c6e72858f?q=80&w=600',
      'https://images.unsplash.com/photo-1540555700478-4be289fbecef?q=80&w=600',
    ];

    // Hair tools (straighteners, dryers)
    final straightenersImages = [
      'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?q=80&w=600',
      'https://images.unsplash.com/photo-1562322140-8baeececf3df?q=80&w=600',
    ];

    List<String> baseList;

    if (lower.contains('lipstick') || lower.contains('lip') || lower.contains('gloss') || lower.contains('tint') || lower.contains('crayon') || lower.contains('liner')) {
      baseList = lipImages;
    } else if (lower.contains('foundation') || lower.contains('bb') || lower.contains('cc') || lower.contains('concealer') || lower.contains('powder') || lower.contains('blush') || lower.contains('highlighter') || lower.contains('primer') || lower.contains('fixer') || lower.contains('remover') || lower.contains('contour')) {
      baseList = faceMakeupImages;
    } else if (lower.contains('kajal') || lower.contains('eyeliner') || lower.contains('mascara') || lower.contains('lash') || lower.contains('eyeshadow') || lower.contains('brow')) {
      baseList = eyeMakeupImages;
    } else if (lower.contains('nail') || lower.contains('polish') || lower.contains('lacquer') || lower.contains('press-on') || lower.contains('manicure')) {
      baseList = nailImages;
    } else if (lower.contains('serum') || lower.contains('toner') || lower.contains('mist') || lower.contains('oil') || lower.contains('acid') || lower.contains('moisturizer') || lower.contains('cleanser') || lower.contains('mask') || lower.contains('lotion') || lower.contains('cream') || lower.contains('sunscreen') || lower.contains('spf')) {
      baseList = skincareImages;
    } else if (lower.contains('shampoo') || lower.contains('conditioner') || lower.contains('dye') || lower.contains('color') || lower.contains('hair') || lower.contains('tonic')) {
      baseList = haircareImages;
    } else if (lower.contains('perfume') || lower.contains('fragrance') || lower.contains('mist') || lower.contains('deo') || lower.contains('attar') || lower.contains('scent')) {
      baseList = perfumeImages;
    } else if (lower.contains('footwear') || lower.contains('shoe') || lower.contains('sneaker') || lower.contains('heel') || lower.contains('juttis') || lower.contains('flat') || lower.contains('sandal') || lower.contains('slipper') || lower.contains('clog')) {
      baseList = footwearImages;
    } else if (lower.contains('bag') || lower.contains('wallet') || lower.contains('purse') || lower.contains('clutch') || lower.contains('tote') || lower.contains('sling') || lower.contains('backpack')) {
      baseList = bagsImages;
    } else if (lower.contains('luggage') || lower.contains('travel') || lower.contains('flight') || lower.contains('suitcases') || lower.contains('cabin')) {
      baseList = travelImages;
    } else if (lower.contains('paint') || lower.contains('sketch') || lower.contains('draw') || lower.contains('craft') || lower.contains('diy') || lower.contains('hobby') || lower.contains('yarn') || lower.contains('crochet') || lower.contains('needlework') || lower.contains('origami')) {
      baseList = artCraftImages;
    } else if (lower.contains('book') || lower.contains('fiction') || lower.contains('growth') || lower.contains('novel') || lower.contains('mindset') || lower.contains('thriller') || lower.contains('biographies') || lower.contains('history')) {
      baseList = bookImages;
    } else if (lower.contains('sex') || lower.contains('wellness') || lower.contains('intimate') || lower.contains('lubricant') || lower.contains('condom') || lower.contains('stimulation')) {
      baseList = wellnessSexImages;
    } else if (lower.contains('mehandi') || lower.contains('henna')) {
      baseList = mehandiImages;
    } else if (lower.contains('pregnancy') || lower.contains('maternity') || lower.contains('maternal') || lower.contains('nursing') || lower.contains('postpartum') || lower.contains('pregnant')) {
      baseList = pregnancyImages;
    } else if (lower.contains('hygiene') || lower.contains('pad') || lower.contains('tampon') || lower.contains('cup') || lower.contains('feminine') || lower.contains('intimate wash')) {
      baseList = hygieneImages;
    } else if (lower.contains('straightener') || lower.contains('dryer') || lower.contains('iron') || lower.contains('curler') || lower.contains('styler') || lower.contains('blow')) {
      baseList = straightenersImages;
    } else if (lower.contains('wear') || lower.contains('dress') || lower.contains('top') || lower.contains('pant') || lower.contains('jeans') || lower.contains('apparel') || lower.contains('t-shirt') || lower.contains('skirt') || lower.contains('jacket') || lower.contains('sweater') || lower.contains('suit')) {
      baseList = fashionImages;
    } else {
      baseList = skincareImages; // Safe premium beauty fallback
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
