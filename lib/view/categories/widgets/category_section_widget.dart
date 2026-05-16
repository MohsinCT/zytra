import 'package:flutter/material.dart';
import 'package:zytranow/controller/category_provider.dart';
import 'package:zytranow/view/categories/widgets/category_card.dart';

class CategorySectionWidget extends StatelessWidget {
  final CategorySection section;

  const CategorySectionWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section title with emoji
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            section.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ),
        // Compact 4-column grid
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4 cards per row (compact Blinkit style)
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85, // Slightly taller for text
          ),
          itemCount: section.items.length,
          itemBuilder: (context, index) {
            return CategoryCard(item: section.items[index]);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
