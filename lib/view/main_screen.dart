import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controller/nav_controller.dart';
import 'package:zytranow/view/home/home_screen.dart';
import 'package:zytranow/view/order_again/order_again_screen.dart';
import 'package:zytranow/view/categories/categories_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.watch<NavProvider>();

    final screens = const [
      HomeScreen(),
      OrderAgainScreen(),
      CategoriesScreen(),
    ];

    // Ensure we don't crash if index goes out of bounds when changing tabs length
    final safeIndex = nav.index < screens.length ? nav.index : 0;

    return Scaffold(
      extendBody: true, // IMPORTANT for glass effect
      // Wrap body in Center and ConstrainedBox for Desktop/Web responsiveness
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: screens[safeIndex],
        ),
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
                            color: Colors.white.withOpacity(
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
                              color: Colors.white.withOpacity(
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

    return GestureDetector(
      onTap: () => nav.updateIndex(i),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.8) : Colors.transparent,
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
                  : Colors.black54, // Muted grey for inactive
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? const Color(0xFFFF2D6F) : Colors.black54,
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
