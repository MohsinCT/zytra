import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zytranow/core/constants/app_constants.dart';

/// Glowing ripple animation overlay & audio waveform visualizer for Mia Voice Mode.
class MiaVoiceRippleOverlay extends StatefulWidget {
  final bool isListening;
  final bool isTranscribing;
  final String transcriptionText;
  final VoidCallback onCancel;

  const MiaVoiceRippleOverlay({
    super.key,
    required this.isListening,
    required this.isTranscribing,
    required this.transcriptionText,
    required this.onCancel,
  });

  @override
  State<MiaVoiceRippleOverlay> createState() => _MiaVoiceRippleOverlayState();
}

class _MiaVoiceRippleOverlayState extends State<MiaVoiceRippleOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isListening && !widget.isTranscribing) {
      return const SizedBox.shrink();
    }

    final isDark = context.isDark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [
                      const Color(0xFF2A101C).withValues(alpha: 0.85),
                      const Color(0xFF151020).withValues(alpha: 0.85),
                    ]
                  : [
                      const Color(0xFFFFF0F5).withValues(alpha: 0.92),
                      const Color(0xFFF7EBF8).withValues(alpha: 0.92),
                    ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: kPrimaryPink.withValues(alpha: 0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: kPrimaryPink.withValues(alpha: 0.18),
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ripple Circles & Mic Aura
              SizedBox(
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Concentric expanding ripple rings
                    _buildRippleRing(radius: 65, progressOffset: 0.0),
                    _buildRippleRing(radius: 50, progressOffset: 0.33),
                    _buildRippleRing(radius: 35, progressOffset: 0.66),

                    // Central glowing pulsating orb
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF2D6F), Color(0xFFFF5E8F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryPink.withValues(alpha: 0.5),
                            blurRadius: 16,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.mic,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Animated Sound Wave Bars
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(16, (i) {
                    final phase = (i * 0.35) + (_controller.value * 2 * math.pi);
                    final waveHeight = 8 + (math.sin(phase).abs() * 22);
                    return Container(
                      width: 3.5,
                      height: waveHeight,
                      margin: const EdgeInsets.symmetric(horizontal: 2.2),
                      decoration: BoxDecoration(
                        color: kPrimaryPink.withValues(
                          alpha: 0.4 + (waveHeight / 30.0) * 0.6,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 12),

              // Real-time live transcript display
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    widget.transcriptionText,
                    key: ValueKey<String>(widget.transcriptionText),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isDark ? Colors.white : kTextDark,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Subtitle hint
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00E676),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Listening for product or shade requests...',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: context.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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

  Widget _buildRippleRing({
    required double radius,
    required double progressOffset,
  }) {
    final effectiveProgress = (_controller.value + progressOffset) % 1.0;
    final scale = 0.6 + (effectiveProgress * 0.6);
    final opacity = (1.0 - effectiveProgress).clamp(0.0, 1.0);

    return Transform.scale(
      scale: scale,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: kPrimaryPink.withValues(alpha: opacity * 0.45),
            width: 1.5,
          ),
          color: kPrimaryPink.withValues(alpha: opacity * 0.08),
        ),
      ),
    );
  }
}
