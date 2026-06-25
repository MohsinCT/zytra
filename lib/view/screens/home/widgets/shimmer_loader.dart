import 'package:flutter/material.dart';

class ShimmerLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    final loopNotifier = ValueNotifier<int>(0);
    return ValueListenableBuilder<int>(
      valueListenable: loopNotifier,
      builder: (context, loopCount, child) {
        return TweenAnimationBuilder<double>(
          key: ValueKey(loopCount),
          tween: Tween<double>(begin: -2.0, end: 2.0),
          duration: const Duration(milliseconds: 1200),
          onEnd: () {
            loopNotifier.value = loopCount + 1;
          },
          builder: (context, value, child) {
            return Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                gradient: LinearGradient(
                  begin: Alignment(value - 1.0, -0.3),
                  end: Alignment(value + 1.0, 0.3),
                  colors: const [
                    Color(0xFFFFF2F6), // Extremely soft pink tint
                    Color(
                      0xFFFFDFEA,
                    ), // Slightly darker pink for the highlight wave
                    Color(0xFFFFF2F6), // Soft pink tint
                  ],
                  stops: const [0.35, 0.5, 0.65],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
