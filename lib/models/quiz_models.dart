import 'dart:convert';

/// Dynamic life stages for evermi personalization funnel
enum LifeStage {
  teen,
  college,
  professional,
  newlywed,
  newMom,
}

extension LifeStageExtension on LifeStage {
  String get id => name;

  String get displayName {
    switch (this) {
      case LifeStage.teen:
        return "Teen & Gen-Z";
      case LifeStage.college:
        return "College Life";
      case LifeStage.professional:
        return "Working Professional";
      case LifeStage.newlywed:
        return "Newlywed & Trousseau";
      case LifeStage.newMom:
        return "New Mom & Maternity";
    }
  }

  String get tagline {
    switch (this) {
      case LifeStage.teen:
        return "Acne defense, playful trends & pocket-friendly staples";
      case LifeStage.college:
        return "Late-night glow, sun protection & 5-min campus glam";
      case LifeStage.professional:
        return "Desk-to-dinner, anti-pollution & blue light defense";
      case LifeStage.newlywed:
        return "Bridal radiance, luxury perfumes & lasting pampering";
      case LifeStage.newMom:
        return "Nursing-safe care, gentle hydration & postpartum recovery";
    }
  }

  String get emoji {
    switch (this) {
      case LifeStage.teen:
        return "✨";
      case LifeStage.college:
        return "🎒";
      case LifeStage.professional:
        return "💼";
      case LifeStage.newlywed:
        return "💍";
      case LifeStage.newMom:
        return "🍼";
    }
  }

  String get badge {
    switch (this) {
      case LifeStage.teen:
        return "Ages 13–18";
      case LifeStage.college:
        return "Ages 18–23";
      case LifeStage.professional:
        return "Fast-Paced Career";
      case LifeStage.newlywed:
        return "Bridal Glow";
      case LifeStage.newMom:
        return "Gentle & Pure";
    }
  }

  static LifeStage fromString(String? value) {
    if (value == null) return LifeStage.professional;
    return LifeStage.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => LifeStage.professional,
    );
  }
}

/// Generic quiz option model
class QuizOption {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final String? badge;

  const QuizOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    this.badge,
  });
}

/// Persisted user personalization profile
class UserQuizProfile {
  final LifeStage lifeStage;
  final String skinType;
  final List<String> concerns;
  final String routineStyle;
  final String deliveryUrgency;
  final DateTime completedAt;

  UserQuizProfile({
    required this.lifeStage,
    required this.skinType,
    required this.concerns,
    required this.routineStyle,
    this.deliveryUrgency = 'Express Delivery',
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'lifeStage': lifeStage.name,
      'skinType': skinType,
      'concerns': concerns,
      'routineStyle': routineStyle,
      'deliveryUrgency': deliveryUrgency,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory UserQuizProfile.fromMap(Map<String, dynamic> map) {
    return UserQuizProfile(
      lifeStage: LifeStageExtension.fromString(map['lifeStage'] as String?),
      skinType: map['skinType'] as String? ?? 'Normal / Balanced',
      concerns: List<String>.from(map['concerns'] ?? []),
      routineStyle: map['routineStyle'] as String? ?? 'Quick & Minimal (3 steps)',
      deliveryUrgency: map['deliveryUrgency'] as String? ?? 'Express Delivery',
      completedAt: map['completedAt'] != null
          ? DateTime.tryParse(map['completedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory UserQuizProfile.fromJson(String source) =>
      UserQuizProfile.fromMap(jsonDecode(source) as Map<String, dynamic>);
}

/// Rich personalization profile model used across the home feed & care engine
class UserProfile {
  final String fullName;
  final String age;
  final LifeStage lifeStage;
  final String skinType; // 'normal', 'dry', 'oily', 'combination'
  final List<String> concerns;
  final List<String> vibes;
  final List<String> avoidIngredients;
  final String budgetRange; // 'budget', 'midRange', 'luxury'

  UserProfile({
    required this.fullName,
    this.age = '22',
    required this.lifeStage,
    required this.skinType,
    this.concerns = const [],
    this.vibes = const ['Clean Dewy', 'Minimalist'],
    this.avoidIngredients = const ['Parabens', 'Sulfates', 'Artificial Fragrance'],
    this.budgetRange = 'midRange',
  });

  String get skinTypeCapitalized {
    if (skinType.isEmpty) return 'Balanced';
    final cleaned = skinType.replaceAll(RegExp(r'[^a-zA-Z]'), ' ').trim();
    if (cleaned.isEmpty) return 'Balanced';
    final firstWord = cleaned.split(' ').first;
    return firstWord[0].toUpperCase() + firstWord.substring(1).toLowerCase();
  }

  UserProfile copyWith({
    String? fullName,
    String? age,
    LifeStage? lifeStage,
    String? skinType,
    List<String>? concerns,
    List<String>? vibes,
    List<String>? avoidIngredients,
    String? budgetRange,
  }) {
    return UserProfile(
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      lifeStage: lifeStage ?? this.lifeStage,
      skinType: skinType ?? this.skinType,
      concerns: concerns ?? this.concerns,
      vibes: vibes ?? this.vibes,
      avoidIngredients: avoidIngredients ?? this.avoidIngredients,
      budgetRange: budgetRange ?? this.budgetRange,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'age': age,
      'lifeStage': lifeStage.name,
      'skinType': skinType,
      'concerns': concerns,
      'vibes': vibes,
      'avoidIngredients': avoidIngredients,
      'budgetRange': budgetRange,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      fullName: map['fullName'] as String? ?? 'Riya',
      age: map['age']?.toString() ?? '22',
      lifeStage: LifeStageExtension.fromString(map['lifeStage'] as String?),
      skinType: map['skinType'] as String? ?? 'oily',
      concerns: List<String>.from(map['concerns'] ?? []),
      vibes: List<String>.from(map['vibes'] ?? ['Clean Dewy']),
      avoidIngredients: List<String>.from(
        map['avoidIngredients'] ?? ['Parabens', 'Sulfates'],
      ),
      budgetRange: map['budgetRange'] as String? ?? 'midRange',
    );
  }

  String toJson() => jsonEncode(toMap());

  factory UserProfile.fromJson(String source) =>
      UserProfile.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory UserProfile.fromQuizProfile(UserQuizProfile quiz, {String? name}) {
    String normalizedSkin = 'combination';
    final lower = quiz.skinType.toLowerCase();
    if (lower.contains('oily')) {
      normalizedSkin = 'oily';
    } else if (lower.contains('dry')) {
      normalizedSkin = 'dry';
    } else if (lower.contains('normal')) {
      normalizedSkin = 'normal';
    } else if (lower.contains('combination')) {
      normalizedSkin = 'combination';
    }

    return UserProfile(
      fullName: (name != null && name.trim().isNotEmpty) ? name : 'Riya',
      lifeStage: quiz.lifeStage,
      skinType: normalizedSkin,
      concerns: quiz.concerns,
      vibes: [
        if (quiz.lifeStage == LifeStage.college) 'Clean Dewy'
        else if (quiz.lifeStage == LifeStage.professional) 'Office Chic'
        else if (quiz.lifeStage == LifeStage.newMom) 'Pure & Safe'
        else if (quiz.lifeStage == LifeStage.newlywed) 'Bridal Glow'
        else 'Minimalist',
      ],
      avoidIngredients: const ['Parabens', 'Sulfates', 'Synthetic Dyes'],
      budgetRange: quiz.lifeStage == LifeStage.teen ? 'budget' : 'midRange',
    );
  }
}
