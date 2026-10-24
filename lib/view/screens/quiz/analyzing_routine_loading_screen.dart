import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/quiz_provider.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class AnalyzingRoutineLoadingScreen extends StatelessWidget {
  const AnalyzingRoutineLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final isDark = context.isDark;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted) {
        context.read<QuizProvider>().startAnalyzingRoutine(context);
      }
    });

    final currentStatusIndex = quiz.analyzingStatusIndex;
    final statusUpdates = QuizProvider.analyzingStatusUpdates;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              // Ambient soft background glow
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: const Alignment(0, -0.15),
                      radius: 0.9,
                      colors: isDark
                          ? [
                              kPrimaryPink.withValues(alpha: 0.15),
                              Colors.transparent,
                            ]
                          : [
                              kPrimaryPinkLight.withValues(alpha: 0.9),
                              Colors.white,
                            ],
                    ),
                  ),
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Radar Pulse Widget
                      SizedBox(
                        width: 170,
                        height: 170,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            LoadingAnimationWidget.discreteCircle(
                              color: kPrimaryPink.withValues(alpha: 0.5),
                              secondRingColor:
                                  const Color(0xFFFF7597).withValues(alpha: 0.4),
                              thirdRingColor:
                                  const Color(0xFFFFB3C6).withValues(alpha: 0.3),
                              size: 160,
                            ),
                            // Central Glowing Core
                            Container(
                              width: 82,
                              height: 82,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFFF2D6F),
                                    Color(0xFFFF528E),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: kPrimaryPink.withValues(alpha: 0.45),
                                    blurRadius: 28,
                                    spreadRadius: 4,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.radar_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 38),

                      // Specified Copy
                      Text(
                        "Curating your custom routine & checking product availability...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          height: 1.35,
                          color: isDark ? Colors.white : kTextDark,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // Animated Cycling Status Ticker
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.0, 0.3),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Container(
                          key: ValueKey<int>(currentStatusIndex),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.08)
                                : kPrimaryPinkLight,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: kPrimaryPink.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      kPrimaryPink),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  statusUpdates[currentStatusIndex],
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: kPrimaryPink,
                                  ),
                                  overflow: TextOverflow.ellipsis,
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

              // Bottom reassurance badge
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bolt,
                        size: 16,
                        color: Color(0xFFFFB300),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Express doorstep delivery",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white60 : Colors.black54,
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
