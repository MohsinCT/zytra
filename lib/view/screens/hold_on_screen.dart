import 'package:flutter/material.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/view/screens/order_success_screen.dart';

class HoldOnScreen extends StatelessWidget {
  final int itemCount;
  final double grandTotal;

  const HoldOnScreen({
    super.key,
    required this.itemCount,
    required this.grandTotal,
  });

  void _scheduleNavigation(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 3), () {
        if (context.mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  OrderSuccessScreen(grandTotal: grandTotal),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _scheduleNavigation(context);

    final isDarkMode = context.isDark;
    const pinkColor = kPrimaryPink;

    return PopScope(
      canPop: false, // Prevents back navigation during processing
      child: Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF121212) : Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  color: isDarkMode ? Colors.white : Colors.black87,
                  size: 18,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PROCESSING ORDER',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$itemCount ${itemCount == 1 ? 'item' : 'items'} • Total: ₹${grandTotal.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Spacer(),
                          // Custom circular loader inside pink container with glowing shadow
                          Center(
                            child: Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                color: pinkColor.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: pinkColor.withValues(alpha: 0.1),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                              child: SizedBox(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator(
                                  strokeWidth: 6,
                                  valueColor: const AlwaysStoppedAnimation<Color>(pinkColor),
                                  backgroundColor: pinkColor.withValues(alpha: 0.15),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 48),
                          // Main text block
                          Text(
                            'Hold On...',
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : const Color(0xFF1A1A2E),
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'We are securing your order and preparing your superfast delivery.',
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey[400] : const Color(0xFF6E6E80),
                                fontSize: 14,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const Spacer(),
                          // Footer note
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isDarkMode
                                      ? Colors.white.withValues(alpha: 0.1)
                                      : Colors.grey.shade200,
                                ),
                              ),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.4,
                                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: 'Note: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: pinkColor,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Please do not press back or close the app while we process your request.',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
