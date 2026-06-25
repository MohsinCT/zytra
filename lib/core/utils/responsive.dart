import 'package:flutter/widgets.dart';

class Responsive {
  final BuildContext context;
  final double width;
  final double height;
  final double devicePixelRatio;

  Responsive._(this.context)
    : width = MediaQuery.of(context).size.width,
      height = MediaQuery.of(context).size.height,
      devicePixelRatio = MediaQuery.of(context).devicePixelRatio;

  factory Responsive.of(BuildContext context) => Responsive._(context);

  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;

  /// Returns the recommended number of grid columns for product listing
  int get gridColumns {
    if (isDesktop) return 4;
    if (isTablet) return 3;
    return 2;
  }

  /// Scale a size value appropriately for the device width.
  double scale(double value) {
    // Base design width 375 -> scale relative to current width
    return value * (width / 375.0);
  }

  /// Recommended image height inside product card
  double get productImageHeight {
    if (isDesktop) return 160;
    if (isTablet) return 140;
    return 110;
  }
}
