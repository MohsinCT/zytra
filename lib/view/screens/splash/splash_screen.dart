import 'package:flutter/material.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/view/screens/auth/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Keep splash visible for 2.5 seconds then navigate to LoginScreen
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 2500)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const LoginScreen();
        }

        final mq = MediaQuery.of(context);
        final width = mq.size.width;
        final scale = (width / 390).clamp(0.75, 1.4);

        final logoSize = (110 * scale).clamp(80.0, 150.0);
        final titleSize = (44 * scale).clamp(28.0, 68.0);
        final subtitleSize = (14 * scale).clamp(10.0, 20.0);
        final spacing = (12 * scale).clamp(8.0, 24.0);

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: _buildSplashContent(
                  logoSize: logoSize,
                  titleSize: titleSize,
                  subtitleSize: subtitleSize,
                  spacing: spacing,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSplashContent({
    required double logoSize,
    required double titleSize,
    required double subtitleSize,
    required double spacing,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Provided App Icon / Logo Image
        Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: kPrimaryPink.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/evermi_logo.png',
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: spacing * 1.5),

        // App Name: evermi (all lowercase, modern sans-serif)
        Text(
          'evermi',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: titleSize,
            fontWeight: FontWeight.w900,
            color: kPrimaryPink,
            letterSpacing: -1.2,
            height: 1.0,
          ),
        ),
        SizedBox(height: spacing),

        // Subtitle
        Text(
          "Everything she needs delivered in Minutes",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: subtitleSize,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF555555),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}
