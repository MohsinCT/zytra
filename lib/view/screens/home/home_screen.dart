import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zytranow/controllers/home_provider.dart';
import 'package:zytranow/view/screens/home/widgets/all_categories_grid.dart';
import 'package:zytranow/view/screens/home/widgets/banner_carousel.dart';
import 'package:zytranow/view/screens/home/widgets/home_search_bar.dart';
import 'package:zytranow/view/screens/home/widgets/home_top_bar.dart';
import 'package:zytranow/view/screens/home/widgets/popular_product_list.dart';
import 'package:zytranow/view/screens/home/widgets/quick_needs_grid.dart';
import 'package:zytranow/view/screens/home/widgets/section_titles.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/view/screens/home/widgets/category_tab_bar.dart';
import 'package:zytranow/view/screens/categories/widgets/category_section_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    // Responsive Breakpoints
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final isTablet = width > 600 && width <= 900;

    int quickNeedsCols = isDesktop ? 6 : (isTablet ? 4 : 3);
    int allCategoriesCols = isDesktop ? 8 : (isTablet ? 6 : 4);

    if (homeProvider.isLoading) {
      return Center(
        child: LoadingAnimationWidget.inkDrop(
          color: const Color(0xFFFF2D6F),
          size: 35.0,
        ),
      );
    }

    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          // TOP HEADER (Scrolls away)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: HomeTopBar(),
            ),
          ),

          // STICKY SEARCH BAR
          SliverAppBar(
            pinned: true,
            floating: true,
            primary: false,
            backgroundColor: context.scaffoldBackground, // Solid background
            elevation: 0,
            toolbarHeight: 70,
            titleSpacing: 0,
            title: const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: HomeSearchBar(),
            ),
            bottom: const CategoryTabBar(),
          ),

          if (homeProvider.activeTab == 'All') ...[
            // MAIN CONTENT
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 10),
                const BannerCarousel(),
                const SizedBox(height: 24),
                const SectionTitle(title: "⚡ Quick Needs"),
                const SizedBox(height: 12),
              ]),
            ),

            // QUICK NEEDS GRID
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: QuickNeedsGrid(
                categories: homeProvider.quickCategories,
                columns: quickNeedsCols,
              ),
            ),

            // POPULAR NOW
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 24),
                const SectionTitleWithAction(
                  title: "🔥 Popular Now",
                  action: "See All",
                ),
                const SizedBox(height: 12),
                PopularProductList(products: homeProvider.popularProducts),
                const SizedBox(height: 24),
                const SectionTitle(title: "Explore Categories"),
                const SizedBox(height: 12),
              ]),
            ),

            // EXPLORE CATEGORIES GRID
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: AllCategoriesGrid(
                categories: homeProvider.allCategories,
                columns: allCategoriesCols,
              ),
            ),
          ] else ...[
            // CAROUSEL & DYNAMIC FILTERED SECTIONS
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 10),
                const BannerCarousel(),
                const SizedBox(height: 16),
              ]),
            ),

            // RENDER 3 CATEGORIES SECTIONS DYNAMICALLY
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final section = homeProvider.activeSections[index];
                  return CategorySectionWidget(section: section);
                },
                childCount: homeProvider.activeSections.length,
              ),
            ),
          ],

          // BOTTOM PADDING
          const SliverPadding(padding: EdgeInsets.only(bottom: 140)),
        ],
      ),
    );
  }
}
