import 'package:flutter/material.dart';
import 'package:zytranow/controllers/category_provider.dart';
import 'package:zytranow/view/screens/categories/category_products_screen.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class CategoryCard extends StatelessWidget {
  final CategoryItem item;

  const CategoryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isPressedNotifier = ValueNotifier<bool>(false);

    return ValueListenableBuilder<bool>(
      valueListenable: isPressedNotifier,
      builder: (context, isPressed, child) {
        return AnimatedScale(
          scale: isPressed ? 0.94 : 1.0,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
          child: GestureDetector(
            onTapDown: (_) => isPressedNotifier.value = true,
            onTapUp: (_) {
              isPressedNotifier.value = false;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CategoryProductsScreen(categoryName: item.name),
                ),
              );
            },
            onTapCancel: () => isPressedNotifier.value = false,
            child: Container(
              decoration: BoxDecoration(
                color: context.cardBackground,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: context.isDark ? 0.01 : 0.04,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: const Color(
                    0xFFFF2D6F,
                  ).withValues(alpha: context.isDark ? 0.02 : 0.05),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(19),
                      ),
                      child: item.imageUrl.isNotEmpty
                          ? Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Center(child: Icon(item.icon, color: const Color(0xFFFF2D6F), size: 24)),
                            )
                          : Center(child: Icon(item.icon, color: const Color(0xFFFF2D6F), size: 24)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        item.name.replaceAll(RegExp(r'[^\w\s&]+'), '').trim(),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: context.textDark,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
