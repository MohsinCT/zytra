import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/mia_provider.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/models/mia_models.dart';
import 'package:zytranow/view/screens/mia/widgets/mia_hybrid_input_bar.dart';
import 'package:zytranow/view/screens/mia/widgets/mia_ingredient_analysis_card.dart';
import 'package:zytranow/view/screens/mia/widgets/mia_product_canvas_card.dart';
import 'package:zytranow/view/screens/mia/widgets/mia_silent_chat_view.dart';
import 'package:zytranow/view/screens/mia/widgets/mia_voice_ripple_overlay.dart';

/// Master screen for "Mia" — AI retail decision engine prototype.
/// Features iOS glassmorphic aesthetics, zero-touch voice simulation,
/// and Instagram link ingredient extraction.
class MiaScreen extends StatelessWidget {
  final double? bottomOffset;

  const MiaScreen({
    super.key,
    this.bottomOffset,
  });

  @override
  Widget build(BuildContext context) {
    final mia = context.watch<MiaProvider>();
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0D14) : const Color(0xFFF9FAFC),
      extendBody: true,
      body: Stack(
        children: [
          // ─── Ambient Glassmorphic Background Glowing Gradients ────────────
          _buildAmbientBackground(context, isDark),

          // ─── Main Content Canvas ──────────────────────────────────────────
          SafeArea(
            bottom: false,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  children: [
                    // Top Glass Navigation Bar
                    _buildTopBar(context, mia, isDark),

                    // Main Interactive Canvas
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: mia.mode == MiaInteractionMode.voice
                            ? _buildVoiceCanvas(context, mia, isDark)
                            : _buildSilentChatCanvas(context, mia),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ─── Persistent Bottom Hybrid Input Bar ───────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: bottomOffset ?? (MediaQuery.of(context).padding.bottom + 8),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: MiaHybridInputBar(
              mode: mia.mode,
              isListening: mia.isListening,
              textController: mia.textController,
              focusNode: mia.focusNode,
              onToggleVoice: mia.toggleListening,
              onTextChanged: mia.onTextInputChanged,
              onSubmitText: mia.submitTextQuery,
              onPasteInstagram: mia.pasteAndParseInstagramFromClipboard,
              onQuickVoiceTrigger: mia.simulateVoiceTrigger,
            ),
          ),
        ),
      ),
    ],
  ),
);
  }

  /// Ambient decorative glow orbs behind glass panels
  Widget _buildAmbientBackground(BuildContext context, bool isDark) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Top Left Magenta Glow Orb
          Positioned(
            top: -60,
            left: -40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kPrimaryPink.withValues(alpha: isDark ? 0.22 : 0.12),
              ),
            ),
          ),

          // Top Right Violet Glow Orb
          Positioned(
            top: 40,
            right: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF7928CA).withValues(
                  alpha: isDark ? 0.18 : 0.08,
                ),
              ),
            ),
          ),

          // Center Ambient Glow (morphs with active shade if available)
          Consumer<MiaProvider>(
            builder: (context, mia, child) {
              final activeColor = mia.activeProduct?.activeShade.color ?? kPrimaryPink;
              return Positioned(
                bottom: 120,
                left: 20,
                right: 20,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: activeColor.withValues(
                      alpha: isDark ? 0.12 : 0.06,
                    ),
                  ),
                ),
              );
            },
          ),

          // Blur filter over background
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
            child: const SizedBox.expand(),
          ),
        ],
      ),
    );
  }

  /// Top Glass Navigation Bar with Mode Selector & Reset Trigger
  Widget _buildTopBar(BuildContext context, MiaProvider mia, bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isVeryCompact = constraints.maxWidth < 360;
        final isCompact = constraints.maxWidth < 420;

        return Padding(
          padding: EdgeInsets.fromLTRB(
            isVeryCompact ? 8 : (isCompact ? 10 : 16),
            8,
            isVeryCompact ? 8 : (isCompact ? 10 : 16),
            8,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isVeryCompact ? 8 : (isCompact ? 10 : 14),
                  vertical: isVeryCompact ? 6 : (isCompact ? 8 : 10),
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF1C1827).withValues(alpha: 0.75)
                      : Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : Colors.white.withValues(alpha: 0.9),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Back button (when pushed onto navigator)
                    if (Navigator.canPop(context)) ...[
                      SizedBox(
                        width: isVeryCompact ? 28 : 32,
                        height: isVeryCompact ? 28 : 32,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(
                            minWidth: isVeryCompact ? 28 : 32,
                            minHeight: isVeryCompact ? 28 : 32,
                          ),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: isDark ? Colors.white : kTextDark,
                            size: isVeryCompact ? 14 : 16,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 3),
                    ],

                    // Mia AI Brand Capsule Avatar
                    Container(
                      width: isVeryCompact ? 28 : (isCompact ? 32 : 36),
                      height: isVeryCompact ? 28 : (isCompact ? 32 : 36),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF2D6F), Color(0xFFFF5E8F)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryPink.withValues(alpha: 0.4),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.auto_awesome,
                          color: Colors.white,
                          size: isVeryCompact ? 14 : (isCompact ? 16 : 18),
                        ),
                      ),
                    ),
                    SizedBox(width: isVeryCompact ? 5 : (isCompact ? 6 : 10)),

                    // Title & Live Status
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Mia AI',
                                  style: TextStyle(
                                    color: isDark ? Colors.white : kTextDark,
                                    fontSize: isVeryCompact ? 13 : (isCompact ? 13.5 : 15),
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF00E676),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF00E676).withValues(alpha: 0.7),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              mia.mode == MiaInteractionMode.voice
                                  ? 'Voice Engine'
                                  : 'Silent Chat',
                              style: TextStyle(
                                color: context.textMuted,
                                fontSize: isVeryCompact ? 9.5 : (isCompact ? 10 : 11),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: isVeryCompact ? 3 : (isCompact ? 4 : 8)),

                    // Mode Toggle Capsule (Voice vs Silent)
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2B2538)
                                : const Color(0xFFF1F2F6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _buildModeSegment(
                                context,
                                title: 'Voice',
                                icon: Icons.mic_rounded,
                                isSelected: mia.mode == MiaInteractionMode.voice,
                                onTap: () => mia.setMode(MiaInteractionMode.voice),
                                isDark: isDark,
                                isCompact: isCompact,
                                isVeryCompact: isVeryCompact,
                              ),
                              _buildModeSegment(
                                context,
                                title: 'Chat',
                                icon: Icons.chat_bubble_outline_rounded,
                                isSelected: mia.mode == MiaInteractionMode.silent,
                                onTap: () => mia.setMode(MiaInteractionMode.silent),
                                isDark: isDark,
                                isCompact: isCompact,
                                isVeryCompact: isVeryCompact,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: isVeryCompact ? 3 : (isCompact ? 4 : 6)),

                    // Reset canvas button
                    SizedBox(
                      width: isVeryCompact ? 26 : 28,
                      height: isVeryCompact ? 26 : 28,
                      child: IconButton(
                        tooltip: 'Reset Engine Canvas',
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(
                          minWidth: isVeryCompact ? 26 : 28,
                          minHeight: isVeryCompact ? 26 : 28,
                        ),
                        icon: Icon(
                          Icons.refresh_rounded,
                          color: context.textMuted,
                          size: isVeryCompact ? 16 : 18,
                        ),
                        onPressed: mia.resetCanvas,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildModeSegment(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
    bool isCompact = false,
    bool isVeryCompact = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: isVeryCompact ? 5.5 : (isCompact ? 7 : 10),
          vertical: isVeryCompact ? 4 : (isCompact ? 4.5 : 6),
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? kPrimaryPink : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: isVeryCompact ? 11 : (isCompact ? 12 : 13),
              color: isSelected
                  ? (isDark ? Colors.white : kPrimaryPink)
                  : context.textMuted,
            ),
            SizedBox(width: isVeryCompact ? 2.5 : 3.5),
            Text(
              title,
              style: TextStyle(
                color: isSelected
                    ? (isDark ? Colors.white : kPrimaryPink)
                    : context.textMuted,
                fontSize: isVeryCompact ? 9.5 : (isCompact ? 10 : 11),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Voice Canvas: Zero-Touch dynamic visual cards framework
  Widget _buildVoiceCanvas(
    BuildContext context,
    MiaProvider mia,
    bool isDark,
  ) {
    return SingleChildScrollView(
      key: const ValueKey('voice_canvas'),
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        bottom:
            (bottomOffset ?? (MediaQuery.of(context).padding.bottom + 8)) + 140,
      ),
      child: Column(
        children: [
          // Voice Ripple Animation Banner (when microphone is listening)
          MiaVoiceRippleOverlay(
            isListening: mia.isListening,
            isTranscribing: mia.isTranscribing,
            transcriptionText: mia.transcriptionText,
            onCancel: mia.stopListening,
          ),

          // Instagram extraction in-progress or parsed card
          if (mia.isParsingInstagram || mia.activeIngredientAnalysis != null)
            MiaIngredientAnalysisCard(
              isLoading: mia.isParsingInstagram,
              loadingStatus: mia.instagramExtractionStatus,
              analysis: mia.activeIngredientAnalysis,
              onDismiss: mia.clearIngredientAnalysis,
              onExploreProduct: () {
                if (mia.activeIngredientAnalysis?.matchedProduct != null) {
                  // Scroll to product or switch active product
                  mia.switchShade(0);
                }
              },
            ),

          // Dynamic Product Card from mock JSON state
          if (mia.activeProduct != null)
            MiaProductCanvasCard(
              product: mia.activeProduct!,
              onSelectShade: mia.switchShade,
              onVoiceTrigger: mia.simulateVoiceTrigger,
            ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Silent Chat Mode Canvas
  Widget _buildSilentChatCanvas(BuildContext context, MiaProvider mia) {
    return MiaSilentChatView(
      key: const ValueKey('silent_chat_canvas'),
      messages: mia.messages,
      isAITyping: mia.isAITyping,
      bottomPadding:
          (bottomOffset ?? (MediaQuery.of(context).padding.bottom + 8)) + 140,
      onSelectShade: (index) => mia.switchShade(index, fromVoice: false),
      onVoiceTrigger: mia.simulateVoiceTrigger,
      onFollowUpTap: mia.submitTextQuery,
    );
  }
}
