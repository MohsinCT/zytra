import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/models/mia_models.dart';

/// Persistent Hybrid Input Bar supporting animated Voice Mode and Silent Chat Mode.
class MiaHybridInputBar extends StatefulWidget {
  final MiaInteractionMode mode;
  final bool isListening;
  final TextEditingController textController;
  final FocusNode focusNode;
  final VoidCallback onToggleVoice;
  final ValueChanged<String> onTextChanged;
  final ValueChanged<String> onSubmitText;
  final VoidCallback onPasteInstagram;
  final ValueChanged<String> onQuickVoiceTrigger;

  const MiaHybridInputBar({
    super.key,
    required this.mode,
    required this.isListening,
    required this.textController,
    required this.focusNode,
    required this.onToggleVoice,
    required this.onTextChanged,
    required this.onSubmitText,
    required this.onPasteInstagram,
    required this.onQuickVoiceTrigger,
  });

  @override
  State<MiaHybridInputBar> createState() => _MiaHybridInputBarState();
}

class _MiaHybridInputBarState extends State<MiaHybridInputBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _micPulseController;
  late Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();
    _micPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _pulseScale = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(
        parent: _micPulseController,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isListening) {
      _micPulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant MiaHybridInputBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening && !oldWidget.isListening) {
      _micPulseController.repeat(reverse: true);
    } else if (!widget.isListening && oldWidget.isListening) {
      _micPulseController.stop();
      _micPulseController.reset();
    }
  }

  @override
  void dispose() {
    _micPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Horizontal Quick Voice / Action Simulation Pills (for effortless testing)
        SizedBox(
          height: 38,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: [
              _buildQuickPill(
                icon: Icons.mic_rounded,
                text: 'Night-party lipsticks',
                onTap: () =>
                    widget.onQuickVoiceTrigger('Night-party lipsticks'),
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildQuickPill(
                icon: Icons.auto_awesome,
                text: 'Show me Honey Shade',
                onTap: () =>
                    widget.onQuickVoiceTrigger('Show me Honey Shade'),
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildQuickPill(
                icon: Icons.auto_awesome,
                text: 'Switch to Berry Burst',
                onTap: () =>
                    widget.onQuickVoiceTrigger('Switch to Berry Burst'),
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildQuickPill(
                icon: Icons.auto_awesome,
                text: 'Switch to Ruby Velvet',
                onTap: () =>
                    widget.onQuickVoiceTrigger('Switch to Ruby Velvet'),
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildQuickPill(
                icon: Icons.content_paste_rounded,
                text: 'Paste IG Reel',
                onTap: widget.onPasteInstagram,
                isDark: isDark,
                accentColor: const Color(0xFFE1306C),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Floating Glassmorphic Hybrid Bar
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF181522).withValues(alpha: 0.82)
                      : Colors.white.withValues(alpha: 0.88),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.15)
                        : Colors.white.withValues(alpha: 0.9),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // 1. Animated Mic Button (Voice Mode Trigger)
                    _buildAnimatedMicButton(isDark),

                    const SizedBox(width: 8),

                    // 2. Clean Text Field (Typing switches to Silent Mode)
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF231F30).withValues(alpha: 0.6)
                              : const Color(0xFFF3F4F6).withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isDark
                                ? Colors.white10
                                : const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: widget.textController,
                          builder: (context, value, _) {
                            final hasText = value.text.trim().isNotEmpty;

                            return TextField(
                              controller: widget.textController,
                              focusNode: widget.focusNode,
                              onChanged: widget.onTextChanged,
                              onSubmitted: widget.onSubmitText,
                              style: TextStyle(
                                color: isDark ? Colors.white : kTextDark,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: widget.mode == MiaInteractionMode.voice
                                    ? 'Type to enter Silent Mode...'
                                    : 'Ask Mia, shades, or paste link...',
                                hintStyle: TextStyle(
                                  color: context.textMuted,
                                  fontSize: 13,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                suffixIcon: hasText
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.arrow_upward_rounded,
                                          color: kPrimaryPink,
                                          size: 20,
                                        ),
                                        onPressed: () => widget.onSubmitText(
                                          widget.textController.text,
                                        ),
                                      )
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // 3. Clipboard Paste Button for Instagram Links
                    _buildInstagramPasteButton(isDark),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedMicButton(bool isDark) {
    return AnimatedBuilder(
      animation: _micPulseController,
      builder: (context, child) {
        final scale = widget.isListening ? _pulseScale.value : 1.0;

        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: widget.onToggleVoice,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: widget.isListening
                    ? const LinearGradient(
                        colors: [Color(0xFFFF2D6F), Color(0xFFFF5E8F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : (isDark
                        ? LinearGradient(
                            colors: [
                              const Color(0xFF2C2538),
                              const Color(0xFF201B2B),
                            ],
                          )
                        : const LinearGradient(
                            colors: [
                              Color(0xFFFFF0F5),
                              Color(0xFFFFE4EC),
                            ],
                          )),
                boxShadow: widget.isListening
                    ? [
                        BoxShadow(
                          color: kPrimaryPink.withValues(alpha: 0.6),
                          blurRadius: 16,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
                border: Border.all(
                  color: widget.isListening
                      ? Colors.white
                      : kPrimaryPink.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
              child: Icon(
                widget.isListening ? Icons.graphic_eq_rounded : Icons.mic_rounded,
                color: widget.isListening
                    ? Colors.white
                    : kPrimaryPink,
                size: 22,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInstagramPasteButton(bool isDark) {
    return Tooltip(
      message: 'Paste Instagram Link for INCI Analysis',
      child: GestureDetector(
        onTap: widget.onPasteInstagram,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [
                Color(0xFF833AB4),
                Color(0xFFFD1D1D),
                Color(0xFFFCB045),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE1306C).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.content_paste_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickPill({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required bool isDark,
    Color? accentColor,
  }) {
    final color = accentColor ?? kPrimaryPink;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF221C2B).withValues(alpha: 0.8)
                  : Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 14, color: color),
                const SizedBox(width: 6),
                Text(
                  text,
                  style: TextStyle(
                    color: isDark ? Colors.white : kTextDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
