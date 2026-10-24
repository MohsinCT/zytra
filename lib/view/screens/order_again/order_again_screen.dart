import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zytranow/controllers/order_again_provider.dart';
import 'package:zytranow/controllers/order_tracking_provider.dart';
import 'package:zytranow/controllers/nav_controller.dart';
import 'package:zytranow/view/screens/home/widgets/home_search_bar.dart';
import 'package:zytranow/view/screens/home/widgets/home_top_bar.dart';
import 'package:zytranow/view/screens/home/widgets/section_titles.dart';
import 'package:zytranow/view/screens/order_again/widgets/order_product_card.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/core/utils/responsive.dart';

class OrderAgainScreen extends StatelessWidget {
  const OrderAgainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderAgainProvider>();
    final tracking = context.watch<OrderTrackingProvider>();
    final isDark = context.isDark;
    final resp = Responsive.of(context);

    // Sync any delivered items from live tracking or past completed orders
    if (tracking.activeOrder != null &&
        (tracking.activeOrder!.status == OrderStatus.delivered ||
            tracking.activeOrder!.isCompleted)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        orderProvider.syncDeliveredProducts(tracking.activeOrder!.items);
      });
    } else if (tracking.allDeliveredProducts.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        orderProvider.syncDeliveredProducts(tracking.allDeliveredProducts);
      });
    }

    if (orderProvider.isLoading) {
      return Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        body: Center(
          child: LoadingAnimationWidget.inkDrop(
            color: const Color(0xFFFF2D6F),
            size: 35.0,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverToBoxAdapter(
              child: HomeTopBar(),
            ),
            SliverAppBar(
              pinned: true,
              floating: true,
              primary: false,
              backgroundColor: isDark ? const Color(0xFF161618) : Colors.white,
              elevation: 0,
              toolbarHeight: 70,
              titleSpacing: 0,
              title: const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: HomeSearchBar(),
              ),
            ),

            if (orderProvider.products.isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
                  child: SectionTitleWithAction(
                    title: "Delivered Items",
                    action: "${orderProvider.products.length} products",
                    subtitle: "Available to re-order in minutes",
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(
                  resp.scale(12),
                  resp.scale(8),
                  resp.scale(12),
                  140, // Bottom padding for floating capsules & navigation bar
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: resp.isDesktop ? 3 : 2,
                    mainAxisSpacing: resp.scale(12),
                    crossAxisSpacing: resp.scale(12),
                    childAspectRatio: resp.isDesktop ? 0.75 : 0.52,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final product = orderProvider.products[index];
                      return OrderProductCard(
                        product: product,
                        imageHeight: resp.productImageHeight,
                      );
                    },
                    childCount: orderProvider.products.length,
                  ),
                ),
              ),
            ] else ...[
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFFF2D6F).withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.replay_rounded,
                            size: 40,
                            color: Color(0xFFFF2D6F),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "No Delivered Orders Yet",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : kTextDark,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Items from your delivered orders will show up here so you can reorder your favorites in 1 tap.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white60 : kTextMuted,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            context.read<NavProvider>().updateIndex(0);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF2D6F),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                          child: const Text(
                            "Explore Products",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
