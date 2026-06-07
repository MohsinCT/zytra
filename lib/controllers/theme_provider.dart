import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  /// 'light' or 'dark'
  String _mode = 'light';

  String get mode => _mode;

  bool get isDark => _mode == 'dark';

  void setMode(String m) {
    if (m != 'light' && m != 'dark') return;
    _mode = m;
    notifyListeners();
  }

  void toggle() {
    _mode = isDark ? 'light' : 'dark';
    notifyListeners();
  }
}
