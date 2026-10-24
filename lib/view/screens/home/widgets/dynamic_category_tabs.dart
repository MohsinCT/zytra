import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/home_provider.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/models/quiz_models.dart';

class DynamicCategoryTabs extends StatelessWidget implements PreferredSizeWidget {
  final bool isPersonalized;
  final UserProfile? profile;

  const DynamicCategoryTabs({
    super.key,
    required this.isPersonalized,
    this.profile,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  List<String> _resolveTabs() {
    if (!isPersonalized || profile == null) {
      return const [
        'All',
        'Trending',
        'Best Sellers',
        'Emergency Needs',
        'New Arrivals',
      ];
    }

    switch (profile!.lifeStage) {
      case LifeStage.college:
        return const [
          'All',
          'Campus Glow',
          'Acne Defense',
          'Clean Dewy',
          'Exam Fatigue',
        ];
      case LifeStage.professional:
        return const [
          'All',
          'Office Chic',
          'Blue Light Shield',
          'Desk-to-Dinner',
          'Barrier Repair',
        ];
      case LifeStage.newMom:
        return const [
          'All',
          '3-Min Routine',
          'Nursing Safe',
          'Hydration Burst',
          'Dark Circles',
        ];
      case LifeStage.teen:
        return const [
          'All',
          'School Friendly',
          'Breakout Clear',
          'Shine Control',
          'Lip Glaze',
        ];
      case LifeStage.newlywed:
        return const [
          'All',
          'Date Night',
          'Bridal Radiance',
          'Body Glow',
          'Long-Wear',
        ];
    }
  }

  IconData _getIconForTab(String tab) {
    switch (tab) {
      case 'All':
        return Icons.grid_view_rounded;
      case 'Trending':
      case 'Campus Glow':
      case 'Bridal Radiance':
        return Icons.auto_awesome;
      case 'Best Sellers':
      case 'Office Chic':
      case 'Date Night':
        return Icons.local_fire_department_rounded;
      case 'Emergency Needs':
      case 'Exam Fatigue':
      case '3-Min Routine':
        return Icons.bolt;
      case 'Acne Defense':
      case 'Breakout Clear':
      case 'Nursing Safe':
        return Icons.verified_user_outlined;
      case 'Clean Dewy':
      case 'Hydration Burst':
      case 'Barrier Repair':
        return Icons.water_drop_outlined;
      case 'Blue Light Shield':
        return Icons.shield_outlined;
      case 'Desk-to-Dinner':
      case 'Long-Wear':
        return Icons.face_retouching_natural_rounded;
      case 'Dark Circles':
        return Icons.remove_red_eye_outlined;
      case 'School Friendly':
        return Icons.backpack_outlined;
      case 'Shine Control':
        return Icons.wb_sunny_outlined;
      case 'Lip Glaze':
      case 'Body Glow':
        return Icons.brush_outlined;
      default:
        return Icons.stars_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final tabs = _resolveTabs();
    final homeProvider = context.watch<HomeProvider>();

    final barBg = isDark ? const Color(0xFF161618) : Colors.white;
    final borderThemeColor = context.borderTheme;

    final activeTab = homeProvider.activeTab;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: barBg,
        border: Border(bottom: BorderSide(color: borderThemeColor, width: 1.0)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          final tabTitle = tabs[index];
          final isSelected = activeTab == tabTitle ||
              (!tabs.contains(activeTab) && index == 0);

          return _TabPill(
            title: tabTitle,
            icon: _getIconForTab(tabTitle),
            isSelected: isSelected,
            isDark: isDark,
            onTap: () {
              homeProvider.setActiveTab(tabTitle);
            },
          );
        },
      ),
    );
  }
}

class _TabPill extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _TabPill({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeGradient = LinearGradient(
      colors: [Color(0xFFFF2D6F), Color(0xFFFF5E8F)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final inactiveBg = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : const Color(0xFFF2F2F7);

    final inactiveBorderColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : const Color(0xFFE5E5EA);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: isSelected ? activeGradient : null,
          color: isSelected ? null : inactiveBg,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(color: inactiveBorderColor, width: 1.0),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF2D6F).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : (isDark
                      ? const Color(0xFF9E9EAE)
                      : const Color(0xFF6B6B7B)),
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? Colors.white
                    : (isDark ? const Color(0xFFC5C5D2) : const Color(0xFF4A4A5A)),
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
