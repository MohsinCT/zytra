import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/nav_controller.dart';
import 'package:zytranow/controllers/order_again_provider.dart';
import 'package:zytranow/controllers/order_tracking_provider.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class DeliveryCompletedDialog extends StatelessWidget {
  const DeliveryCompletedDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const DeliveryCompletedDialog(),
    );
  }

  void _handleOkay(BuildContext context) async {
    final tracking = Provider.of<OrderTrackingProvider>(context, listen: false);
    final orderAgain = Provider.of<OrderAgainProvider>(context, listen: false);
    final nav = Provider.of<NavProvider>(context, listen: false);

    if (tracking.isRatingSubmitting) return;

    tracking.setRatingSubmitting(true);

    final activeOrder = tracking.activeOrder;
    if (activeOrder != null) {
      // 1. Submit rating & complete order
      tracking.submitRating(tracking.selectedRating);

      // 2. Add ordered products to "Order Again" section
      orderAgain.addRecentlyOrderedProducts(activeOrder.items);
    }

    tracking.setThankYouShown(true);

    // Show Thank You screen for 1.5 seconds then redirect back to Home Screen
    await Future.delayed(const Duration(milliseconds: 1500));

    if (!context.mounted) return;

    // Reset tracking provider active order state
    tracking.clearActiveOrder();

    // Switch to Home tab (index 0)
    nav.updateIndex(0);

    // Navigate back to root/home screen
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final tracking = context.watch<OrderTrackingProvider>();
    final isDark = context.isDark;
    const pinkColor = kPrimaryPink;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      backgroundColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
      elevation: 16,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: tracking.isThankYouShown
                ? _buildThankYouState(isDark, pinkColor)
                : _buildRatingState(context, tracking, isDark, pinkColor),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingState(
    BuildContext context,
    OrderTrackingProvider tracking,
    bool isDark,
    Color pinkColor,
  ) {
    return Column(
      key: const ValueKey('rating_state'),
      mainAxisSize: MainAxisSize.min,
      children: [
        // Top Icon
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF2D6F), Color(0xFFFF6A9A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: pinkColor.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.celebration_rounded,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(height: 18),
        // Title
        Text(
          'Order Delivered!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your items have arrived. How was your delivery experience with Delivery Man?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            height: 1.4,
            color: isDark ? Colors.grey[400] : const Color(0xFF6E6E80),
          ),
        ),
        const SizedBox(height: 20),
        // 5-Star Rating Selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starNumber = index + 1;
            final isSelected = starNumber <= tracking.selectedRating;

            return GestureDetector(
              onTap: () => tracking.setSelectedRating(starNumber),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: AnimatedScale(
                  scale: isSelected ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isSelected ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isSelected ? const Color(0xFFFFB800) : Colors.grey.shade400,
                    size: 38,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Text(
          _getRatingLabel(tracking.selectedRating),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: pinkColor,
          ),
        ),
        const SizedBox(height: 24),
        // "Okay" Button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: tracking.isRatingSubmitting ? null : () => _handleOkay(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: pinkColor,
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: pinkColor.withValues(alpha: 0.35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: tracking.isRatingSubmitting
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Okay',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildThankYouState(bool isDark, Color pinkColor) {
    return Column(
      key: const ValueKey('thank_you_state'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 12),
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 48,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Thank You!',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Your feedback helps us make evermi deliveries even faster.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Redirecting to Home Screen...',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: pinkColor,
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Needs Improvement 😞';
      case 2:
        return 'Fair Delivery 😐';
      case 3:
        return 'Good Delivery 🙂';
      case 4:
        return 'Very Good! 😊';
      case 5:
        return 'Superfast & Excellent! 🚀';
      default:
        return '';
    }
  }
}
