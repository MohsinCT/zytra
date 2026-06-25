import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/category_provider.dart';
import 'package:zytranow/view/screens/home/widgets/home_search_bar.dart';
import 'package:zytranow/view/screens/home/widgets/home_top_bar.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = context.watch<CategoryProvider>();
    final sections = categoryProvider.sections;

    return Scaffold(
      backgroundColor: context.scaffoldBackground,
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
            SliverAppBar(
              pinned: true,
              floating: true,
              primary: false,
              backgroundColor: context.scaffoldBackground,
              elevation: 0,
              toolbarHeight: 70,
              titleSpacing: 0,
              title: const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: HomeSearchBar(),
              ),
            ),
            ...sections.expand((section) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                    child: Row(
                      children: [
                        Text(
                          section.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: context.textDark,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Divider(
                            color: context.borderTheme,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = section.items[index];
                        final cleanName = item.name.replaceAll(RegExp(r'[^\w\s&]+'), '').trim();

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              '/category',
                              arguments: item.name,
                            );
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Column(
                            children: [
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: context.cardBackground,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: context.isDark ? 0.01 : 0.03,
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: const Color(0xFFFF2D6F).withValues(
                                        alpha: context.isDark ? 0.02 : 0.04,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: item.imageUrl.isNotEmpty
                                        ? Image.network(
                                            item.imageUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error, stackTrace) =>
                                                Icon(item.icon, color: const Color(0xFFFF2D6F), size: 24),
                                          )
                                        : Icon(item.icon, color: const Color(0xFFFF2D6F), size: 24),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                cleanName,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  color: context.textDark,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: section.items.length,
                    ),
                  ),
                ),
              ];
            }),
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
}
