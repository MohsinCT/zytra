import 'package:flutter/material.dart';
import 'package:zytranow/view/auth/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Keep the splash screen visible for 2.5 seconds
      future: Future.delayed(const Duration(milliseconds: 2500)),
      builder: (context, snapshot) {
        // Once the timer finishes, instantly swap to the MainScreen
        if (snapshot.connectionState == ConnectionState.done) {
          return const LoginScreen();
        }

        // The Splash UI
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 46,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.5,
                      height: 1.0,
                    ),
                    children: [
                      TextSpan(
                        text: 'Zytra',
                        style: TextStyle(color: Color(0xFFFF2D6F)),
                      ),
                      TextSpan(
                        text: 'now',
                        style: TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Everything she needs delivered in Minutes",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF555555), // Dark grey
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
