import 'package:flutter_test/flutter_test.dart';
import 'package:zytranow/controllers/quiz_provider.dart';
import 'package:zytranow/models/quiz_models.dart';

void main() {
  group('LifeStage Enum & Extension Tests', () {
    test('All 5 LifeStage values are defined with expected metadata', () {
      expect(LifeStage.values.length, 5);
      expect(LifeStage.values, contains(LifeStage.teen));
      expect(LifeStage.values, contains(LifeStage.college));
      expect(LifeStage.values, contains(LifeStage.professional));
      expect(LifeStage.values, contains(LifeStage.newlywed));
      expect(LifeStage.values, contains(LifeStage.newMom));

      expect(LifeStage.teen.displayName, "Teen & Gen-Z");
      expect(LifeStage.college.displayName, "College Life");
      expect(LifeStage.professional.displayName, "Working Professional");
      expect(LifeStage.newlywed.displayName, "Newlywed & Trousseau");
      expect(LifeStage.newMom.displayName, "New Mom & Maternity");

      expect(LifeStage.teen.emoji, "✨");
      expect(LifeStage.newMom.emoji, "🍼");
    });

    test('LifeStage parsing from string', () {
      expect(LifeStageExtension.fromString('teen'), LifeStage.teen);
      expect(LifeStageExtension.fromString('newMom'), LifeStage.newMom);
      expect(LifeStageExtension.fromString('UNKNOWN'), LifeStage.professional);
    });
  });

  group('UserQuizProfile Serialization', () {
    test('Can serialize to JSON and restore from JSON', () {
      final profile = UserQuizProfile(
        lifeStage: LifeStage.professional,
        skinType: 'Screen-Fatigued & Dull',
        concerns: ['Meeting-Ready Instant Radiance', 'Anti-Pollution & Blue Light Screen'],
        routineStyle: 'Balanced Glow (4-5 steps)',
        deliveryUrgency: 'Express Delivery',
      );

      final jsonString = profile.toJson();
      final restored = UserQuizProfile.fromJson(jsonString);

      expect(restored.lifeStage, LifeStage.professional);
      expect(restored.skinType, 'Screen-Fatigued & Dull');
      expect(restored.concerns.length, 2);
      expect(restored.routineStyle, 'Balanced Glow (4-5 steps)');
      expect(restored.deliveryUrgency, 'Express Delivery');
    });
  });

  group('QuizProvider Dynamic Logic & Progression', () {
    late QuizProvider provider;

    setUp(() {
      provider = QuizProvider();
    });

    test('Initial step is 1 and cannot proceed without selection', () {
      expect(provider.currentStep, 1);
      expect(provider.canProceedCurrentStep(), false);

      provider.selectLifeStage(LifeStage.college);
      // Name is also required on Step 1 (age is removed as life phase specifies stage)
      expect(provider.canProceedCurrentStep(), false);

      provider.setName('Riya');
      expect(provider.canProceedCurrentStep(), true);
    });

    test('Step 2 options change dynamically based on LifeStage', () {
      provider.selectLifeStage(LifeStage.teen);
      final teenSkinOptions = provider.skinTypeOptions;
      expect(teenSkinOptions.any((o) => o.id == 'oily_acne'), true);

      provider.selectLifeStage(LifeStage.newMom);
      final momSkinOptions = provider.skinTypeOptions;
      expect(momSkinOptions.any((o) => o.id == 'postpartum_dry'), true);
      expect(momSkinOptions.any((o) => o.id == 'oily_acne'), false);
    });

    test('Step 3 allows selecting up to 3 concerns and toggling off', () {
      provider.selectLifeStage(LifeStage.professional);
      provider.setStep(3);

      expect(provider.canProceedCurrentStep(), false);

      provider.toggleConcern('Instant Radiance');
      expect(provider.selectedConcerns.length, 1);
      expect(provider.canProceedCurrentStep(), true);

      provider.toggleConcern('Blue Light');
      provider.toggleConcern('Hair Fall');
      expect(provider.selectedConcerns.length, 3);

      // Attempt 4th concern (should not exceed 3)
      provider.toggleConcern('Extra Concern');
      expect(provider.selectedConcerns.length, 3);

      // Toggle off
      provider.toggleConcern('Instant Radiance');
      expect(provider.selectedConcerns.length, 2);
    });

    test('Step 4 requires routine style and builds valid profile', () {
      provider.selectLifeStage(LifeStage.newlywed);
      provider.selectSkinType('Bridal Radiance');
      provider.toggleConcern('Glass Skin Routine');
      provider.setStep(4);

      expect(provider.canProceedCurrentStep(), false);

      provider.selectRoutineStyle('Full Glass-Skin Ritual');
      expect(provider.canProceedCurrentStep(), true);

      final profile = provider.buildProfile();
      expect(profile.lifeStage, LifeStage.newlywed);
      expect(profile.skinType, 'Bridal Radiance');
      expect(profile.concerns, contains('Glass Skin Routine'));
      expect(profile.routineStyle, 'Full Glass-Skin Ritual');
    });

    test('Reset clears all answers and returns to step 1', () {
      provider.selectLifeStage(LifeStage.teen);
      provider.selectSkinType('Oily');
      provider.setStep(2);

      provider.resetQuiz();
      expect(provider.currentStep, 1);
      expect(provider.selectedLifeStage, isNull);
      expect(provider.selectedSkinType, isNull);
      expect(provider.selectedConcerns, isEmpty);
    });
  });
}
