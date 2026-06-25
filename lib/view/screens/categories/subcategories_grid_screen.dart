import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:zytranow/controllers/category_provider.dart';
import 'package:zytranow/view/screens/categories/category_products_screen.dart';
import 'package:zytranow/view/screens/home/widgets/shimmer_loader.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class SubcategoriesGridScreen extends StatelessWidget {
  final String mainCategoryName;

  const SubcategoriesGridScreen({super.key, required this.mainCategoryName});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String normalize(String s) {
      return s.replaceAll(RegExp(r'[^\w\s&]+'), '').trim().toLowerCase();
    }

    final normalizedName = normalize(mainCategoryName);

    // Find the Main Category section
    CategorySection? section;
    try {
      section = categoryProvider.sections.firstWhere(
        (sec) => normalize(sec.title) == normalizedName || sec.title == mainCategoryName,
        orElse: () => categoryProvider.sections.firstWhere(
          (sec) => sec.title.toLowerCase().contains(normalizedName),
        ),
      );
    } catch (_) {
      section = null;
    }

    final cleanTitle = mainCategoryName.replaceAll(RegExp(r'[^\w\s&]+'), '').trim();

    // Safe fallback: If no matching section or subcategories, navigate straight to CategoryProductsScreen
    if (section == null || section.items.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(categoryName: mainCategoryName),
          ),
        );
      });
      return Scaffold(
        backgroundColor: context.scaffoldBackground,
        body: const Center(
          child: CircularProgressIndicator(color: kPrimaryPink),
        ),
      );
    }

    final subcategories = section.items;

    return Scaffold(
      backgroundColor: context.scaffoldBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          cleanTitle,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 18,
            color: isDark ? Colors.white : Colors.black,
            letterSpacing: -0.4,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Divider(
            height: 1.0,
            thickness: 1.0,
            color: context.borderTheme,
          ),
        ),
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 columns for subcategories
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.72,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final sub = subcategories[index];
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
                                  builder: (context) => CategoryProductsScreen(categoryName: sub.name),
                                ),
                              );
                            },
                            onTapCancel: () => isPressedNotifier.value = false,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: context.cardBackground,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: isDark ? 0.01 : 0.04,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: const Color(0xFFFF2D6F).withValues(
                                          alpha: isDark ? 0.02 : 0.05,
                                        ),
                                        width: 1,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(19),
                                      child: sub.imageUrl.isNotEmpty
                                          ? CachedNetworkImage(
                                              imageUrl: sub.imageUrl,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => const ShimmerLoader(
                                                width: double.infinity,
                                                height: double.infinity,
                                                borderRadius: 19,
                                              ),
                                              errorWidget: (context, url, error) => Icon(
                                                sub.icon,
                                                color: const Color(0xFFFF2D6F),
                                                size: 28,
                                              ),
                                            )
                                          : Icon(
                                              sub.icon,
                                              color: const Color(0xFFFF2D6F),
                                              size: 28,
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  sub.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    color: context.textDark,
                                    height: 1.25,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: subcategories.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
