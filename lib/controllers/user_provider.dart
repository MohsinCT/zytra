import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zytranow/models/quiz_models.dart';

class UserProvider extends ChangeNotifier {
  // Frontend-only user state. Defaults to guest (not logged in).
  bool _isLoggedIn = false;
  String _phoneNumber = '';
  String? fullName;

  // Personalization quiz state
  bool _quizCompleted = false;
  bool _quizSkipped = false;
  UserQuizProfile? _quizProfile;

  UserProvider() {
    loadQuizState();
  }

  bool get isLoggedIn => _isLoggedIn;
  String get phoneNumber => _phoneNumber.isEmpty ? '9876543210' : _phoneNumber;
  bool get quizCompleted => _quizCompleted;
  bool get quizSkipped => _quizSkipped;
  UserQuizProfile? get quizProfile => _quizProfile;
  LifeStage? get lifeStage => _quizProfile?.lifeStage;

  void login(String phone) {
    _isLoggedIn = true;
    _phoneNumber = phone.trim().isEmpty ? '9876543210' : phone.trim();
    loadQuizState();
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _phoneNumber = '';
    fullName = null;
    notifyListeners();
  }

  void setPhoneNumber(String phone) {
    _phoneNumber = phone.trim();
    if (_phoneNumber.isNotEmpty) {
      _isLoggedIn = true;
    }
    notifyListeners();
  }

  void setFullName(String name) {
    fullName = name.trim().isEmpty ? null : name.trim();
    notifyListeners();
  }

  void clearName() {
    fullName = null;
    notifyListeners();
  }

  /// Load persisted quiz status and profile from SharedPreferences
  Future<void> loadQuizState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _quizCompleted = prefs.getBool('quiz_completed') ?? false;
      _quizSkipped = prefs.getBool('quiz_skipped') ?? false;
      final profileJson = prefs.getString('quiz_profile');
      if (profileJson != null && profileJson.isNotEmpty) {
        _quizProfile = UserQuizProfile.fromJson(profileJson);
      }
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading quiz state: $e");
    }
  }

  /// Save quiz completion and user profile
  Future<void> completeQuiz(UserQuizProfile profile) async {
    _quizCompleted = true;
    _quizSkipped = false;
    _quizProfile = profile;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('quiz_completed', true);
      await prefs.setBool('quiz_skipped', false);
      await prefs.setString('quiz_profile', profile.toJson());
      if (profile.lifeStage.name.isNotEmpty) {
        await prefs.setString('quiz_life_stage', profile.lifeStage.name);
      }
    } catch (e) {
      debugPrint("Error saving quiz profile to SharedPreferences: $e");
    }

    // Attempt Firebase / Firestore sync if online
    try {
      final phone = _phoneNumber.isNotEmpty ? _phoneNumber : 'guest';
      await FirebaseFirestore.instance.collection('users').doc(phone).set({
        'quizCompleted': true,
        'quizSkipped': false,
        'quizProfile': profile.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Firestore quiz profile sync note (offline/skipped): $e");
    }
  }

  /// Mark quiz as skipped for fast commerce mode
  Future<void> skipQuiz() async {
    _quizCompleted = false;
    _quizSkipped = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('quiz_completed', false);
      await prefs.setBool('quiz_skipped', true);
    } catch (e) {
      debugPrint("Error saving quiz skip to SharedPreferences: $e");
    }

    try {
      final phone = _phoneNumber.isNotEmpty ? _phoneNumber : 'guest';
      await FirebaseFirestore.instance.collection('users').doc(phone).set({
        'quizCompleted': false,
        'quizSkipped': true,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint("Firestore quiz skip sync note (offline/skipped): $e");
    }
  }
}

