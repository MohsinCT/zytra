import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/nav_controller.dart';
import 'package:zytranow/controllers/cart_provider.dart';
import 'package:zytranow/controllers/order_tracking_provider.dart';
import 'package:zytranow/view/screens/home/home_screen.dart';
import 'package:zytranow/view/screens/order_again/order_again_screen.dart';
import 'package:zytranow/view/screens/categories/categories_screen.dart';
import 'package:zytranow/view/screens/mia/mia_screen.dart';
import 'package:zytranow/view/widgets/floating_cart_capsule.dart';
import 'package:zytranow/view/widgets/floating_order_tracking_capsule.dart';
import 'package:zytranow/view/screens/order_notification_banner.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavProvider>();
    final cart = context.watch<CartProvider>();
    final tracking = context.watch<OrderTrackingProvider>();

    final isDark = context.isDark;
    final width = MediaQuery.of(context).size.width;
    final isSmallMobile = width <= 360;
    final isTabletOrWeb = width > 700;

    final screens = const [
      HomeScreen(),
      CategoriesScreen(),
      OrderAgainScreen(),
    ];

    // Ensure we don't crash if index goes out of bounds when changing tabs length
    final safeIndex = nav.index < screens.length ? nav.index : 0;

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    final hasActiveOrder = tracking.hasActiveOrder;
    final hasCartItems = cart.totalItems > 0;

    // Determine bottom offset for floating capsules so they don't overlap
    double orderCapsuleBottom = bottomPadding + 110;
    double cartCapsuleBottom = bottomPadding + 110;

    if (hasActiveOrder && hasCartItems) {
      cartCapsuleBottom =
          bottomPadding + 180; // Cart capsule floats above order status capsule
    }

    // Determine bottom offset for Mia AI Floating Action Button so it floats above capsules
    double miaFabBottom = bottomPadding + (isSmallMobile ? 86 : 98);
    if (hasActiveOrder && hasCartItems) {
      miaFabBottom = bottomPadding + 252;
    } else if (hasActiveOrder || hasCartItems) {
      miaFabBottom = bottomPadding + 182;
    }

    return Scaffold(
      extendBody: true, // IMPORTANT for glass effect
      body: Stack(
        children: [
          // Main screen body
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: screens[safeIndex],
            ),
          ),

          // Persistent Floating Live Order Status Capsule
          Positioned(
            left: 0,
            right: 0,
            bottom: orderCapsuleBottom,
            child: const FloatingOrderTrackingCapsule(),
          ),

          // Persistent Floating View Cart Capsule
          Positioned(
            left: 0,
            right: 0,
            bottom: cartCapsuleBottom,
            child: const FloatingCartCapsule(),
          ),

          // Persistent Floating "Mia AI" Action Button
          AnimatedPositioned(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            right: isTabletOrWeb ? 28 : 18,
            bottom: miaFabBottom,
            child: _buildMiaFab(context, isDark),
          ),

          // Top Floating In-App Order Status Notification Banner
          const OrderNotificationBanner(),
        ],
      ),

      // Advanced Glassmorphism Nav Bar
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final navBarHeight = isSmallMobile ? 64.0 : 70.0;
          final horizontalPadding = isSmallMobile
              ? 6.0
              : (isTabletOrWeb ? 24.0 : 10.0);
          final innerHorizontalPadding = isSmallMobile ? 4.0 : 8.0;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isSmallMobile ? 12 : 18,
                left: horizontalPadding,
                right: horizontalPadding,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(36),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 25,
                            sigmaY: 25,
                          ), // High blur
                          child: Container(
                            height: navBarHeight,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.45)
                                  : Colors.white.withValues(
                                      alpha: 0.18,
                                    ), // Semi-transparent glass
                              borderRadius: BorderRadius.circular(36),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.08),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.15)
                                    : Colors.white.withValues(
                                        alpha: 0.35,
                                      ), // Soft frosted edge
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: innerHorizontalPadding,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _navItem(
                                      context,
                                      Icons.home_filled,
                                      "Home",
                                      0,
                                      isSmallMobile,
                                    ),
                                  ),
                                  Expanded(
                                    child: _navItem(
                                      context,
                                      Icons.grid_view,
                                      "Categories",
                                      1,
                                      isSmallMobile,
                                    ),
                                  ),
                                  Expanded(
                                    child: _navItem(
                                      context,
                                      Icons.receipt_long_outlined,
                                      "Order Again",
                                      2,
                                      isSmallMobile,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Opens the Mia AI screen as a separate, full-featured screen
  void _openMiaScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MiaScreen()),
    );
  }

  /// Floating Action Button for Mia AI with signature iOS glassmorphic gradient styling
  Widget _buildMiaFab(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF2D6F), Color(0xFFFF5E8F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF2D6F).withValues(alpha: 0.45),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: const Color(0xFF7928CA).withValues(alpha: 0.22),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: FloatingActionButton.extended(
          heroTag: 'mia_ai_floating_button',
          onPressed: () => _openMiaScreen(context),
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          tooltip: 'Mia AI',
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.45),
              width: 1.2,
            ),
          ),
          icon: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.22),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 16,
            ),
          ),
          label: const Text(
            "Mia AI",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(
    BuildContext context,
    IconData icon,
    String label,
    int i,
    bool isSmallMobile,
  ) {
    final nav = context.watch<NavProvider>();
    final isActive = nav.index == i;
    final isDark = context.isDark;

    final iconSize = isSmallMobile ? 18.0 : 20.0;
    final fontSize = isSmallMobile ? 9.5 : 10.5;

    return GestureDetector(
      onTap: () => nav.updateIndex(i),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: isSmallMobile ? 2 : 4,
          vertical: isSmallMobile ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark
                    ? Colors.white.withValues(alpha: 0.15)
                    : Colors.white.withValues(alpha: 0.85))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF2D6F).withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? const Color(0xFFFF2D6F)
                  : (isDark
                        ? Colors.white70
                        : Colors.black54), // Muted color for inactive
              size: iconSize,
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isActive
                        ? const Color(0xFFFF2D6F)
                        : (isDark ? Colors.white70 : Colors.black54),
                    fontSize: fontSize,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
