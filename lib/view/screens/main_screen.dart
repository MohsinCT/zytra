import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/nav_controller.dart';
import 'package:zytranow/view/screens/home/home_screen.dart';
import 'package:zytranow/view/screens/order_again/order_again_screen.dart';
import 'package:zytranow/view/screens/categories/categories_screen.dart';
import 'package:zytranow/view/widgets/floating_cart_capsule.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavProvider>();
    final isDark = context.isDark;

    final screens = const [
      HomeScreen(),
      OrderAgainScreen(),
      CategoriesScreen(),
    ];

    // Ensure we don't crash if index goes out of bounds when changing tabs length
    final safeIndex = nav.index < screens.length ? nav.index : 0;

    final bottomPadding = MediaQuery.of(context).padding.bottom;

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
          // Persistent Floating View Cart Capsule
          Positioned(
            left: 0,
            right: 0,
            bottom:
                bottomPadding +
                110, // Sits beautifully above custom glassmorphic nav bar (75 height + 24 padding)
            child: const FloatingCartCapsule(),
          ),
        ],
      ),

      // Advanced Glassmorphism Nav Bar
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 25,
                          sigmaY: 25,
                        ), // High blur
                        child: Container(
                          height: 75,
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.black.withOpacity(0.4)
                                : Colors.white.withOpacity(
                                    0.15,
                                  ), // Semi-transparent glass
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withOpacity(0.15)
                                  : Colors.white.withOpacity(
                                      0.3,
                                    ), // Soft frosted edge
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _navItem(context, Icons.home_filled, "Home", 0),
                              _navItem(
                                context,
                                Icons.grid_view,
                                "Categories",
                                2,
                              ),
                              _navItem(
                                context,
                                Icons.receipt_long_outlined,
                                "Order Again",
                                1,
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
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, String label, int i) {
    final nav = context.watch<NavProvider>();
    final isActive = nav.index == i;
    final isDark = context.isDark;

    return GestureDetector(
      onTap: () => nav.updateIndex(i),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark
                    ? Colors.white.withOpacity(0.15)
                    : Colors.white.withOpacity(0.8))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF2D6F).withOpacity(0.15),
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
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? const Color(0xFFFF2D6F)
                    : (isDark ? Colors.white70 : Colors.black54),
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
