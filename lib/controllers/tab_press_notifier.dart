import 'package:flutter/foundation.dart';

class TabPressNotifier extends ChangeNotifier {
  bool _isPressed = false;
  bool get isPressed => _isPressed;

  void setPressed(bool val) {
    if (_isPressed != val) {
      _isPressed = val;
      notifyListeners();
    }
  }
}
