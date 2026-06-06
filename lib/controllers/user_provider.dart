import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  // Mock phone number (frontend-only) - no persistence.
  String phoneNumber = '7994058834';
  String? fullName;

  void setFullName(String name) {
    fullName = name.trim().isEmpty ? null : name.trim();
    notifyListeners();
  }

  void clearName() {
    fullName = null;
    notifyListeners();
  }
}
