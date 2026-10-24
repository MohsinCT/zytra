import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/order_tracking_provider.dart';
import 'package:zytranow/controllers/address_provider.dart';
import 'package:zytranow/controllers/location_provider.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/view/screens/delivery_completed_dialog.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tracking = context.watch<OrderTrackingProvider>();
    final isDark = context.isDark;
    const pinkColor = kPrimaryPink;

    final activeOrder = tracking.activeOrder;
    final currentStatus = tracking.currentStatus;

    // Trigger rating dialog when order reaches Delivered status using Provider state
    if (currentStatus == OrderStatus.delivered && !tracking.isRatingDialogShown) {
      tracking.markRatingDialogShown();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          DeliveryCompletedDialog.show(context);
        }
      });
    }

    final orderId = activeOrder?.orderId ?? 'ZY24S6B278';
    final placedTimeStr = activeOrder != null
        ? _formatTime(activeOrder.placedAt)
        : '10:32 AM';

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E24) : Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: isDark ? Colors.white : Colors.black87,
            size: 18,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Order Tracking',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.shopping_bag_outlined,
              color: isDark ? Colors.white70 : Colors.black87,
              size: 22,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order ID: $orderId (${activeOrder?.items.length ?? 0} items)'),
                  backgroundColor: pinkColor,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order ID & Placed Date header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order ID: $orderId',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Placed on ${_formatDate(activeOrder?.placedAt ?? DateTime.now())}, $placedTimeStr',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? Colors.grey[400] : const Color(0xFF8A8A9A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: pinkColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: pinkColor.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          currentStatus.title.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: pinkColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Hero Delivery Status Card (Matching Reference Layout)
                  _buildHeroDeliveryCard(context, tracking, isDark, pinkColor),

                  const SizedBox(height: 24),

                  // 5-Step Horizontal Tracking Progress Bar
                  _buildStepTracker(context, currentStatus, activeOrder?.placedAt, isDark, pinkColor),

                  const SizedBox(height: 24),

                  // Rider Details Card
                  _buildRiderCard(context, isDark, pinkColor),

                  const SizedBox(height: 16),

                  // Delivery Address Card
                  _buildAddressCard(context, isDark, pinkColor),

                  const SizedBox(height: 28),

                  // "Need Help?" CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Support agent connected! How can we help you with order $orderId?'),
                            backgroundColor: pinkColor,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: pinkColor,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: pinkColor.withValues(alpha: 0.35),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Need Help?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroDeliveryCard(
    BuildContext context,
    OrderTrackingProvider tracking,
    bool isDark,
    Color pinkColor,
  ) {
    final status = tracking.currentStatus;
    final countdownStr = tracking.remainingTimeString;
    final minsOnlyStr = tracking.remainingMinutesOnlyString;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // Scooter Rider Illustration Vector Graphic
          _buildRiderIllustration(pinkColor),
          const SizedBox(width: 16),
          // Status & Live Countdown text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  status == OrderStatus.delivered
                      ? 'Delivered successfully'
                      : 'Arriving in',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey[400] : const Color(0xFF8A8A9A),
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  children: [
                    Text(
                      status == OrderStatus.delivered ? 'Just Now' : minsOnlyStr,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: pinkColor,
                      ),
                    ),
                    if (status != OrderStatus.delivered) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: pinkColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          countdownStr,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: pinkColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiderIllustration(Color pinkColor) {
    return Container(
      width: 100,
      height: 96,
      decoration: BoxDecoration(
        color: kPrimaryPinkLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft pink circle backdrop
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: pinkColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
          ),
          // Delivery Scooter Rider Custom Vector Representation
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.two_wheeler_rounded,
                size: 46,
                color: pinkColor,
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: pinkColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt, size: 10, color: Colors.white),
                    SizedBox(width: 2),
                    Text(
                      'EXPRESS',
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepTracker(
    BuildContext context,
    OrderStatus currentStatus,
    DateTime? placedAt,
    bool isDark,
    Color pinkColor,
  ) {
    final steps = [
      {'title': 'Placed', 'status': OrderStatus.placed, 'icon': Icons.home_rounded},
      {'title': 'Confirmed', 'status': OrderStatus.confirmed, 'icon': Icons.inventory_2_rounded},
      {'title': 'Packed', 'status': OrderStatus.packed, 'icon': Icons.local_shipping_rounded},
      {'title': 'Out for\nDelivery', 'status': OrderStatus.outForDelivery, 'icon': Icons.moped_rounded},
      {'title': 'Delivered', 'status': OrderStatus.delivered, 'icon': Icons.assignment_turned_in_rounded},
    ];

    final currentIndex = currentStatus.stepIndex;
    final startTime = placedAt ?? DateTime.now();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade100,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(steps.length, (index) {
          final isCompleted = index <= currentIndex;
          final isCurrent = index == currentIndex;

          // Step time calculation for visual realism
          final stepTime = startTime.add(Duration(minutes: index));
          final timeStr = _formatTime(stepTime);

          return Expanded(
            child: Column(
              children: [
                // Icon Circle + Connecting Line Row (SizedBox height 38 guarantees 100% straight center line alignment)
                SizedBox(
                  height: 38,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left line spacer if index > 0
                      Expanded(
                        child: Container(
                          height: 3,
                          color: index == 0
                              ? Colors.transparent
                              : (index <= currentIndex
                                  ? pinkColor
                                  : (isDark ? Colors.grey[800] : Colors.grey[200])),
                        ),
                      ),
                      // Circle Indicator
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: isCurrent ? 32 : 26,
                        height: isCurrent ? 32 : 26,
                        decoration: BoxDecoration(
                          color: isCompleted ? pinkColor : (isDark ? const Color(0xFF2C2C35) : Colors.white),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isCompleted
                                ? pinkColor
                                : (isDark ? Colors.grey[700]! : Colors.grey[300]!),
                            width: 2,
                          ),
                          boxShadow: isCurrent
                              ? [
                                  BoxShadow(
                                    color: pinkColor.withValues(alpha: 0.4),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ]
                              : [],
                        ),
                        child: Icon(
                          isCompleted ? Icons.check : (steps[index]['icon'] as IconData),
                          size: isCurrent ? 16 : 12,
                          color: isCompleted
                              ? Colors.white
                              : (isDark ? Colors.grey[500] : Colors.grey[400]),
                        ),
                      ),
                      // Right line spacer if index < steps.length - 1
                      Expanded(
                        child: Container(
                          height: 3,
                          color: index == steps.length - 1
                              ? Colors.transparent
                              : (index < currentIndex
                                  ? pinkColor
                                  : (isDark ? Colors.grey[800] : Colors.grey[200])),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Step Title (Fixed height 28 to keep multi-line titles like Out for Delivery aligned with single-line titles)
                Container(
                  height: 28,
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      steps[index]['title'] as String,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isCurrent ? 11 : 10,
                        fontWeight: isCurrent ? FontWeight.w900 : (isCompleted ? FontWeight.bold : FontWeight.w500),
                        color: isCompleted
                            ? (isDark ? Colors.white : const Color(0xFF1A1A2E))
                            : (isDark ? Colors.grey[600] : Colors.grey[500]),
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Step Time
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    timeStr,
                    style: TextStyle(
                      fontSize: 9,
                      color: isCompleted
                          ? (isDark ? Colors.grey[400] : Colors.grey[600])
                          : (isDark ? Colors.grey[700] : Colors.grey[400]),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRiderCard(BuildContext context, bool isDark, Color pinkColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E24) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rider Details',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              // Rider Avatar
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF2D6F), Color(0xFFFF6A9A)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: pinkColor.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const ClipOval(
                  child: Center(
                    child: Text(
                      '👨‍✈️',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Rider Info - Name updated to Delivery Man per requirement
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Man',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Icon(Icons.star_rounded, color: Color(0xFFFFB800), size: 16),
                        SizedBox(width: 4),
                        Text(
                          '4.8',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6),
                        Text(
                          '• Delivery Partner',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Call Button
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: pinkColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.call_rounded, color: pinkColor, size: 18),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Calling Delivery Man (+91 9876543210)...'),
                        backgroundColor: pinkColor,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              // Message Button
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: pinkColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(Icons.chat_bubble_rounded, color: pinkColor, size: 18),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Opening chat with Delivery Man...'),
                        backgroundColor: pinkColor,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, bool isDark, Color pinkColor) {
    return Consumer2<LocationProvider, AddressProvider>(
      builder: (context, locationProvider, addressProvider, _) {
        final activeAddress = addressProvider.activeAddress;
        final savedLoc = locationProvider.savedAddress;

        String label = 'Home - Calicut';
        String details = 'Dwaraka Nagar, Calicut, Kerala';

        if (activeAddress != null) {
          label = activeAddress.fields['label'] ?? 'Home';
          details = activeAddress.address.fullAddress;
        } else if (savedLoc != null) {
          label = 'Delivery Location';
          details = savedLoc.fullAddress;
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E24) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.08) : Colors.grey.shade100,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delivery Address',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: pinkColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.location_on_rounded, color: pinkColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          details,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.grey[400] : Colors.grey[600],
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Opening live map location...'),
                          backgroundColor: pinkColor,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Text(
                      'View on Map',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: pinkColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]}';
  }
}
