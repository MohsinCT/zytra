import 'package:flutter/material.dart';
import 'package:zytranow/core/constants/app_constants.dart';

/// Shown when location permission is permanently denied or GPS is off.
///
/// Provides a branded, actionable UI that guides the user to the correct
/// system settings rather than leaving them stranded on a broken screen.
class PermissionDeniedWidget extends StatelessWidget {
  /// Primary headline — e.g. "Location Access Denied".
  final String title;

  /// Explanatory body text.
  final String message;

  /// Label for the primary action button (e.g. "Open Settings").
  final String actionLabel;

  /// Callback when the user taps the primary action button.
  final VoidCallback onActionTap;

  /// Optional secondary link label (e.g. "Enter address manually").
  final String? secondaryLabel;

  /// Optional callback for secondary action.
  final VoidCallback? onSecondaryTap;

  const PermissionDeniedWidget({
    super.key,
    required this.title,
    required this.message,
    required this.actionLabel,
    required this.onActionTap,
    this.secondaryLabel,
    this.onSecondaryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kSpacingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon container
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: kPrimaryPinkFaint,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_off_rounded,
                color: kPrimaryPink,
                size: 40,
              ),
            ),
            const SizedBox(height: kSpacingLG),

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kTextDark,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: kSpacingSM),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: kTextMuted, height: 1.55),
            ),
            const SizedBox(height: kSpacingXL),

            // Primary action button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: onActionTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryPink,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kRadiusLG),
                  ),
                ),
                child: Text(
                  actionLabel,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
            ),

            // Optional secondary action
            if (secondaryLabel != null && onSecondaryTap != null) ...[
              const SizedBox(height: kSpacingMD),
              GestureDetector(
                onTap: onSecondaryTap,
                child: Text(
                  secondaryLabel!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: kPrimaryPink,
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                    decorationColor: kPrimaryPink,
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
