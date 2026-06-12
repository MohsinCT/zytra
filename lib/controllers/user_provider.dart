import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  // Frontend-only user state. No backend persistence in this task.
  String phoneNumber = '9876543210';
  String? fullName;

  void setPhoneNumber(String phone) {
    phoneNumber = phone.trim().isEmpty ? '9876543210' : phone.trim();
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
}
