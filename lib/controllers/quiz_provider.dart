import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/models/quiz_models.dart';
import 'package:zytranow/controllers/user_provider.dart';
import 'package:zytranow/view/screens/main_screen.dart';
import 'package:zytranow/view/screens/quiz/analyzing_routine_loading_screen.dart';

class QuizProvider extends ChangeNotifier {
  final PageController pageController = PageController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  int _currentStep = 1;
  String _name = '';
  String _age = '';
  LifeStage? _selectedLifeStage;
  String? _selectedSkinType;
  final Set<String> _selectedConcerns = {};
  String? _selectedRoutineStyle;

  final Set<String> _draftConcerns = {};

  bool _isQuizCompleted = false;
  UserProfile? _userProfile;

  // Routine analysis state
  int _analyzingStatusIndex = 0;
  bool _isAnalyzingRoutineRunning = false;
  Timer? _statusTimer;
  Timer? _analyzingNavigationTimer;

  static const List<String> analyzingStatusUpdates = [
    "Analyzing your skin barrier & priorities...",
    "Matching clinical & clean beauty formulations...",
    "Checking inventory & product availability...",
    "Your personalized routine is ready!",
  ];

  // Getters
  int get currentStep => _currentStep;
  String get name => _name;
  String get age => _age;
  LifeStage? get selectedLifeStage => _selectedLifeStage;
  String? get selectedSkinType => _selectedSkinType;
  Set<String> get selectedConcerns => Set.unmodifiable(_selectedConcerns);
  Set<String> get draftConcerns => Set.unmodifiable(_draftConcerns);
  String? get selectedRoutineStyle => _selectedRoutineStyle;
  int get analyzingStatusIndex => _analyzingStatusIndex;

  bool get isQuizCompleted => _isQuizCompleted;
  UserProfile? get userProfile => _userProfile;

  void initControllers({String? defaultName, String? defaultAge}) {
    final initialName = _name.isNotEmpty ? _name : (defaultName ?? '');
    if (nameController.text != initialName) {
      nameController.text = initialName;
    }
    if (_name.isEmpty && initialName.isNotEmpty) {
      _name = initialName;
    }

    final initialAge = _age.isNotEmpty ? _age : (defaultAge ?? '');
    if (ageController.text != initialAge) {
      ageController.text = initialAge;
    }
    if (_age.isEmpty && initialAge.isNotEmpty) {
      _age = initialAge;
    }
  }

  void setName(String value) {
    _name = value;
    if (nameController.text != value) {
      nameController.text = value;
    }
    notifyListeners();
  }

  void setAge(String value) {
    _age = value;
    if (ageController.text != value) {
      ageController.text = value;
    }
    notifyListeners();
  }

  void initDraftConcerns(List<String> initial) {
    _draftConcerns.clear();
    _draftConcerns.addAll(initial);
    notifyListeners();
  }

  void toggleDraftConcern(String concern) {
    if (_draftConcerns.contains(concern)) {
      _draftConcerns.remove(concern);
    } else {
      if (_draftConcerns.length < 3) {
        _draftConcerns.add(concern);
      }
    }
    notifyListeners();
  }

  // Step 1: Life Stage Options
  List<QuizOption> get lifeStageOptions => [
    QuizOption(
      id: LifeStage.teen.name,
      title: LifeStage.teen.displayName,
      subtitle: LifeStage.teen.tagline,
      emoji: LifeStage.teen.emoji,
      badge: LifeStage.teen.badge,
    ),
    QuizOption(
      id: LifeStage.college.name,
      title: LifeStage.college.displayName,
      subtitle: LifeStage.college.tagline,
      emoji: LifeStage.college.emoji,
      badge: LifeStage.college.badge,
    ),
    QuizOption(
      id: LifeStage.professional.name,
      title: LifeStage.professional.displayName,
      subtitle: LifeStage.professional.tagline,
      emoji: LifeStage.professional.emoji,
      badge: LifeStage.professional.badge,
    ),
    QuizOption(
      id: LifeStage.newlywed.name,
      title: LifeStage.newlywed.displayName,
      subtitle: LifeStage.newlywed.tagline,
      emoji: LifeStage.newlywed.emoji,
      badge: LifeStage.newlywed.badge,
    ),
    QuizOption(
      id: LifeStage.newMom.name,
      title: LifeStage.newMom.displayName,
      subtitle: LifeStage.newMom.tagline,
      emoji: LifeStage.newMom.emoji,
      badge: LifeStage.newMom.badge,
    ),
  ];

  // Step 2: Dynamic Skin / Body Type Options based on LifeStage
  List<QuizOption> get skinTypeOptions {
    final stage = _selectedLifeStage ?? LifeStage.professional;
    switch (stage) {
      case LifeStage.teen:
        return const [
          QuizOption(
            id: 'oily_acne',
            title: 'Oily & Breakout-Prone',
            subtitle: 'Shiny T-zone, frequent pimples & active blackheads',
            emoji: '🫧',
            badge: 'High Oil',
          ),
          QuizOption(
            id: 'combination_teen',
            title: 'Combination & Hormonal',
            subtitle: 'Oily forehead and nose, normal to dry cheeks',
            emoji: '⚖️',
            badge: 'T-Zone',
          ),
          QuizOption(
            id: 'sensitive_teen',
            title: 'Sensitive & Redness',
            subtitle: 'Stings easily with harsh products, flushed cheeks',
            emoji: '🌸',
            badge: 'Gentle Needed',
          ),
          QuizOption(
            id: 'normal_teen',
            title: 'Normal & Balanced',
            subtitle: 'Few breakouts, generally comfortable & clear',
            emoji: '✨',
            badge: 'Balanced',
          ),
        ];

      case LifeStage.college:
        return const [
          QuizOption(
            id: 'stressed_dull',
            title: 'Dull & Sleep-Deprived',
            subtitle: 'Lacks radiance from all-nighters & screen exposure',
            emoji: '😴',
            badge: 'Needs Glow',
          ),
          QuizOption(
            id: 'sun_exposed_oil',
            title: 'Sun-Exposed & Oily',
            subtitle: 'Commute tan, sweat, open pores & midday shine',
            emoji: '☀️',
            badge: 'SPF Essential',
          ),
          QuizOption(
            id: 'acne_college',
            title: 'Hormonal & Stress Acne',
            subtitle: 'Exam stress flare-ups on jawline & cheeks',
            emoji: '🎯',
            badge: 'Targeted Care',
          ),
          QuizOption(
            id: 'dry_dehydrated_college',
            title: 'Dehydrated & Tight',
            subtitle:
                'Drinks lots of coffee, flaky after air-conditioned classes',
            emoji: '💧',
            badge: 'Hydration Fix',
          ),
        ];

      case LifeStage.professional:
        return const [
          QuizOption(
            id: 'screen_fatigued',
            title: 'Screen-Fatigued & Dull',
            subtitle: 'Blue light fatigue, tired eyes & uneven skin tone',
            emoji: '💻',
            badge: 'Anti-Fatigue',
          ),
          QuizOption(
            id: 'ac_dehydrated',
            title: 'AC-Dry & Dehydrated',
            subtitle: 'Tight skin from 8+ hours in dry office air conditioning',
            emoji: '❄️',
            badge: 'Moisture Lock',
          ),
          QuizOption(
            id: 'pollution_combination',
            title: 'Pollution-Exposed Combo',
            subtitle: 'City grime congestion, shiny T-zone, dull perimeter',
            emoji: '🏙️',
            badge: 'City Defense',
          ),
          QuizOption(
            id: 'early_aging',
            title: 'Early Fine Lines & Texture',
            subtitle: 'Focus on elasticity, barrier repair & subtle firmness',
            emoji: '⏳',
            badge: 'Pro-Youth',
          ),
        ];

      case LifeStage.newlywed:
        return const [
          QuizOption(
            id: 'bridal_radiance_prep',
            title: 'Bridal Radiance & Glass Skin',
            subtitle: 'Goal: luminous, ultra-hydrated lit-from-within glow',
            emoji: '💎',
            badge: 'Lit-from-Within',
          ),
          QuizOption(
            id: 'heavy_makeup_recovery',
            title: 'Post-Event Clogged & Tired',
            subtitle: 'Clogged pores from layers of HD makeup & late parties',
            emoji: '💄',
            badge: 'Deep Detox',
          ),
          QuizOption(
            id: 'dry_trousseau',
            title: 'Dry & Body Pampering Need',
            subtitle: 'Velvety smooth limbs, neck & décolletage focus',
            emoji: '✨',
            badge: 'Silk Finish',
          ),
          QuizOption(
            id: 'sensitive_glow',
            title: 'Sensitive & Reactive Glow',
            subtitle: 'Prone to allergic reactions before big milestones',
            emoji: '🌿',
            badge: 'Calming Glow',
          ),
        ];

      case LifeStage.newMom:
        return const [
          QuizOption(
            id: 'postpartum_dry',
            title: 'Postpartum Dry & Depleted',
            subtitle: 'Hormonal dryness, dry patches & thirsty skin barrier',
            emoji: '💧',
            badge: 'Deep Nourish',
          ),
          QuizOption(
            id: 'melasma_pigmentation',
            title: 'Melasma & Hormonal Marks',
            subtitle: 'Dark spots, butterfly mask pigmentation shifts',
            emoji: '🌓',
            badge: 'Safe Brightening',
          ),
          QuizOption(
            id: 'ultra_sensitive_mom',
            title: 'Ultra-Sensitive & Nursing Safe',
            subtitle: 'Clean, fragrance-free, safe around cuddles & baby',
            emoji: '🧸',
            badge: 'Clean & Safe',
          ),
          QuizOption(
            id: 'exhausted_eye_bags',
            title: 'Night-Waking Puffy & Tired',
            subtitle: 'Interrupted sleep, dark under-eye circles & puffiness',
            emoji: '🌙',
            badge: 'Express Revival',
          ),
        ];
    }
  }

  // Step 3: Dynamic Concerns tailored to selected LifeStage
  List<QuizOption> get concernOptions {
    final stage = _selectedLifeStage ?? LifeStage.professional;
    switch (stage) {
      case LifeStage.teen:
        return const [
          QuizOption(
            id: 'blackheads_pimples',
            title: 'Fast Pimple Patches & Spots',
            subtitle: 'Zap emergency pimples before school / events',
            emoji: '🩹',
          ),
          QuizOption(
            id: 'oil_shine_control',
            title: 'All-Day Matte / Shine Control',
            subtitle: 'Oil-free cleansers & blotting compacts',
            emoji: '🍃',
          ),
          QuizOption(
            id: 'lip_cheek_tints',
            title: 'Juicy Lip Tints & Clean Glosses',
            subtitle: 'Pocket-friendly everyday cute tints',
            emoji: '🍓',
          ),
          QuizOption(
            id: 'hair_dandruff_grease',
            title: 'Scalp Freshness & No Grease',
            subtitle: 'Lightweight anti-dandruff & clarifying washes',
            emoji: '🚿',
          ),
        ];

      case LifeStage.college:
        return const [
          QuizOption(
            id: 'dark_circles_study',
            title: 'All-Nighter Under-Eye Care',
            subtitle: 'Caffeine eye serums & cooling gel patches',
            emoji: '☕',
          ),
          QuizOption(
            id: 'weightless_sunscreen',
            title: 'Zero-Whitecast Daily Sunscreen',
            subtitle: 'Matte, sweat-proof protection for campus rush',
            emoji: '🛡️',
          ),
          QuizOption(
            id: 'five_min_glam',
            title: '5-Minute Rush Makeup Kit',
            subtitle: 'Tinted moisturizer, smudge-proof kajal, tint',
            emoji: '⚡',
          ),
          QuizOption(
            id: 'budget_glow_serum',
            title: 'Affordable Niacinamide / C Glow',
            subtitle: 'High potency, student-budget friendly',
            emoji: '🏷️',
          ),
        ];

      case LifeStage.professional:
        return const [
          QuizOption(
            id: 'instant_glow_boost',
            title: 'Meeting-Ready Instant Radiance',
            subtitle: 'Hydration mists, brightening serums, glow drops',
            emoji: '💼',
          ),
          QuizOption(
            id: 'blue_light_shield',
            title: 'Anti-Pollution & Blue Light Screen',
            subtitle: 'Urban defense barrier creams & antioxidant shields',
            emoji: '🛡️',
          ),
          QuizOption(
            id: 'desk_to_dinner',
            title: 'Long-Wear Desk to Dinner Glam',
            subtitle: 'Transfer-proof lipsticks, setting sprays & liners',
            emoji: '💄',
          ),
          QuizOption(
            id: 'hairfall_stress',
            title: 'Stress Hair Fall & Scalp Serum',
            subtitle: 'Rosemary, peptide and biotin root nourishment',
            emoji: '🌿',
          ),
        ];

      case LifeStage.newlywed:
        return const [
          QuizOption(
            id: 'glass_skin_routine',
            title: 'Bridal Glass Skin Glow Routine',
            subtitle: 'Hydration layering & dewy foundation base',
            emoji: '✨',
          ),
          QuizOption(
            id: 'luxury_signature_scents',
            title: 'Signature Long-Lasting Fragrances',
            subtitle: 'Gourmand, floral & musky intimate perfumes',
            emoji: '💐',
          ),
          QuizOption(
            id: 'silk_body_glow',
            title: 'Body Polishing & Shimmer Oils',
            subtitle: 'Velvet scrubs, whipped butters & illuminators',
            emoji: '🧴',
          ),
          QuizOption(
            id: 'party_makeup_essentials',
            title: 'High-Impact Festive Makeup',
            subtitle: 'Waterproof mascara, golden highlighter & velvet reds',
            emoji: '🎉',
          ),
        ];

      case LifeStage.newMom:
        return const [
          QuizOption(
            id: 'nursing_safe_ingredients',
            title: '100% Baby-Safe & Nursing Friendly',
            subtitle: 'Zero retinoids, gentle peptides & pregnancy safe',
            emoji: '🍼',
          ),
          QuizOption(
            id: 'three_min_survival',
            title: '3-Minute Quick Survival Routine',
            subtitle: 'Multitasking cleanser-moisturizer-SPF in one',
            emoji: '⏱️',
          ),
          QuizOption(
            id: 'stretch_marks_belly',
            title: 'Belly Butter & Elasticity Oils',
            subtitle: 'Bio-lipids, rosehip & gotu kola firming care',
            emoji: '🌸',
          ),
          QuizOption(
            id: 'postpartum_hair_growth',
            title: 'Postpartum Hair Regrowth Therapy',
            subtitle: 'Gentle follicle strengthening & biotin tonics',
            emoji: '🌱',
          ),
        ];
    }
  }

  // Step 4: Routine Style & Delivery Urgency Options
  List<QuizOption> get routineStyleOptions => const [
    QuizOption(
      id: 'express_minimal',
      title: 'Express & Minimal (3 Steps)',
      subtitle: 'Cleanse, hydrate, protect in under 3 minutes flat',
      emoji: '⚡',
      badge: 'Fast & Easy',
    ),
    QuizOption(
      id: 'balanced_glow',
      title: 'Targeted Balanced Glow (4-5 Steps)',
      subtitle: 'Includes active treatment serum & nourishing seal',
      emoji: '✨',
      badge: 'Most Popular',
    ),
    QuizOption(
      id: 'full_luxury_ritual',
      title: 'Full Glass-Skin Ritual (6+ Steps)',
      subtitle: 'Double cleansing, essence, sheet masks & lip masks',
      emoji: '👑',
      badge: 'High Self-Care',
    ),
  ];

  // Actions
  void selectLifeStage(LifeStage stage) {
    _selectedLifeStage = stage;
    // Clear previous downstream answers if life stage changed
    _selectedSkinType = null;
    _selectedConcerns.clear();
    notifyListeners();
  }

  void selectSkinType(String type) {
    _selectedSkinType = type;
    notifyListeners();
  }

  void toggleConcern(String concern) {
    if (_selectedConcerns.contains(concern)) {
      _selectedConcerns.remove(concern);
    } else {
      if (_selectedConcerns.length < 3) {
        _selectedConcerns.add(concern);
      }
    }
    notifyListeners();
  }

  void selectRoutineStyle(String style) {
    _selectedRoutineStyle = style;
    notifyListeners();
  }

  String _defaultAgeForLifeStage(LifeStage? stage) {
    switch (stage) {
      case LifeStage.teen:
        return '17';
      case LifeStage.college:
        return '21';
      case LifeStage.professional:
        return '26';
      case LifeStage.newlywed:
        return '27';
      case LifeStage.newMom:
        return '29';
      case null:
        return '22';
    }
  }

  bool canProceedCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _selectedLifeStage != null && _name.trim().isNotEmpty;
      case 2:
        return _selectedSkinType != null && _selectedSkinType!.isNotEmpty;
      case 3:
        return _selectedConcerns.isNotEmpty;
      case 4:
        return _selectedRoutineStyle != null &&
            _selectedRoutineStyle!.isNotEmpty;
      default:
        return false;
    }
  }

  void nextStep() {
    if (_currentStep < 4 && canProceedCurrentStep()) {
      _currentStep++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_currentStep > 1) {
      _currentStep--;
      notifyListeners();
    }
  }

  void setStep(int step) {
    if (step >= 1 && step <= 4) {
      _currentStep = step;
      notifyListeners();
    }
  }

  UserQuizProfile buildProfile({String? userName}) {
    final quizProfile = UserQuizProfile(
      lifeStage: _selectedLifeStage ?? LifeStage.professional,
      skinType: _selectedSkinType ?? 'Balanced',
      concerns: _selectedConcerns.toList(),
      routineStyle: _selectedRoutineStyle ?? 'Express & Minimal (3 Steps)',
      deliveryUrgency: 'Express Delivery',
    );
    _isQuizCompleted = true;
    final resolvedName = _name.trim().isNotEmpty
        ? _name.trim()
        : (userName ?? 'Riya');
    final resolvedAge = _age.trim().isNotEmpty
        ? _age.trim()
        : _defaultAgeForLifeStage(_selectedLifeStage);
    _userProfile = UserProfile.fromQuizProfile(
      quizProfile,
      name: resolvedName,
    ).copyWith(age: resolvedAge);
    notifyListeners();
    return quizProfile;
  }

  void setUserProfile(UserProfile profile) {
    _userProfile = profile;
    _isQuizCompleted = true;
    _name = profile.fullName;
    _age = profile.age;
    _selectedLifeStage = profile.lifeStage;
    _selectedSkinType = profile.skinType;
    _selectedConcerns.clear();
    _selectedConcerns.addAll(profile.concerns);
    notifyListeners();
  }

  void updateConcerns(List<String> newConcerns) {
    _selectedConcerns.clear();
    _selectedConcerns.addAll(newConcerns);
    if (_userProfile != null) {
      _userProfile = _userProfile!.copyWith(concerns: newConcerns);
    }
    notifyListeners();
  }

  void setQuizCompleted(bool completed, {UserProfile? profile}) {
    _isQuizCompleted = completed;
    if (profile != null) {
      _userProfile = profile;
      _name = profile.fullName;
      _age = profile.age;
    }
    notifyListeners();
  }

  void handleNext(BuildContext context) {
    if (_currentStep < 4) {
      nextStep();
      if (pageController.hasClients) {
        pageController.animateToPage(
          _currentStep - 1,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOutCubic,
        );
      }
    } else {
      handleFinish(context);
    }
  }

  void handleBack(BuildContext context) {
    if (_currentStep > 1) {
      previousStep();
      if (pageController.hasClients) {
        pageController.animateToPage(
          _currentStep - 1,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeInOutCubic,
        );
      }
    } else {
      Navigator.of(context).pop();
    }
  }

  void handleSkip(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.skipQuiz();

    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (route) => false,
    );
  }

  void handleFinish(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_name.trim().isNotEmpty) {
      userProvider.setFullName(_name.trim());
    }
    final profile = buildProfile(userName: _name);
    await userProvider.completeQuiz(profile);

    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AnalyzingRoutineLoadingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  void startAnalyzingRoutine(BuildContext context) {
    if (_isAnalyzingRoutineRunning) return;
    _isAnalyzingRoutineRunning = true;
    _analyzingStatusIndex = 0;
    _statusTimer?.cancel();
    _analyzingNavigationTimer?.cancel();

    _statusTimer = Timer.periodic(const Duration(milliseconds: 750), (t) {
      if (_analyzingStatusIndex < analyzingStatusUpdates.length - 1) {
        _analyzingStatusIndex++;
        notifyListeners();
      }
    });

    _analyzingNavigationTimer = Timer(const Duration(seconds: 3), () {
      _isAnalyzingRoutineRunning = false;
      _statusTimer?.cancel();
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 500),
        ),
        (route) => false,
      );
    });
  }

  void resetQuiz() {
    _currentStep = 1;
    _name = '';
    _age = '';
    nameController.clear();
    ageController.clear();
    if (pageController.hasClients) {
      pageController.jumpToPage(0);
    }
    _selectedLifeStage = null;
    _selectedSkinType = null;
    _selectedConcerns.clear();
    _selectedRoutineStyle = null;
    _isQuizCompleted = false;
    _userProfile = null;
    notifyListeners();
  }

  @override
  void dispose() {
    pageController.dispose();
    nameController.dispose();
    ageController.dispose();
    _statusTimer?.cancel();
    _analyzingNavigationTimer?.cancel();
    super.dispose();
  }
}
