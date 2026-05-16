import 'package:flutter/material.dart';
import 'dart:async';
import 'package:zytranow/view/auth/otp_screen.dart';
import 'package:zytranow/view/main_screen.dart';

class AuthProvider extends ChangeNotifier {
  String? phoneNumber;
  int timerCount = 15;
  Timer? _timer;
  bool isVerifying = false;

  final TextEditingController phoneController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(4, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());

  void validatePhone(BuildContext context) {
    String phone = phoneController.text.trim();
    if (phone.length == 10 && RegExp(r'^[0-9]+$').hasMatch(phone)) {
      phoneNumber = phone;
      // Clear OTP fields before entering
      for (var c in otpControllers) {
        c.clear();
      }
      notifyListeners();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const OtpScreen()),
      );
      startTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter a valid 10-digit mobile number"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void startTimer() {
    timerCount = 15;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerCount > 0) {
        timerCount--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
    notifyListeners();
  }

  void onOtpChanged(String value, int index, BuildContext context) {
    if (value.isNotEmpty) {
      if (index < 3) {
        otpFocusNodes[index + 1].requestFocus();
      } else {
        otpFocusNodes[index].unfocus();
        String fullOtp = otpControllers.map((c) => c.text).join();
        verifyOtp(fullOtp, context);
      }
    } else if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
  }

  void verifyOtp(String otp, BuildContext context) async {
    if (otp == "1111") {
      isVerifying = true;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 5));

      if (!context.mounted) return;
      
      isVerifying = false;
      notifyListeners();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid OTP"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    phoneController.dispose();
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }
}
