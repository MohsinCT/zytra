import 'package:flutter/material.dart';

/// Interaction mode for Mia retail engine.
enum MiaInteractionMode {
  voice,
  silent,
}

/// Dynamic canvas layout types rendered by Mia.
enum MiaCanvasLayoutType {
  welcome,
  productShades,
  ingredientAnalysis,
  comparison,
}

/// Represents an individual shade of a cosmetic product.
class MiaShade {
  final String id;
  final String name;
  final String hexColor;
  final String imageUrl;
  final String swatchUrl;
  final String undertone;
  final String finish;
  final String skinToneHex;
  final String description;

  const MiaShade({
    required this.id,
    required this.name,
    required this.hexColor,
    required this.imageUrl,
    required this.swatchUrl,
    required this.undertone,
    required this.finish,
    this.skinToneHex = '#F4D0B5',
    this.description = '',
  });

  Color get color {
    final cleanHex = hexColor.replaceAll('#', '');
    if (cleanHex.length == 6) {
      return Color(int.parse('FF$cleanHex', radix: 16));
    } else if (cleanHex.length == 8) {
      return Color(int.parse(cleanHex, radix: 16));
    }
    return const Color(0xFFFF2D6F);
  }

  Color get skinToneColor {
    final cleanHex = skinToneHex.replaceAll('#', '');
    if (cleanHex.length == 6) {
      return Color(int.parse('FF$cleanHex', radix: 16));
    }
    return const Color(0xFFF4D0B5);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'hexColor': hexColor,
        'imageUrl': imageUrl,
        'swatchUrl': swatchUrl,
        'undertone': undertone,
        'finish': finish,
        'skinToneHex': skinToneHex,
        'description': description,
      };

  factory MiaShade.fromJson(Map<String, dynamic> json) => MiaShade(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        hexColor: json['hexColor'] as String? ?? '#FF2D6F',
        imageUrl: json['imageUrl'] as String? ?? '',
        swatchUrl: json['swatchUrl'] as String? ?? '',
        undertone: json['undertone'] as String? ?? 'Neutral',
        finish: json['finish'] as String? ?? 'Matte',
        skinToneHex: json['skinToneHex'] as String? ?? '#F4D0B5',
        description: json['description'] as String? ?? '',
      );
}

/// Structured state for product card dynamic layout.
class MiaProductCard {
  final String id;
  final String productName;
  final String brand;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final String description;
  final int activeShadeIndex;
  final List<MiaShade> shades;
  final List<String> tags;
  final String skinTypeSuitability;
  final List<String> keyBenefits;

  const MiaProductCard({
    required this.id,
    required this.productName,
    required this.brand,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.description,
    required this.activeShadeIndex,
    required this.shades,
    this.tags = const [],
    this.skinTypeSuitability = 'All skin tones',
    this.keyBenefits = const [],
  });

  MiaShade get activeShade {
    if (shades.isEmpty) {
      return const MiaShade(
        id: 'default',
        name: 'Default',
        hexColor: '#FF2D6F',
        imageUrl: '',
        swatchUrl: '',
        undertone: 'Neutral',
        finish: 'Matte',
      );
    }
    final safeIndex =
        activeShadeIndex.clamp(0, shades.length - 1);
    return shades[safeIndex];
  }

  MiaProductCard copyWith({
    String? id,
    String? productName,
    String? brand,
    double? price,
    double? originalPrice,
    double? rating,
    int? reviewCount,
    String? description,
    int? activeShadeIndex,
    List<MiaShade>? shades,
    List<String>? tags,
    String? skinTypeSuitability,
    List<String>? keyBenefits,
  }) {
    return MiaProductCard(
      id: id ?? this.id,
      productName: productName ?? this.productName,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      description: description ?? this.description,
      activeShadeIndex: activeShadeIndex ?? this.activeShadeIndex,
      shades: shades ?? this.shades,
      tags: tags ?? this.tags,
      skinTypeSuitability: skinTypeSuitability ?? this.skinTypeSuitability,
      keyBenefits: keyBenefits ?? this.keyBenefits,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'productName': productName,
        'brand': brand,
        'price': price,
        'originalPrice': originalPrice,
        'rating': rating,
        'reviewCount': reviewCount,
        'description': description,
        'activeShadeIndex': activeShadeIndex,
        'shades': shades.map((s) => s.toJson()).toList(),
        'tags': tags,
        'skinTypeSuitability': skinTypeSuitability,
        'keyBenefits': keyBenefits,
      };

  factory MiaProductCard.fromJson(Map<String, dynamic> json) => MiaProductCard(
        id: json['id'] as String? ?? '',
        productName: json['productName'] as String? ?? '',
        brand: json['brand'] as String? ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        originalPrice: (json['originalPrice'] as num?)?.toDouble(),
        rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
        reviewCount: json['reviewCount'] as int? ?? 120,
        description: json['description'] as String? ?? '',
        activeShadeIndex: json['activeShadeIndex'] as int? ?? 0,
        shades: (json['shades'] as List<dynamic>?)
                ?.map((item) => MiaShade.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [],
        tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
        skinTypeSuitability:
            json['skinTypeSuitability'] as String? ?? 'All skin types',
        keyBenefits:
            (json['keyBenefits'] as List<dynamic>?)?.cast<String>() ?? [],
      );
}

/// Individual cosmetic/skincare ingredient parsed by Mia.
class MiaIngredient {
  final String name;
  final String concentration;
  final String purpose;
  final String safetyRating;
  final int comedogenicRating; // 0 (non-comedogenic) to 5
  final bool isHero;
  final String explanation;

  const MiaIngredient({
    required this.name,
    required this.concentration,
    required this.purpose,
    required this.safetyRating,
    required this.comedogenicRating,
    this.isHero = false,
    this.explanation = '',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'concentration': concentration,
        'purpose': purpose,
        'safetyRating': safetyRating,
        'comedogenicRating': comedogenicRating,
        'isHero': isHero,
        'explanation': explanation,
      };

  factory MiaIngredient.fromJson(Map<String, dynamic> json) => MiaIngredient(
        name: json['name'] as String? ?? '',
        concentration: json['concentration'] as String? ?? '',
        purpose: json['purpose'] as String? ?? '',
        safetyRating: json['safetyRating'] as String? ?? 'Safe',
        comedogenicRating: json['comedogenicRating'] as int? ?? 0,
        isHero: json['isHero'] as bool? ?? false,
        explanation: json['explanation'] as String? ?? '',
      );
}

/// Tag describing skin compatibility or formulation attribute.
class MiaSuitabilityTag {
  final String label;
  final bool isPositive;
  final String category;

  const MiaSuitabilityTag({
    required this.label,
    this.isPositive = true,
    this.category = 'Skin Health',
  });

  Map<String, dynamic> toJson() => {
        'label': label,
        'isPositive': isPositive,
        'category': category,
      };

  factory MiaSuitabilityTag.fromJson(Map<String, dynamic> json) =>
      MiaSuitabilityTag(
        label: json['label'] as String? ?? '',
        isPositive: json['isPositive'] as bool? ?? true,
        category: json['category'] as String? ?? 'Skin Health',
      );
}

/// Parsed analysis of an Instagram post or reel.
class MiaIngredientAnalysis {
  final String sourceUrl;
  final String postTitle;
  final String authorHandle;
  final String postThumbnail;
  final String parsedSummary;
  final double overallSafetyScore; // 0 - 100
  final List<MiaIngredient> ingredients;
  final List<MiaSuitabilityTag> suitabilityTags;
  final String verdict;
  final MiaProductCard? matchedProduct;

  const MiaIngredientAnalysis({
    required this.sourceUrl,
    required this.postTitle,
    required this.authorHandle,
    required this.postThumbnail,
    required this.parsedSummary,
    required this.overallSafetyScore,
    required this.ingredients,
    required this.suitabilityTags,
    required this.verdict,
    this.matchedProduct,
  });

  Map<String, dynamic> toJson() => {
        'sourceUrl': sourceUrl,
        'postTitle': postTitle,
        'authorHandle': authorHandle,
        'postThumbnail': postThumbnail,
        'parsedSummary': parsedSummary,
        'overallSafetyScore': overallSafetyScore,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
        'suitabilityTags': suitabilityTags.map((t) => t.toJson()).toList(),
        'verdict': verdict,
        'matchedProduct': matchedProduct?.toJson(),
      };

  factory MiaIngredientAnalysis.fromJson(Map<String, dynamic> json) =>
      MiaIngredientAnalysis(
        sourceUrl: json['sourceUrl'] as String? ?? '',
        postTitle: json['postTitle'] as String? ?? '',
        authorHandle: json['authorHandle'] as String? ?? '@beautycreator',
        postThumbnail: json['postThumbnail'] as String? ?? '',
        parsedSummary: json['parsedSummary'] as String? ?? '',
        overallSafetyScore:
            (json['overallSafetyScore'] as num?)?.toDouble() ?? 95.0,
        ingredients: (json['ingredients'] as List<dynamic>?)
                ?.map((item) =>
                    MiaIngredient.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [],
        suitabilityTags: (json['suitabilityTags'] as List<dynamic>?)
                ?.map((item) =>
                    MiaSuitabilityTag.fromJson(item as Map<String, dynamic>))
                .toList() ??
            [],
        verdict: json['verdict'] as String? ?? '',
        matchedProduct: json['matchedProduct'] != null
            ? MiaProductCard.fromJson(
                json['matchedProduct'] as Map<String, dynamic>)
            : null,
      );
}

/// Message model for conversational history and silent chat mode.
enum MiaSender {
  user,
  mia,
  system,
}

class MiaMessage {
  final String id;
  final MiaSender sender;
  final String text;
  final DateTime timestamp;
  final bool isVoice;
  final MiaProductCard? product;
  final MiaIngredientAnalysis? ingredientAnalysis;
  final List<String> suggestedFollowUps;

  const MiaMessage({
    required this.id,
    required this.sender,
    required this.text,
    required this.timestamp,
    this.isVoice = false,
    this.product,
    this.ingredientAnalysis,
    this.suggestedFollowUps = const [],
  });
}
