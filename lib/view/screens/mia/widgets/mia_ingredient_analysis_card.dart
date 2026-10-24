import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/models/mia_models.dart';

/// Dynamic Card / Sheet displaying simulated Instagram post extraction
/// and parsed INCI ingredient safety breakdown.
class MiaIngredientAnalysisCard extends StatelessWidget {
  final bool isLoading;
  final String loadingStatus;
  final MiaIngredientAnalysis? analysis;
  final VoidCallback? onDismiss;
  final VoidCallback? onExploreProduct;

  const MiaIngredientAnalysisCard({
    super.key,
    required this.isLoading,
    required this.loadingStatus,
    this.analysis,
    this.onDismiss,
    this.onExploreProduct,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading && analysis == null) {
      return const SizedBox.shrink();
    }

    final isDark = context.isDark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE1306C).withValues(alpha: isDark ? 0.25 : 0.12),
            blurRadius: 30,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF1E1A27).withValues(alpha: 0.85)
                  : Colors.white.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.12)
                    : Colors.white.withValues(alpha: 0.85),
                width: 1.5,
              ),
            ),
            child: isLoading
                ? _buildExtractionLoader(context, isDark)
                : _buildParsedAnalysisContent(context, analysis!, isDark),
          ),
        ),
      ),
    );
  }

  /// Extraction loader with animated phases
  Widget _buildExtractionLoader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Instagram Gradient Ring with Spinner
          Container(
            width: 72,
            height: 72,
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
                  color: const Color(0xFFE1306C).withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? const Color(0xFF1E1A27) : Colors.white,
                ),
                child: const SpinKitRing(
                  color: Color(0xFFE1306C),
                  size: 32,
                  lineWidth: 3,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Text(
            'PARSING INSTAGRAM REEL',
            style: TextStyle(
              color: const Color(0xFFE1306C),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),

          const SizedBox(height: 8),

          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              loadingStatus,
              key: ValueKey(loadingStatus),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white : kTextDark,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            'Analyzing video frames, captions, and OCR ingredients...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: context.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Full parsed INCI ingredient analysis report
  Widget _buildParsedAnalysisContent(
    BuildContext context,
    MiaIngredientAnalysis data,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Instagram Post Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 14),
          child: Row(
            children: [
              // Instagram gradient badge
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF833AB4),
                      Color(0xFFFD1D1D),
                      Color(0xFFFCB045),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.authorHandle,
                      style: const TextStyle(
                        color: Color(0xFFE1306C),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data.postTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isDark ? Colors.white : kTextDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  onPressed: onDismiss,
                  icon: Icon(
                    Icons.close,
                    color: context.textMuted,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),

        // Safety Score & Health Metric Banner
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [
                        const Color(0xFF132A1C).withValues(alpha: 0.7),
                        const Color(0xFF0F1E28).withValues(alpha: 0.7),
                      ]
                    : [
                        const Color(0xFFE8F5E9),
                        const Color(0xFFE0F2FE),
                      ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF4ADE80).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                // Circular Safety Score Gauge
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDark ? const Color(0xFF163824) : Colors.white,
                    border: Border.all(
                      color: const Color(0xFF22C55E),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF22C55E).withValues(alpha: 0.25),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${data.overallSafetyScore.toInt()}%',
                          style: const TextStyle(
                            color: Color(0xFF16A34A),
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const Text(
                          'CLEAN',
                          style: TextStyle(
                            color: Color(0xFF16A34A),
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Dermatological Safety Score',
                        style: TextStyle(
                          color: Color(0xFF15803D),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        data.verdict,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : const Color(0xFF374151),
                          fontSize: 11,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Suitability Tags
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Wrap(
            spacing: 8,
            runSpacing: 6,
            children: data.suitabilityTags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF262132)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white12 : const Color(0xFFE5E7EB),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF10B981),
                      size: 13,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      tag.label,
                      style: TextStyle(
                        color: isDark ? Colors.white70 : const Color(0xFF374151),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        // Parsed INCI Ingredients List Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'PARSED INGREDIENT BREAKDOWN',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: context.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${data.ingredients.length} Actives Found',
                style: const TextStyle(
                  color: kPrimaryPink,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Ingredient Cards List
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: data.ingredients.map((ing) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF231F2E).withValues(alpha: 0.8)
                      : const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ing.isHero
                        ? kPrimaryPink.withValues(alpha: 0.3)
                        : (isDark ? Colors.white10 : const Color(0xFFE5E7EB)),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            runSpacing: 2,
                            children: [
                              Text(
                                ing.name,
                                style: TextStyle(
                                  color: isDark ? Colors.white : kTextDark,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (ing.isHero)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: kPrimaryPink.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'HERO',
                                    style: TextStyle(
                                      color: kPrimaryPink,
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ing.concentration,
                            style: const TextStyle(
                              color: Color(0xFF059669),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ing.purpose,
                      style: TextStyle(
                        color: isDark ? Colors.white60 : const Color(0xFF4B5563),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 10,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          'Safety: ${ing.safetyRating}',
                          style: TextStyle(
                            color: context.textMuted,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          'Comedogenic: ${ing.comedogenicRating}/5 (Non-clogging)',
                          style: const TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 14),

        // CTA Button to Explore Matched Product
        if (onExploreProduct != null && data.matchedProduct != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onExploreProduct,
                icon: const Icon(Icons.auto_awesome, size: 16),
                label: Text(
                  'Explore Formula in "${data.matchedProduct!.productName}"',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryPink,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
