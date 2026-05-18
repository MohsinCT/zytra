import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zytranow/controllers/order_again_provider.dart';
import 'package:zytranow/view/screens/home/widgets/home_search_bar.dart';
import 'package:zytranow/view/screens/order_again/widgets/order_product_card.dart';
import 'package:zytranow/view/screens/home/widgets/home_top_bar.dart';

class OrderAgainScreen extends StatelessWidget {
  const OrderAgainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderAgainProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Light grey background
      body: orderProvider.isLoading
          ? Center(
              child: LoadingAnimationWidget.inkDrop(
                color: const Color(0xFFFF2D6F),
                size: 35.0,
              ),
            )
          : SafeArea(
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
                    backgroundColor: Color(0xFFF8F9FA), // Solid background
                    elevation: 0,
                    toolbarHeight: 70,
                    titleSpacing: 0,
                    title: Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: HomeSearchBar(),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      120,
                    ), // Bottom padding for nav bar
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.65, // Tall card layout
                          ),
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final product = orderProvider.products[index];
                        return OrderProductCard(product: product);
                      }, childCount: orderProvider.products.length),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
