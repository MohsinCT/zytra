import 'package:flutter/material.dart';
import 'package:zytranow/core/constants/app_constants.dart';

/// Full-screen loading overlay shown while the Google Maps widget is
/// initialising or while a location / geocoding request is in progress.
///
/// Renders above the map using a [Stack] so the map itself still loads
/// underneath and the overlay fades away cleanly once ready.
class MapLoadingOverlay extends StatelessWidget {
  /// Message displayed below the spinner.
  final String message;

  const MapLoadingOverlay({
    super.key,
    this.message = 'Finding your location…',
  });

  @override
  Widget build(BuildContext context) {
    final scaleNotifier = ValueNotifier<double>(1.1);

    return Container(
      color: Colors.white.withValues(alpha: 0.92),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pulsing Zytra icon
            ValueListenableBuilder<double>(
              valueListenable: scaleNotifier,
              builder: (context, scaleVal, child) {
                return TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: scaleVal == 1.1 ? 0.9 : 1.1, end: scaleVal),
                  duration: const Duration(milliseconds: 1200),
                  curve: Curves.easeInOut,
                  onEnd: () {
                    scaleNotifier.value = scaleVal == 1.1 ? 0.9 : 1.1;
                  },
                  builder: (context, val, child) {
                    return Transform.scale(
                      scale: val,
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: kPrimaryPinkFaint,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: kPrimaryPink.withValues(alpha: 0.25),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.shopping_bag_rounded,
                          color: kPrimaryPink,
                          size: 34,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: kSpacingLG),

            // Spinner
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryPink),
              ),
            ),
            const SizedBox(height: kSpacingMD),

            // Message
            Text(
              message,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kTextDark,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: kSpacingXS),
            Text(
              'This may take a few seconds',
              style: TextStyle(
                fontSize: 12,
                color: kTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
