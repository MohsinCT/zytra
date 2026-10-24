import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zytranow/controllers/home_provider.dart';
import 'package:zytranow/controllers/quiz_provider.dart';
import 'package:zytranow/controllers/user_provider.dart';
import 'package:zytranow/models/quiz_models.dart';
import 'package:zytranow/view/screens/home/widgets/all_categories_grid.dart';
import 'package:zytranow/view/screens/home/widgets/banner_carousel.dart';
import 'package:zytranow/view/screens/home/widgets/dynamic_category_tabs.dart';
import 'package:zytranow/view/screens/home/widgets/home_search_bar.dart';
import 'package:zytranow/view/screens/home/widgets/home_top_bar.dart';
import 'package:zytranow/view/screens/home/widgets/personalized_profile_capsule.dart';
import 'package:zytranow/view/screens/home/widgets/popular_product_list.dart';
import 'package:zytranow/view/screens/home/widgets/quick_needs_grid.dart';
import 'package:zytranow/view/screens/home/widgets/quiz_cta_banner.dart';
import 'package:zytranow/view/screens/home/widgets/routine_bundle_banner.dart';
import 'package:zytranow/view/screens/home/widgets/section_titles.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/view/screens/categories/widgets/category_section_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();
    final quizProvider = context.watch<QuizProvider>();
    final userProvider = context.watch<UserProvider>();

    // Determine personalization status & user profile
    final isPersonalized =
        quizProvider.isQuizCompleted || userProvider.quizCompleted;
    final userProfile =
        quizProvider.userProfile ??
        (userProvider.quizProfile != null
            ? UserProfile.fromQuizProfile(
                userProvider.quizProfile!,
                name: userProvider.fullName,
              )
            : null);

    // Responsive Breakpoints
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;
    final isTablet = width > 600 && width <= 900;

    int quickNeedsCols = isDesktop ? 6 : (isTablet ? 4 : 3);
    int allCategoriesCols = isDesktop ? 8 : (isTablet ? 6 : 4);

    final isDark = context.isDark;

    if (homeProvider.isLoading) {
      return Center(
        child: LoadingAnimationWidget.inkDrop(
          color: const Color(0xFFFF2D6F),
          size: 35.0,
        ),
      );
    }

    return Container(
      color: isDark ? const Color(0xFF121212) : Colors.white,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // TOP HEADER (Scrolls away)
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HomeTopBar(),
                  // A. Personalized Profile Status Capsule (between address & search bar)
                  if (isPersonalized && userProfile != null)
                    PersonalizedProfileCapsule(profile: userProfile),
                ],
              ),
            ),

            // STICKY SEARCH BAR & B. DYNAMIC CATEGORY TABS
            SliverAppBar(
              pinned: true,
              floating: true,
              primary: false,
              backgroundColor: context.isDark
                  ? const Color(0xFF161618)
                  : Colors.white, // Solid background
              elevation: 0,
              toolbarHeight: 70,
              titleSpacing: 0,
              title: const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: HomeSearchBar(),
              ),
              bottom: DynamicCategoryTabs(
                isPersonalized: isPersonalized,
                profile: userProfile,
              ),
            ),

            if (homeProvider.activeTab == 'All') ...[
              // MAIN CONTENT
              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 10),

                  // C. HERO BANNER: Routine Bundle Banner vs Quiz CTA Banner & Promo Carousel
                  if (isPersonalized && userProfile != null)
                    RoutineBundleBanner(profile: userProfile)
                  else ...[
                    const QuizCtaBanner(),
                    const SizedBox(height: 16),
                    const BannerCarousel(),
                  ],

                  const SizedBox(height: 24),

                  // D. QUICK NEEDS SECTION HEADER
                  SectionTitle(
                    title: isPersonalized
                        ? "✨ Your Tailored Essentials"
                        : "⚡ Quick Needs",
                  ),
                  const SizedBox(height: 12),
                ]),
              ),

              // D. QUICK NEEDS GRID: Personalized Shortcuts vs Default Categories
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: QuickNeedsGrid(
                  categories: homeProvider.quickCategories,
                  columns: quickNeedsCols,
                  isPersonalized: isPersonalized,
                  profile: userProfile,
                ),
              ),

              // E. PRODUCT SHELF: "Matched For You" vs "Popular Now"
              SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 24),
                  SectionTitleWithAction(
                    title: isPersonalized
                        ? "✨ 98% Match for Your Skin Profile"
                        : "🔥 Popular Now",
                    action: "See All",
                    subtitle: (isPersonalized && userProfile != null)
                        ? "Filtered for ${userProfile.skinTypeCapitalized} skin • No ${userProfile.avoidIngredients.take(2).join(', ')}"
                        : null,
                  ),
                  const SizedBox(height: 12),
                  PopularProductList(
                    products: homeProvider.popularProducts,
                    isPersonalized: isPersonalized,
                    profile: userProfile,
                  ),
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
                  if (isPersonalized && userProfile != null)
                    RoutineBundleBanner(profile: userProfile)
                  else
                    const BannerCarousel(),
                  const SizedBox(height: 16),
                ]),
              ),

              // RENDER CATEGORIES SECTIONS DYNAMICALLY
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final section = homeProvider.activeSections[index];
                  return CategorySectionWidget(section: section);
                }, childCount: homeProvider.activeSections.length),
              ),
            ],

            // BOTTOM PADDING FOR FLOATING CAPSULES
            const SliverPadding(padding: EdgeInsets.only(bottom: 140)),
          ],
        ),
      ),
    );
  }
}
