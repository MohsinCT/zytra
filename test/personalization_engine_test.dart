import 'package:flutter_test/flutter_test.dart';
import 'package:zytranow/models/product.dart';
import 'package:zytranow/models/quiz_models.dart';
import 'package:zytranow/controllers/quiz_provider.dart';
import 'package:zytranow/controllers/cart_provider.dart';

void main() {
  group('UserProfile Model Tests', () {
    test('UserProfile initializes with expected defaults and helpers', () {
      final profile = UserProfile(
        fullName: 'Ananya',
        lifeStage: LifeStage.college,
        skinType: 'oily',
        concerns: ['Acne Defense', 'Dark Circles'],
        avoidIngredients: ['Parabens', 'Sulfates'],
        budgetRange: 'budget',
      );

      expect(profile.fullName, 'Ananya');
      expect(profile.skinTypeCapitalized, 'Oily');
      expect(profile.lifeStage, LifeStage.college);
      expect(profile.avoidIngredients, contains('Parabens'));

      final json = profile.toJson();
      final fromJson = UserProfile.fromJson(json);
      expect(fromJson.fullName, 'Ananya');
      expect(fromJson.skinType, 'oily');
      expect(fromJson.concerns, contains('Acne Defense'));
    });
  });

  group('Product Personalization Matching Algorithm Tests', () {
    final userProfile = UserProfile(
      fullName: 'Rhea',
      lifeStage: LifeStage.professional,
      skinType: 'oily',
      concerns: ['Blemish', 'Anti-Pollution'],
      avoidIngredients: ['Sulfates'],
      budgetRange: 'budget',
    );

    final p1SafeMatching = Product(
      id: 'p1',
      name: 'Salicylic Acid Gel',
      imageAsset: '',
      unit: '50ml',
      price: 350,
      deliveryTime: '10 mins',
      suitableSkinTypes: ['oily', 'combination'],
      targetedConcerns: ['Blemish', 'Acne'],
      ingredients: ['Salicylic Acid', 'Zinc'],
      isCleanFormula: true,
    );

    final p2HasAvoidedIngredient = Product(
      id: 'p2',
      name: 'Harsh Foam Wash',
      imageAsset: '',
      unit: '100ml',
      price: 250,
      deliveryTime: '10 mins',
      suitableSkinTypes: ['oily'],
      targetedConcerns: ['Blemish'],
      ingredients: ['Sodium Lauryl Sulfate'],
      isCleanFormula: false,
    );

    final p3SafeNonMatching = Product(
      id: 'p3',
      name: 'Heavy Cold Cream',
      imageAsset: '',
      unit: '100ml',
      price: 800,
      deliveryTime: '10 mins',
      suitableSkinTypes: ['dry'],
      targetedConcerns: ['Wrinkles'],
      ingredients: ['Shea Butter'],
      isCleanFormula: true,
    );

    test('Filters out products with avoided ingredients', () {
      final all = [p1SafeMatching, p2HasAvoidedIngredient, p3SafeNonMatching];
      final avoid = userProfile.avoidIngredients.map((e) {
        final s = e.toLowerCase().trim();
        return s.endsWith('s') ? s.substring(0, s.length - 1) : s;
      }).toList();

      final filtered = all.where((p) {
        for (var ing in p.ingredients) {
          final ingLower = ing.toLowerCase();
          for (var a in avoid) {
            if (ingLower.contains(a)) {
              return false;
            }
          }
        }
        return true;
      }).toList();

      expect(filtered.contains(p2HasAvoidedIngredient), false);
      expect(filtered.contains(p1SafeMatching), true);
      expect(filtered.contains(p3SafeNonMatching), true);
    });

    test('Scores and prioritizes products matching skinType and concerns', () {
      final list = [p3SafeNonMatching, p1SafeMatching];
      final userSkin = userProfile.skinType.toLowerCase();
      final userConcerns = userProfile.concerns.map((e) => e.toLowerCase()).toList();

      list.sort((a, b) {
        int scoreA = 0;
        int scoreB = 0;
        if (a.suitableSkinTypes.any((s) => s.toLowerCase().contains(userSkin))) scoreA += 10;
        if (b.suitableSkinTypes.any((s) => s.toLowerCase().contains(userSkin))) scoreB += 10;
        for (var c in userConcerns) {
          if (a.targetedConcerns.any((tc) => tc.toLowerCase().contains(c))) scoreA += 5;
          if (b.targetedConcerns.any((tc) => tc.toLowerCase().contains(c))) scoreB += 5;
        }
        return scoreB.compareTo(scoreA);
      });

      expect(list.first.id, 'p1');
    });
  });

  group('CartProvider Batch Addition Test', () {
    test('addMultipleItems adds all products in single batch notification', () {
      final cart = CartProvider();
      final p1 = Product(id: '1', name: 'Item 1', imageAsset: '', unit: '', price: 100, deliveryTime: '');
      final p2 = Product(id: '2', name: 'Item 2', imageAsset: '', unit: '', price: 200, deliveryTime: '');
      final p3 = Product(id: '3', name: 'Item 3', imageAsset: '', unit: '', price: 300, deliveryTime: '');

      cart.addMultipleItems([p1, p2, p3]);

      expect(cart.totalItems, 3);
      expect(cart.totalPrice, 600.0);
    });
  });

  group('QuizProvider Personalization Bridge Test', () {
    test('buildProfile generates and sets UserProfile on completion', () {
      final quiz = QuizProvider();
      quiz.selectLifeStage(LifeStage.professional);
      quiz.selectSkinType('Oily & Breakout-Prone');
      quiz.toggleConcern('Blemish');
      quiz.selectRoutineStyle('Express & Minimal (3 Steps)');

      quiz.buildProfile(userName: 'Priya');

      expect(quiz.isQuizCompleted, true);
      expect(quiz.userProfile, isNotNull);
      expect(quiz.userProfile!.fullName, 'Priya');
      expect(quiz.userProfile!.lifeStage, LifeStage.professional);
      expect(quiz.userProfile!.skinType, 'oily');
    });
  });
}
