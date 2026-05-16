import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zytranow/controller/home_provider.dart';
import 'package:zytranow/view/home/widgets/all_categories_grid.dart';
import 'package:zytranow/view/home/widgets/banner_carousel.dart';
import 'package:zytranow/view/home/widgets/home_search_bar.dart';
import 'package:zytranow/view/home/widgets/home_top_bar.dart';
import 'package:zytranow/view/home/widgets/popular_product_list.dart';
import 'package:zytranow/view/home/widgets/quick_needs_grid.dart';
import 'package:zytranow/view/home/widgets/section_titles.dart';

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
        child: LoadingAnimationWidget.inkDrop(color: const Color(0xFFFF2D6F), size: 35.0),
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
          const SliverAppBar(
            pinned: true,
            floating: true,
            primary: false,
            backgroundColor: Color(0xFFF8F9FA), // Solid background
            elevation: 0,
            toolbarHeight: 70,
            titleSpacing: 0,
            title: Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: HomeSearchBar(),
            ),
          ),

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

          // BOTTOM PADDING
          const SliverPadding(padding: EdgeInsets.only(bottom: 140)),
        ],
      ),
    );
  }
}
