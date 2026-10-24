import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/auth_provider.dart';
import 'package:zytranow/core/constants/app_constants.dart';

/// "Setting up your personalized beauty space" loading and setup screen
/// Shown both after OTP verification and when tapping "Take the Quiz & Unlock Care Mode".
typedef SettingUpSpaceScreen = PostOtpLoadingScreen;

class PostOtpLoadingScreen extends StatelessWidget {
  const PostOtpLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isDark = context.isDark;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.read<AuthProvider>().startPostOtpCountdown(context);
      }
    });

    final secondsLeft = auth.postOtpCountdown;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<AuthProvider>().cancelPostOtpCountdown();
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              // Subtle glowing radial gradient in the background
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.2),
                      radius: 0.85,
                      colors: isDark
                          ? [
                              kPrimaryPink.withValues(alpha: 0.12),
                              Colors.transparent,
                            ]
                          : [
                              kPrimaryPinkLight.withValues(alpha: 0.8),
                              Colors.white,
                            ],
                    ),
                  ),
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Branded Loader Container
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? const Color(0xFF1E1E1E)
                              : Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryPink.withValues(alpha: 0.22),
                              blurRadius: 36,
                              spreadRadius: 8,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(
                            color: kPrimaryPink.withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: LoadingAnimationWidget.discreteCircle(
                            color: kPrimaryPink,
                            secondRingColor: const Color(0xFFFF7597),
                            thirdRingColor: const Color(0xFFFFB3C6),
                            size: 52,
                          ),
                        ),
                      ),

                      const SizedBox(height: 42),

                      // Primary Copy
                      Text(
                        "Setting up your personalized beauty space...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                          height: 1.35,
                          color: isDark ? Colors.white : kTextDark,
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Sub-copy explaining value proposition
                      Text(
                        "Preparing a 4-step ritual matched to your life stage, skin needs & routine goals.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.45,
                          color: isDark ? Colors.grey[400] : kTextMuted,
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Progress bar / countdown pill (Tap to start immediately)
                      GestureDetector(
                        onTap: () {
                          context.read<AuthProvider>().skipPostOtpCountdown(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : kPrimaryPinkFaint,
                            borderRadius: BorderRadius.circular(kRadiusRound),
                            border: Border.all(
                              color: kPrimaryPink.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                size: 16,
                                color: kPrimaryPink,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Starting in $secondsLeft s",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: kPrimaryPink,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: kPrimaryPink.withValues(alpha: 0.7),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Top right close button to dismiss cleanly if desired
              Positioned(
                top: 8,
                right: 12,
                child: IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    color: isDark ? Colors.white70 : Colors.black45,
                    size: 24,
                  ),
                  tooltip: "Close",
                  onPressed: () {
                    context.read<AuthProvider>().cancelPostOtpCountdown();
                    Navigator.of(context).pop();
                  },
                ),
              ),

              // Bottom brand footer
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "evermi",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.5,
                          color: kPrimaryPink.withValues(alpha: 0.8),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? Colors.white38 : Colors.black26,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Fast Personalization",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
