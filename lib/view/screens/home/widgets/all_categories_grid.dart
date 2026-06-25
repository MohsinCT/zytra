import 'package:flutter/material.dart';
import 'package:zytranow/controllers/home_provider.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class AllCategoriesGrid extends StatelessWidget {
  final List<Category> categories;
  final int columns;

  const AllCategoriesGrid({
    super.key,
    required this.categories,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisSpacing: 16,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      delegate: SliverChildBuilderDelegate((context, i) {
        final cat = categories[i];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              '/category',
              arguments: cat.name,
            );
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Container(
                height: 64,
                width: 64,
                decoration: BoxDecoration(
                  color: context.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(
                        alpha: context.isDark ? 0.01 : 0.06,
                      ),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: context.borderTheme),
                ),
                child: cat.imageUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: cat.imageUrl.startsWith('http')
                            ? Image.network(cat.imageUrl, fit: BoxFit.cover)
                            : Image.asset(cat.imageUrl, fit: BoxFit.cover),
                      )
                    : Icon(cat.icon, color: const Color(0xFFFF2D6F), size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                cat.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: context.textDark,
                  height: 1.1,
                ),
              ),
            ],
          ),
        );
      }, childCount: categories.length),
    );
  }
}
