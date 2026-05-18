import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/category_provider.dart';
import 'package:zytranow/view/screens/categories/widgets/category_section_widget.dart';
import 'package:zytranow/view/screens/home/widgets/home_search_bar.dart';
import 'package:zytranow/view/screens/home/widgets/home_top_bar.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7), // Soft white background
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: HomeTopBar(),
              ),
            ),
            const SliverAppBar(
              pinned: true,
              floating: true,
              primary: false,
              backgroundColor: Color(0xFFF7F7F7), // Match background
              elevation: 0,
              toolbarHeight: 70,
              titleSpacing: 0,
              title: Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: HomeSearchBar(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 120,
              ), // Compact padding
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final section = categoryProvider.sections[index];
                  return CategorySectionWidget(section: section);
                }, childCount: categoryProvider.sections.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
