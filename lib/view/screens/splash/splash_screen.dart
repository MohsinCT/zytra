import 'package:flutter/material.dart';
import 'package:zytranow/view/screens/auth/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Keep the splash screen visible for 2.5 seconds then navigate to LoginScreen
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 2500)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const LoginScreen();
        }

        // Responsive sizing based on screen width
        final mq = MediaQuery.of(context);
        final width = mq.size.width;
        // Base width 390 (approx iPhone 12) to compute scale
        final scale = (width / 390).clamp(0.75, 1.4);

        // Derived sizes
        final titleSize = (46 * scale).clamp(28.0, 72.0);
        final subtitleSize = (14 * scale).clamp(10.0, 20.0);
        final spacing = (10 * scale).clamp(8.0, 24.0);

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: _buildSplashContent(titleSize, subtitleSize, spacing),
            ),
          ),
        );
      },
    );
  }

  // Extracted builder for clarity and structure
  Widget _buildSplashContent(double titleSize, double subtitleSize, double spacing) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: titleSize,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.5,
              height: 1.0,
            ),
            children: const [
              TextSpan(
                text: 'Zytra',
                style: TextStyle(color: Color(0xFFFF2D6F)),
              ),
            ],
          ),
        ),
        SizedBox(height: spacing),
        Text(
          "Everything she needs delivered in Minutes",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: subtitleSize,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF555555), // Dark grey
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}
