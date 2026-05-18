import 'package:flutter/material.dart';
import 'package:zytranow/controllers/home_provider.dart';

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
        return Column(
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Icon(cat.icon, color: const Color(0xFFFF2D6F), size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              cat.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.1,
              ),
            ),
          ],
        );
      }, childCount: categories.length),
    );
  }
}
