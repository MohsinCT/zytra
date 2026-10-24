import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/cart_provider.dart';
import 'package:zytranow/controllers/order_tracking_provider.dart';
import 'package:zytranow/models/product.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/view/screens/order_tracking_screen.dart';

class OrderSuccessScreen extends StatelessWidget {
  final double grandTotal;

  const OrderSuccessScreen({
    super.key,
    required this.grandTotal,
  });

  void _scheduleComplete(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (!context.mounted) return;

        final cart = Provider.of<CartProvider>(context, listen: false);
        final tracking = Provider.of<OrderTrackingProvider>(context, listen: false);

        // Save cart items before clearing
        final cartItems = List<Product>.from(cart.items);

        // Start order tracking simulation
        tracking.startOrder(
          items: cartItems,
          grandTotal: grandTotal,
        );

        // Clear cart
        cart.clearCart();

        // Navigate replacement to Order Tracking Screen
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const OrderTrackingScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _scheduleComplete(context);

    final isDark = context.isDark;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(flex: 2),
                          // Animated Checkmark Circle with Pink & White Accents
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: Container(
                              width: 140,
                              height: 140,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF2D6F), Color(0xFFFF5287)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFF2D6F).withValues(alpha: 0.35),
                                    blurRadius: 30,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 80,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Title "Yay! Order Received"
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                            builder: (context, opacity, child) {
                              return Opacity(opacity: opacity, child: child);
                            },
                            child: Column(
                              children: [
                                Text(
                                  'Yay! Order Received',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                                    letterSpacing: 0.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Your order will be delivered shortly. Keep exploring great deals on evermi!',
                                  style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: isDark ? Colors.grey[400] : const Color(0xFF6E6E80),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(flex: 3),
                          // Subtle loader at bottom
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF2D6F).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2D6F)),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Preparing your live tracking...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF2D6F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
