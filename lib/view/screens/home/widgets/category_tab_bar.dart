import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/home_provider.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class TabCategoryItem {
  final String name;
  final IconData icon;
  final String mappedCategory;

  const TabCategoryItem({
    required this.name,
    required this.icon,
    required this.mappedCategory,
  });
}

class CategoryTabBar extends StatelessWidget implements PreferredSizeWidget {
  const CategoryTabBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  static const List<TabCategoryItem> _items = [
    TabCategoryItem(
      name: 'All',
      icon: Icons.grid_view_rounded,
      mappedCategory: 'All',
    ),
    TabCategoryItem(
      name: 'Women',
      icon: Icons.face_retouching_natural_rounded,
      mappedCategory: 'Women',
    ),
    TabCategoryItem(
      name: 'Pregnancy Mom',
      icon: Icons.pregnant_woman_rounded,
      mappedCategory: 'Pregnancy Mom',
    ),
    TabCategoryItem(
      name: 'Kids',
      icon: Icons.child_care_rounded,
      mappedCategory: 'Kids',
    ),
    TabCategoryItem(
      name: 'Homes',
      icon: Icons.home_work_rounded,
      mappedCategory: 'Homes',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final homeProvider = context.watch<HomeProvider>();
    final activeTabName = homeProvider.activeTab;

    // Premium background and border colors for the bar itself
    final barBg = isDark ? const Color(0xFF161618) : Colors.white;
    final borderThemeColor = context.borderTheme;

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: barBg,
        border: Border(bottom: BorderSide(color: borderThemeColor, width: 1.0)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final item = _items[index];
          final isSelected = activeTabName == item.mappedCategory;

          return _InteractiveTabPill(
            item: item,
            isSelected: isSelected,
            isDark: isDark,
            onTap: () {
              context.read<HomeProvider>().setActiveTab(item.mappedCategory);
            },
          );
        },
      ),
    );
  }
}

class _InteractiveTabPill extends StatelessWidget {
  final TabCategoryItem item;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _InteractiveTabPill({
    required this.item,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Brand design styling for active/inactive states
    final textStyle = TextStyle(
      fontSize: 13,
      fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
      color: isSelected
          ? Colors.white
          : (isDark ? const Color(0xFFC5C5D2) : const Color(0xFF4A4A5A)),
      letterSpacing: 0.2,
    );

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
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16),
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
              item.icon,
              color: isSelected
                  ? Colors.white
                  : (isDark
                      ? const Color(0xFF9E9EAE)
                      : const Color(0xFF6B6B7B)),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(item.name, style: textStyle),
          ],
        ),
      ),
    );
  }
}
