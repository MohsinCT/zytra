import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/controllers/quiz_provider.dart';
import 'package:zytranow/controllers/user_provider.dart';
import 'package:zytranow/models/quiz_models.dart';

/// Attractive, High-Conversion 4-Step Personalized Skin & Wellness Quiz Screen
/// Features ambient luxury glowing mesh, 4-segmented progress tracker, tactile
/// interactive option cards, responsive input, and dynamic step guidance.
class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final user = context.watch<UserProvider>();
    quiz.initControllers(defaultName: user.fullName);

    final isDark = context.isDark;
    final canProceed = quiz.canProceedCurrentStep();

    return PopScope(
      canPop: quiz.currentStep == 1,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && quiz.currentStep > 1) {
          quiz.handleBack(context);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F0F12) : Colors.white,
        body: Stack(
          children: [
            // 1. Ambient luxury glowing backdrop
            Positioned(
              top: -100,
              left: -60,
              right: -60,
              height: 380,
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.4),
                    radius: 0.85,
                    colors: isDark
                        ? [
                            kPrimaryPink.withValues(alpha: 0.16),
                            const Color(0xFF0F0F12).withValues(alpha: 0.0),
                          ]
                        : [
                            const Color(0xFFFFEBF2),
                            const Color(0xFFFFF7FA),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                  ),
                ),
              ),
            ),

            // 2. Main Scaffold Content
            SafeArea(
              child: Column(
                children: [
                  // Custom Elevated Navigation & Segmented Header
                  _buildTopBar(context, quiz, isDark),

                  // 4-Segmented Animated Progress Indicator
                  _buildSegmentedProgress(quiz.currentStep, isDark),

                  // Page View with the 4 steps
                  Expanded(
                    child: PageView(
                      controller: quiz.pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildStep1(context, quiz, isDark),
                        _buildStep2(context, quiz, isDark),
                        _buildStep3(context, quiz, isDark),
                        _buildStep4(context, quiz, isDark),
                      ],
                    ),
                  ),

                  // Bottom Action Bar & Dynamic CTA Button
                  _buildBottomAction(context, quiz, canProceed, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Top Bar & Segmented Progress ──────────────────────────────────────────

  Widget _buildTopBar(BuildContext context, QuizProvider quiz, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => quiz.handleBack(context),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : const Color(0xFFEAEAEE),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 16,
                  color: isDark ? Colors.white : kTextDark,
                ),
              ),
            ),
          ),

          // Center Branding & Step Counter
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: kPrimaryPink,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    "CARE MODE QUIZ",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: kPrimaryPink,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                "Step ${quiz.currentStep} of 4",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : kTextDark,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),

          // Skip button on Step 1, or spacer for alignment
          if (quiz.currentStep == 1)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => quiz.handleSkip(context),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? kPrimaryPink.withValues(alpha: 0.15)
                        : const Color(0xFFFFF0F5),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: kPrimaryPink.withValues(alpha: 0.3),
                      width: 1.2,
                    ),
                  ),
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: kPrimaryPink,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            )
          else
            const SizedBox(width: 36),
        ],
      ),
    );
  }

  Widget _buildSegmentedProgress(int currentStep, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        children: List.generate(4, (index) {
          final stepNum = index + 1;
          final isActive = stepNum <= currentStep;
          final isCurrent = stepNum == currentStep;

          return Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOutCubic,
              margin: EdgeInsets.only(
                left: index == 0 ? 0 : 3.5,
                right: index == 3 ? 0 : 3.5,
              ),
              height: isCurrent ? 5.5 : 4.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: isActive
                    ? const LinearGradient(
                        colors: [
                          Color(0xFFFF2D6F),
                          Color(0xFFFF528E),
                        ],
                      )
                    : null,
                color: isActive
                    ? null
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : const Color(0xFFECECF2)),
                boxShadow: isCurrent
                    ? [
                        BoxShadow(
                          color: kPrimaryPink.withValues(alpha: 0.4),
                          blurRadius: 6,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }

  // ─── STEP 1: Let's get to know you (Name & Life Stage) ─────────────────────

  Widget _buildStep1(BuildContext context, QuizProvider quiz, bool isDark) {
    final options = quiz.lifeStageOptions;
    final hasName = quiz.name.trim().isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroHeader(
            badge: "✨ YOUR BASICS",
            title: "Let's get to know you",
            subtitle:
                "Tell us your name & life phase so evermi curates the right formulations & personalized routine for you.",
            isDark: isDark,
          ),
          const SizedBox(height: 22),

          // Name Input Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF18181C) : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: hasName
                    ? kPrimaryPink.withValues(alpha: 0.45)
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : const Color(0xFFE8E8EE)),
                width: hasName ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: hasName
                      ? kPrimaryPink.withValues(alpha: 0.08)
                      : Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "WHAT SHOULD WE CALL YOU?",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: hasName
                            ? kPrimaryPink
                            : (isDark ? Colors.white70 : kTextMuted),
                      ),
                    ),
                    if (hasName)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check, size: 10, color: Colors.green),
                            SizedBox(width: 3),
                            Text(
                              "Ready",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: quiz.nameController,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (val) => quiz.setName(val),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : kTextDark,
                  ),
                  decoration: InputDecoration(
                    hintText: "Enter your first name (e.g., Riya)",
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      color: isDark ? Colors.grey[500] : kTextMuted,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: hasName
                            ? kPrimaryPink.withValues(alpha: 0.15)
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.06)
                                : const Color(0xFFF2F2F6)),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        size: 20,
                        color: hasName ? kPrimaryPink : Colors.grey,
                      ),
                    ),
                    prefixIconConstraints:
                        const BoxConstraints(minWidth: 36, minHeight: 36),
                    filled: false,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          // Life Stage Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "SELECT YOUR LIFE PHASE",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                  color: isDark ? Colors.white70 : kTextMuted,
                ),
              ),
              Text(
                "Tailors formulations",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryPink.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ...options.map((opt) {
            final stage = LifeStageExtension.fromString(opt.id);
            final isSelected = quiz.selectedLifeStage == stage;
            return _OptionCardTile(
              title: opt.title,
              subtitle: opt.subtitle,
              emoji: opt.emoji,
              badge: opt.badge,
              isSelected: isSelected,
              isDark: isDark,
              onTap: () => quiz.selectLifeStage(stage),
            );
          }),
        ],
      ),
    );
  }

  // ─── STEP 2: Skin & Body Profile ──────────────────────────────────────────

  Widget _buildStep2(BuildContext context, QuizProvider quiz, bool isDark) {
    final options = quiz.skinTypeOptions;
    final stageName = quiz.selectedLifeStage?.displayName ?? "You";

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroHeader(
            badge: "🫧 SKIN DIAGNOSTICS",
            title: "Your Skin & Body Profile",
            subtitle:
                "Options calibrated specifically for $stageName. Which description matches your daily skin feel?",
            isDark: isDark,
          ),
          const SizedBox(height: 20),
          ...options.map((opt) {
            final isSelected = quiz.selectedSkinType == opt.title;
            return _OptionCardTile(
              title: opt.title,
              subtitle: opt.subtitle,
              emoji: opt.emoji,
              badge: opt.badge,
              isSelected: isSelected,
              isDark: isDark,
              onTap: () => quiz.selectSkinType(opt.title),
            );
          }),
        ],
      ),
    );
  }

  // ─── STEP 3: Top Priorities & Needs ───────────────────────────────────────

  Widget _buildStep3(BuildContext context, QuizProvider quiz, bool isDark) {
    final options = quiz.concernOptions;
    final selectedCount = quiz.selectedConcerns.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroHeader(
            badge: "🎯 CARE FOCUS AREAS",
            title: "What are your top priorities?",
            subtitle:
                "Choose up to 3 target concerns to focus your customized regimen on. Tap to toggle.",
            isDark: isDark,
          ),
          const SizedBox(height: 16),

          // Interactive Selection Tracker Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : const Color(0xFFFFF0F5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: kPrimaryPink.withValues(alpha: 0.25),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: kPrimaryPink,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      selectedCount == 0
                          ? "Select 1 to 3 priorities"
                          : (selectedCount == 3
                              ? "Maximum 3 selected"
                              : "$selectedCount of 3 selected"),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: kPrimaryPink,
                      ),
                    ),
                  ],
                ),
                // 3 Gamified Indicator Dots
                Row(
                  children: List.generate(3, (dotIndex) {
                    final isFilled = dotIndex < selectedCount;
                    return Container(
                      margin: const EdgeInsets.only(left: 5),
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: isFilled
                            ? kPrimaryPink
                            : (isDark
                                ? Colors.white.withValues(alpha: 0.2)
                                : const Color(0xFFD4D4DE)),
                        shape: BoxShape.circle,
                        boxShadow: isFilled
                            ? [
                                BoxShadow(
                                  color: kPrimaryPink.withValues(alpha: 0.4),
                                  blurRadius: 4,
                                ),
                              ]
                            : null,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          ...options.map((opt) {
            final isSelected = quiz.selectedConcerns.contains(opt.title);
            return _OptionCardTile(
              title: opt.title,
              subtitle: opt.subtitle,
              emoji: opt.emoji,
              badge: opt.badge,
              isSelected: isSelected,
              isMultiSelect: true,
              isDark: isDark,
              onTap: () => quiz.toggleConcern(opt.title),
            );
          }),
        ],
      ),
    );
  }

  // ─── STEP 4: One last thing! Routine Style ────────────────────────────────

  Widget _buildStep4(BuildContext context, QuizProvider quiz, bool isDark) {
    final options = quiz.routineStyleOptions;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeroHeader(
            badge: "⚡ RITUAL PACE & DELIVERY",
            title: "How much time do you have?",
            subtitle:
                "Select how elaborate you prefer your daily care ritual to be. We adapt each match to your schedule.",
            isDark: isDark,
          ),
          const SizedBox(height: 18),

          // Hyperlocal Reassurance Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        kPrimaryPink.withValues(alpha: 0.20),
                        const Color(0xFF1E1E24),
                      ]
                    : [
                        const Color(0xFFFFF0F5),
                        Colors.white,
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: kPrimaryPink.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryPink.withValues(alpha: 0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF2D6F),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bolt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Direct Doorstep Delivery",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.2,
                          color: isDark ? Colors.white : kTextDark,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Every matched product is confirmed in real-time and packed fresh for you.",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          height: 1.35,
                          color: isDark ? Colors.grey[400] : kTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 22),

          ...options.map((opt) {
            final isSelected = quiz.selectedRoutineStyle == opt.title;
            return _OptionCardTile(
              title: opt.title,
              subtitle: opt.subtitle,
              emoji: opt.emoji,
              badge: opt.badge,
              isSelected: isSelected,
              isDark: isDark,
              onTap: () => quiz.selectRoutineStyle(opt.title),
            );
          }),
        ],
      ),
    );
  }

  // ─── Header Component ─────────────────────────────────────────────────────

  Widget _buildHeroHeader({
    required String badge,
    required String title,
    required String subtitle,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: isDark
                ? kPrimaryPink.withValues(alpha: 0.15)
                : const Color(0xFFFFF0F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: kPrimaryPink.withValues(alpha: 0.25),
            ),
          ),
          child: Text(
            badge,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
              color: kPrimaryPink,
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Main Title
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 23,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.6,
            height: 1.25,
            color: isDark ? Colors.white : kTextDark,
          ),
        ),
        const SizedBox(height: 8),

        // Explanatory Subtitle
        Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            height: 1.45,
            color: isDark ? Colors.grey[400] : kTextMuted,
          ),
        ),
      ],
    );
  }

  // ─── Bottom Floating Action Bar ───────────────────────────────────────────

  Widget _buildBottomAction(
    BuildContext context,
    QuizProvider quiz,
    bool canProceed,
    bool isDark,
  ) {
    final isStep4 = quiz.currentStep == 4;

    String buttonText = "Continue";
    if (isStep4) {
      buttonText = "Unlock My Care Mode Routine";
    }

    // Contextual guidance hint if not enabled
    String? hintText;
    if (!canProceed) {
      if (quiz.currentStep == 1) {
        hintText = quiz.name.trim().isEmpty
            ? "Enter your name to continue"
            : "Select a life phase to proceed";
      } else if (quiz.currentStep == 2) {
        hintText = "Select your skin profile above";
      } else if (quiz.currentStep == 3) {
        hintText = "Select at least 1 focus area";
      } else if (quiz.currentStep == 4) {
        hintText = "Choose your routine preference";
      }
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF141418) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFEEEEF2),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Step Guidance Hint
          if (hintText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 13,
                    color: isDark ? Colors.white54 : kTextMuted,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    hintText,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white60 : kTextMuted,
                    ),
                  ),
                ],
              ),
            ),

          // Main CTA Button with Glow & Gradient
          SizedBox(
            width: double.infinity,
            height: 52,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                gradient: canProceed
                    ? const LinearGradient(
                        colors: [
                          Color(0xFFFF2D6F),
                          Color(0xFFFF528E),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: canProceed
                    ? null
                    : (isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : const Color(0xFFF2F2F6)),
                borderRadius: BorderRadius.circular(16),
                boxShadow: canProceed
                    ? [
                        BoxShadow(
                          color: kPrimaryPink.withValues(alpha: 0.38),
                          blurRadius: 16,
                          offset: const Offset(0, 5),
                        ),
                      ]
                    : null,
              ),
              child: ElevatedButton(
                onPressed: canProceed ? () => quiz.handleNext(context) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  disabledBackgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      buttonText,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                        color: canProceed
                            ? Colors.white
                            : (isDark ? Colors.white30 : Colors.black26),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      isStep4
                          ? Icons.auto_awesome
                          : Icons.arrow_forward_rounded,
                      size: 18,
                      color: canProceed
                          ? Colors.white
                          : (isDark ? Colors.white30 : Colors.black26),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Reusable Animated Option Card Tile ─────────────────────────────────────

class _OptionCardTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final String emoji;
  final String? badge;
  final bool isSelected;
  final bool isMultiSelect;
  final bool isDark;
  final VoidCallback onTap;

  const _OptionCardTile({
    required this.title,
    required this.subtitle,
    required this.emoji,
    this.badge,
    required this.isSelected,
    this.isMultiSelect = false,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_OptionCardTile> createState() => _OptionCardTileState();
}

class _OptionCardTileState extends State<_OptionCardTile> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final isDark = widget.isDark;

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark
                    ? const Color(0xFF26151D)
                    : const Color(0xFFFFF6F9))
                : (isDark ? const Color(0xFF18181C) : Colors.white),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? kPrimaryPink
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFFE8E8EE)),
              width: isSelected ? 1.8 : 1.0,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: kPrimaryPink.withValues(alpha: 0.16),
                      blurRadius: 14,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                // Stylized Emoji Avatar Box
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark
                            ? kPrimaryPink.withValues(alpha: 0.22)
                            : const Color(0xFFFFE8F0))
                        : (isDark
                            ? Colors.white.withValues(alpha: 0.06)
                            : const Color(0xFFF4F4F8)),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? kPrimaryPink.withValues(alpha: 0.3)
                          : Colors.transparent,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.emoji,
                      style: const TextStyle(fontSize: 23),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Title, Subtitle, & Badge
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                                color: isSelected
                                    ? kPrimaryPink
                                    : (isDark ? Colors.white : kTextDark),
                              ),
                            ),
                          ),
                          if (widget.badge != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? kPrimaryPink
                                    : (isDark
                                        ? Colors.white.withValues(alpha: 0.1)
                                        : const Color(0xFFEEEEF4)),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                widget.badge!,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                          ? Colors.grey[300]
                                          : const Color(0xFF555566)),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.subtitle,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          height: 1.35,
                          color: isDark ? Colors.grey[400] : kTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Indicator Badge (Checkmark for Multi, Radio for Single)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: widget.isMultiSelect
                        ? BoxShape.rectangle
                        : BoxShape.circle,
                    borderRadius: widget.isMultiSelect
                        ? BorderRadius.circular(7)
                        : null,
                    color: isSelected ? kPrimaryPink : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? kPrimaryPink
                          : (isDark ? Colors.white30 : Colors.grey.shade400),
                      width: 1.8,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: kPrimaryPink.withValues(alpha: 0.35),
                              blurRadius: 6,
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 15,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
