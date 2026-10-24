import 'package:flutter/material.dart';
import 'dart:async';
import 'package:zytranow/view/screens/auth/otp_screen.dart';
import 'package:zytranow/view/screens/auth/post_otp_loading_screen.dart';
import 'package:zytranow/view/screens/quiz/quiz_screen.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/user_provider.dart';

class AuthProvider extends ChangeNotifier {
  String? phoneNumber;
  int timerCount = 15;
  Timer? _timer;
  bool isVerifying = false;

  int postOtpCountdown = 5;
  Timer? _postOtpTimer;
  bool _isPostOtpRunning = false;

  final TextEditingController phoneController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> otpFocusNodes = List.generate(4, (_) => FocusNode());

  void validatePhone(BuildContext context, {VoidCallback? onSuccess}) {
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
        MaterialPageRoute(
          builder: (_) => OtpScreen(onSuccess: onSuccess),
        ),
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

  void onOtpChanged(
    String value,
    int index,
    BuildContext context, {
    VoidCallback? onSuccess,
  }) {
    if (value.isNotEmpty) {
      if (index < 3) {
        otpFocusNodes[index + 1].requestFocus();
      } else {
        otpFocusNodes[index].unfocus();
        String fullOtp = otpControllers.map((c) => c.text).join();
        verifyOtp(fullOtp, context, onSuccess: onSuccess);
      }
    } else if (value.isEmpty && index > 0) {
      otpFocusNodes[index - 1].requestFocus();
    }
  }

  void verifyOtp(
    String otp,
    BuildContext context, {
    VoidCallback? onSuccess,
  }) async {
    if (otp == "1111") {
      isVerifying = true;
      notifyListeners();

      await Future.delayed(const Duration(seconds: 2));

      if (!context.mounted) return;

      isVerifying = false;
      notifyListeners();

      // Persist phone into UserProvider as logged in
      try {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.login(phoneNumber ?? '');
      } catch (_) {}

      if (onSuccess != null) {
        onSuccess();
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const PostOtpLoadingScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid OTP (Use 1111)"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void startPostOtpCountdown(BuildContext context, {int initialSeconds = 3}) {
    if (_isPostOtpRunning) return;
    _postOtpTimer?.cancel();
    _isPostOtpRunning = true;
    postOtpCountdown = initialSeconds;
    notifyListeners();
    _postOtpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (postOtpCountdown <= 1) {
        timer.cancel();
        _isPostOtpRunning = false;
        if (!context.mounted) return;
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const QuizScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      } else {
        postOtpCountdown--;
        notifyListeners();
      }
    });
  }

  void cancelPostOtpCountdown() {
    _postOtpTimer?.cancel();
    _isPostOtpRunning = false;
  }

  void skipPostOtpCountdown(BuildContext context) {
    _postOtpTimer?.cancel();
    _isPostOtpRunning = false;
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const QuizScreen(),
        transitionsBuilder:
            (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _postOtpTimer?.cancel();
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
