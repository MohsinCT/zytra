import 'package:flutter/material.dart';
import 'package:zytranow/controllers/category_provider.dart';
import 'package:zytranow/view/screens/categories/widgets/category_card.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class CategorySectionWidget extends StatelessWidget {
  final CategorySection section;

  const CategorySectionWidget({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Premium bold section header exactly matching the reference image
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Text(
            section.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900, // Ultra bold modern typography
              color: context.textDark,
              letterSpacing: -0.4,
            ),
          ),
        ),

        // Beautiful 4-column category grid with equal spacing
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // 4 columns per row exactly like ref image
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio:
                0.76, // Elegant taller ratio for premium visual structure
          ),
          itemCount: section.items.length,
          itemBuilder: (context, index) {
            return CategoryCard(item: section.items[index]);
          },
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
