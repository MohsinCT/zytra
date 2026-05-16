import 'package:flutter/material.dart';
import 'package:zytranow/controller/home_provider.dart';

class QuickNeedsGrid extends StatelessWidget {
  final List<Category> categories;
  final int columns;

  const QuickNeedsGrid({
    super.key,
    required this.categories,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    // Force 2 columns for the large-card quick needs layout
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.05,
      ),
      delegate: SliverChildBuilderDelegate((context, i) {
        final cat = categories[i];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => Navigator.of(context).pushNamed('/category', arguments: cat.name),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: const Color(0x12FF2D7A), blurRadius: 12, offset: const Offset(0, 8)),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.pink.shade50,
                      radius: 36,
                      child: Icon(cat.icon, color: Colors.pink.shade400, size: 30),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        cat.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }, childCount: categories.length),
    );
  }
}
