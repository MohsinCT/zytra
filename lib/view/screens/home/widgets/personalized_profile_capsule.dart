import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/models/quiz_models.dart';
import 'package:zytranow/controllers/quiz_provider.dart';
import 'package:zytranow/controllers/user_provider.dart';

class PersonalizedProfileCapsule extends StatelessWidget {
  final UserProfile profile;

  const PersonalizedProfileCapsule({
    super.key,
    required this.profile,
  });

  void _openEditConcernsBottomSheet(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    quizProvider.initDraftConcerns(profile.concerns);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return _EditConcernsBottomSheet(
          lifeStage: profile.lifeStage,
          onSave: (newConcerns) {
            quizProvider.updateConcerns(newConcerns);
            final updatedProfile = profile.copyWith(concerns: newConcerns);
            quizProvider.setUserProfile(updatedProfile);

            if (userProvider.quizProfile != null) {
              final updatedQuizProfile = UserQuizProfile(
                lifeStage: profile.lifeStage,
                skinType: profile.skinType,
                concerns: newConcerns,
                routineStyle: userProvider.quizProfile!.routineStyle,
                deliveryUrgency: userProvider.quizProfile!.deliveryUrgency,
              );
              userProvider.completeQuiz(updatedQuizProfile);
            }

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text("Skin concerns updated! Refreshing feed..."),
                  ],
                ),
                backgroundColor: kPrimaryPink,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF24151C) // subtle dark pink hue
            : const Color(0xFFFFF0F5), // Light pink fill #FFF0F5
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: kPrimaryPink.withValues(alpha: isDark ? 0.35 : 0.25),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          // Sparkle / Spark icon
          const Icon(
            Icons.auto_awesome,
            size: 16,
            color: Color(0xFFFF2D6F),
          ),
          const SizedBox(width: 8),

          // RichText: Curated for {fullName} • {skinType.capitalize} Skin
          Expanded(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: 'Inter',
                  color: isDark ? Colors.white70 : const Color(0xFF333344),
                ),
                children: [
                  const TextSpan(text: "Curated for "),
                  TextSpan(
                    text: profile.fullName.isNotEmpty ? profile.fullName : "You",
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFF2D6F),
                    ),
                  ),
                  TextSpan(
                    text: " • ${profile.skinTypeCapitalized} Skin",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Clickable pencil/edit icon
          InkWell(
            onTap: () => _openEditConcernsBottomSheet(context),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.edit_outlined,
                size: 16,
                color: isDark ? Colors.white70 : const Color(0xFFFF2D6F),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditConcernsBottomSheet extends StatelessWidget {
  final LifeStage lifeStage;
  final ValueChanged<List<String>> onSave;

  const _EditConcernsBottomSheet({
    required this.lifeStage,
    required this.onSave,
  });

  static const List<String> _commonConcerns = [
    'Blemish & Acne Defense',
    'Dark Circles & Fatigue',
    'Oil & Shine Control',
    'Barrier Repair & Hydration',
    'Anti-Pollution & Blue Light',
    'Bridal Radiance & Glow',
    'Nursing Safe & Clean Formula',
    'Postpartum Stretch Marks',
    'Quick 5-Min Routine',
  ];

  @override
  Widget build(BuildContext context) {
    final quiz = context.watch<QuizProvider>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedConcerns = quiz.draftConcerns;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Edit Skin Concerns",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.white : kTextDark,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Text(
            "Select up to 3 target concerns to customize your products & routine bundles.",
            style: TextStyle(
              fontSize: 13,
              color: isDark ? Colors.grey[400] : kTextMuted,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 10,
            children: _commonConcerns.map((concern) {
              final isSelected = selectedConcerns.contains(concern);
              return FilterChip(
                label: Text(concern),
                selected: isSelected,
                selectedColor: kPrimaryPinkLight,
                backgroundColor: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : const Color(0xFFF4F4F8),
                checkmarkColor: kPrimaryPink,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? kPrimaryPink
                      : (isDark ? Colors.grey[300] : const Color(0xFF444455)),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? kPrimaryPink
                        : (isDark ? Colors.white12 : Colors.grey.shade300),
                  ),
                ),
                onSelected: (_) => quiz.toggleDraftConcern(concern),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                onSave(selectedConcerns.toList());
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryPink,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Save & Update Routine",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

