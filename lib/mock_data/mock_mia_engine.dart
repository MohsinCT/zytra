import 'dart:async';
import 'package:zytranow/models/mia_models.dart';

/// Abstract contract for Mia Engine.
/// Decoupled so this can be swapped with live LLM / FastAPI / Firebase backend
/// in the future without changing any UI widgets.
abstract class MiaEngineService {
  Future<MiaProductCard> getFeaturedLipstickProduct();
  Future<MiaProductCard> processVoiceCommand(
    String command, {
    required MiaProductCard currentProduct,
  });
  Future<MiaIngredientAnalysis> parseInstagramUrl(String url);
  Future<MiaMessage> processQuery({
    required String query,
    required bool isVoice,
    required MiaProductCard? currentProduct,
  });
  List<String> getSuggestedVoiceTriggers();
  List<String> getQuickActionPills();
}

/// Fully deterministic, zero-network mock implementation of Mia retail engine.
class MockMiaEngine implements MiaEngineService {
  static final MockMiaEngine instance = MockMiaEngine._();
  MockMiaEngine._();

  /// Default high-definition mock shades for the lipstick showcase.
  static const List<MiaShade> _mockLipstickShades = [
    MiaShade(
      id: 'shade_honey',
      name: 'Honey Warm',
      hexColor: '#E28B6A',
      imageUrl:
          'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=600&auto=format&fit=crop&q=80',
      swatchUrl:
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=300&auto=format&fit=crop&q=80',
      undertone: 'Warm Golden Nude',
      finish: 'Velvet Cashmere',
      skinToneHex: '#F3D2C1',
      description:
          'A soft caramelized honey nude that warms up all neutral and golden skin tones effortlessly.',
    ),
    MiaShade(
      id: 'shade_berry',
      name: 'Berry Burst',
      hexColor: '#8B1E3F',
      imageUrl:
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=600&auto=format&fit=crop&q=80',
      swatchUrl:
          'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=300&auto=format&fit=crop&q=80',
      undertone: 'Cool Deep Plum',
      finish: 'Rich Velvet Matte',
      skinToneHex: '#ECD0BD',
      description:
          'Dramatic crushed blackberry hue with jewel-toned undertones for evening party statements.',
    ),
    MiaShade(
      id: 'shade_ruby',
      name: 'Ruby Velvet',
      hexColor: '#C41E3A',
      imageUrl:
          'https://images.unsplash.com/photo-1563178406-4cdc2923acbc?w=600&auto=format&fit=crop&q=80',
      swatchUrl:
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=300&auto=format&fit=crop&q=80',
      undertone: 'Iconic Blue-Red',
      finish: 'Couture Suede',
      skinToneHex: '#F5D6C6',
      description:
          'Classic Old-Hollywood true red engineered with cool micro-reflects to make teeth look whiter.',
    ),
    MiaShade(
      id: 'shade_petal',
      name: 'Petal Nude',
      hexColor: '#D98282',
      imageUrl:
          'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=600&auto=format&fit=crop&q=80',
      swatchUrl:
          'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=300&auto=format&fit=crop&q=80',
      undertone: 'Neutral Dusty Rose',
      finish: 'Cloud Blotted',
      skinToneHex: '#F2D8C9',
      description:
          'Subtle everyday blush rose that mimics natural flush with a blurred cloud-powder effect.',
    ),
    MiaShade(
      id: 'shade_coral',
      name: 'Coral Sunset',
      hexColor: '#E0604A',
      imageUrl:
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=600&auto=format&fit=crop&q=80',
      swatchUrl:
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=300&auto=format&fit=crop&q=80',
      undertone: 'Vibrant Terracotta',
      finish: 'Satin Comfort',
      skinToneHex: '#EED0BE',
      description:
          'Warm energetic terracotta infused with apricot warmth for summer and daylight radiance.',
    ),
  ];

  @override
  Future<MiaProductCard> getFeaturedLipstickProduct() async {
    // Simulated instant or micro-delay fetch
    await Future.delayed(const Duration(milliseconds: 150));
    return const MiaProductCard(
      id: 'evermi_lip_01',
      productName: 'Velvet Whispers Luxury Matte',
      brand: 'Evermi Atelier',
      price: 34.00,
      originalPrice: 42.00,
      rating: 4.92,
      reviewCount: 489,
      description:
          'Formulated with cold-pressed botanical squalane and 2% micronized hyaluronic spheres. Delivers 16-hour cloud weightless comfort with zero cracking.',
      activeShadeIndex: 0,
      shades: _mockLipstickShades,
      tags: [
        '16H Weightless Wear',
        'Transfer Proof',
        'Clean INCI',
        'Vegan & Cruelty Free',
      ],
      skinTypeSuitability: 'Recommended for dry and sensitive lips',
      keyBenefits: [
        'Micro-spherical Hyaluronic plumping',
        'Zero feathering into fine lip lines',
        'Silky cashmere second-skin sensation',
      ],
    );
  }

  @override
  Future<MiaProductCard> processVoiceCommand(
    String command, {
    required MiaProductCard currentProduct,
  }) async {
    await Future.delayed(const Duration(milliseconds: 350));
    final lower = command.toLowerCase();

    int targetIndex = currentProduct.activeShadeIndex;

    if (lower.contains('honey')) {
      targetIndex = 0;
    } else if (lower.contains('berry')) {
      targetIndex = 1;
    } else if (lower.contains('ruby') || lower.contains('red')) {
      targetIndex = 2;
    } else if (lower.contains('petal') || lower.contains('nude')) {
      targetIndex = 3;
    } else if (lower.contains('coral') || lower.contains('sunset')) {
      targetIndex = 4;
    } else if (lower.contains('party') || lower.contains('night')) {
      // Party shade selection: Berry Burst or Ruby
      targetIndex = 1;
    }

    return currentProduct.copyWith(activeShadeIndex: targetIndex);
  }

  @override
  Future<MiaIngredientAnalysis> parseInstagramUrl(String url) async {
    // Simulate real extraction stages delay
    await Future.delayed(const Duration(milliseconds: 1200));

    final sampleLipstick = await getFeaturedLipstickProduct();

    return MiaIngredientAnalysis(
      sourceUrl: url.isNotEmpty
          ? url
          : 'https://www.instagram.com/reel/C3x9L7vM_evermi/',
      postTitle: 'Viral Hydrating Lip Oil & Velvet Matte Breakdown',
      authorHandle: '@dr.ananya_derm',
      postThumbnail:
          'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=600&auto=format&fit=crop&q=80',
      parsedSummary:
          'Extracted 6 clean dermatological ingredients from video caption and OCR label analysis. 0 pore-clogging waxes, pure biocompatible plant lipids.',
      overallSafetyScore: 98.4,
      verdict:
          'Clean, derm-approved formulation. Outstanding 98.4% safety rating with zero comedogenic oils or synthetic perfumes.',
      matchedProduct: sampleLipstick,
      suitabilityTags: const [
        MiaSuitabilityTag(
          label: 'Sensitive Lips Approved',
          isPositive: true,
          category: 'Safety',
        ),
        MiaSuitabilityTag(
          label: 'Non-Comedogenic (0 Pore Clogging)',
          isPositive: true,
          category: 'Skin Health',
        ),
        MiaSuitabilityTag(
          label: 'Hyaluronic Hydration Boost',
          isPositive: true,
          category: 'Actives',
        ),
        MiaSuitabilityTag(
          label: '100% Fragrance & Paraben Free',
          isPositive: true,
          category: 'Clean Standard',
        ),
        MiaSuitabilityTag(
          label: 'Pregnancy & Nursing Safe',
          isPositive: true,
          category: 'Safety',
        ),
      ],
      ingredients: const [
        MiaIngredient(
          name: 'Hyaluronic Acid Spheres',
          concentration: '2.0%',
          purpose: 'Deep Cellular Hydration & Plumping',
          safetyRating: 'EWG 1 (Green)',
          comedogenicRating: 0,
          isHero: true,
          explanation:
              'Dehydrated micro-spheres that swell upon contact with lip moisture, filling fine lines immediately.',
        ),
        MiaIngredient(
          name: 'Organic Shea Butter',
          concentration: 'Cold Pressed',
          purpose: 'Lipid Barrier Recovery & Softening',
          safetyRating: 'EWG 1 (Green)',
          comedogenicRating: 0,
          isHero: true,
          explanation:
              'High in stearic and oleic fatty acids to seal cracks and protect from cold wind exposure.',
        ),
        MiaIngredient(
          name: 'Niacinamide (Vitamin B3)',
          concentration: '3.5%',
          purpose: 'Anti-Pigmentation & Barrier Repair',
          safetyRating: 'Derm Gold Standard',
          comedogenicRating: 0,
          isHero: true,
          explanation:
              'Reduces hyperpigmentation around lip contours and strengthens ceramide synthesis.',
        ),
        MiaIngredient(
          name: '100% Sugarcane Squalane',
          concentration: 'Pure Bio-lipid',
          purpose: 'Featherlight Moisture Seal',
          safetyRating: 'EWG 1 (Green)',
          comedogenicRating: 0,
          isHero: false,
          explanation:
              'Biocompatible with natural human sebum; glides like silk without tacky residue.',
        ),
        MiaIngredient(
          name: 'Tocopherol (Vitamin E)',
          concentration: '1.2%',
          purpose: 'Free Radical Environmental Shield',
          safetyRating: 'EWG 1 (Green)',
          comedogenicRating: 0,
          isHero: false,
          explanation:
              'Potent lipid-soluble antioxidant guarding lips against urban smog and oxidative UV stress.',
        ),
        MiaIngredient(
          name: 'Centella Asiatica (Cica)',
          concentration: '0.8%',
          purpose: 'Fast Soothing & Micro-Repair',
          safetyRating: 'EWG 1 (Green)',
          comedogenicRating: 0,
          isHero: false,
          explanation:
              'Calms hypersensitivity, accelerates cellular renewal, and eliminates chapped peeling.',
        ),
      ],
    );
  }

  @override
  Future<MiaMessage> processQuery({
    required String query,
    required bool isVoice,
    required MiaProductCard? currentProduct,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final lower = query.toLowerCase();
    final baseProduct = currentProduct ?? await getFeaturedLipstickProduct();

    // Check if query is an Instagram link
    if (lower.contains('instagram.com') || lower.contains('instagr.am')) {
      final analysis = await parseInstagramUrl(query);
      return MiaMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        sender: MiaSender.mia,
        text:
            'I analyzed that Instagram post for you! Here is the complete chemical safety & ingredient breakdown for the featured lipstick formula:',
        timestamp: DateTime.now(),
        isVoice: isVoice,
        ingredientAnalysis: analysis,
        product: analysis.matchedProduct,
        suggestedFollowUps: const [
          'Show me Honey Shade',
          'Switch to Berry Burst',
          'Is this safe for sensitive lips?',
        ],
      );
    }

    // Voice Shade command matching
    if (lower.contains('honey') ||
        lower.contains('berry') ||
        lower.contains('ruby') ||
        lower.contains('petal') ||
        lower.contains('coral') ||
        lower.contains('shade') ||
        lower.contains('switch')) {
      final updatedProduct =
          await processVoiceCommand(query, currentProduct: baseProduct);
      final shadeName = updatedProduct.activeShade.name;
      final undertone = updatedProduct.activeShade.undertone;

      return MiaMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        sender: MiaSender.mia,
        text:
            'Switched to "$shadeName"! Featuring $undertone with a ${updatedProduct.activeShade.finish} texture. The skin swatch has been adjusted below.',
        timestamp: DateTime.now(),
        isVoice: isVoice,
        product: updatedProduct,
        suggestedFollowUps: const [
          'Switch to Berry Burst',
          'Show me Honey Shade',
          'Switch to Ruby Velvet',
        ],
      );
    }

    // Night party / party lipstick query
    if (lower.contains('party') ||
        lower.contains('night') ||
        lower.contains('evening') ||
        lower.contains('lipstick')) {
      final partyProduct = baseProduct.copyWith(activeShadeIndex: 1); // Berry
      return MiaMessage(
        id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
        sender: MiaSender.mia,
        text:
            'For night parties and evening events, I recommend rich berry & crimson velvet finishes that hold for 16 hours without touch-ups. Here is our award-winning velvet lipstick in "Berry Burst":',
        timestamp: DateTime.now(),
        isVoice: isVoice,
        product: partyProduct,
        suggestedFollowUps: const [
          'Show me Honey Shade',
          'Switch to Ruby Velvet',
          'Check ingredient safety',
        ],
      );
    }

    // Default friendly assistant response with structured lipstick card
    return MiaMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      sender: MiaSender.mia,
      text:
          'Here is our top-rated clean velvet lipstick formulated with hyaluronic spheres. You can ask me to switch shades via voice, or paste any Instagram link to analyze its ingredients!',
      timestamp: DateTime.now(),
      isVoice: isVoice,
      product: baseProduct,
      suggestedFollowUps: const [
        'Night-party lipsticks',
        'Show me Honey Shade',
        'Switch to Berry Burst',
      ],
    );
  }

  @override
  List<String> getSuggestedVoiceTriggers() {
    return const [
      'Night-party lipsticks',
      'Show me Honey Shade',
      'Switch to Berry Burst',
      'Switch to Ruby Velvet',
      'Switch to Coral Sunset',
    ];
  }

  @override
  List<String> getQuickActionPills() {
    return const [
      '🎤 "Night-party lipsticks"',
      '💄 "Show me Honey Shade"',
      '🍇 "Switch to Berry Burst"',
      '🍷 "Switch to Ruby Velvet"',
      '📸 Paste IG Link',
    ];
  }
}
