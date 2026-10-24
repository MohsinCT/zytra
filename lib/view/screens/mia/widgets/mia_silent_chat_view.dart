import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zytranow/core/constants/app_constants.dart';
import 'package:zytranow/models/mia_models.dart';
import 'package:zytranow/view/screens/mia/widgets/mia_ingredient_analysis_card.dart';
import 'package:zytranow/view/screens/mia/widgets/mia_product_canvas_card.dart';

/// Silent Chat Mode view rendering conversation history and inline dynamic cards.
class MiaSilentChatView extends StatelessWidget {
  final List<MiaMessage> messages;
  final bool isAITyping;
  final ValueChanged<int> onSelectShade;
  final ValueChanged<String> onVoiceTrigger;
  final ValueChanged<String> onFollowUpTap;

  final double? bottomPadding;

  const MiaSilentChatView({
    super.key,
    required this.messages,
    required this.isAITyping,
    required this.onSelectShade,
    required this.onVoiceTrigger,
    required this.onFollowUpTap,
    this.bottomPadding,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottomPadding ?? 180),
      itemCount: messages.length + (isAITyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && isAITyping) {
          return _buildTypingIndicator(context, isDark);
        }

        final msg = messages[index];
        return _buildMessageItem(context, msg, isDark);
      },
    );
  }

  Widget _buildMessageItem(
    BuildContext context,
    MiaMessage msg,
    bool isDark,
  ) {
    final isUser = msg.sender == MiaSender.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment:
            isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Speech Bubble
          Row(
            mainAxisAlignment:
                isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                // Mia Avatar
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF2D6F), Color(0xFFFF5E8F)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryPink.withValues(alpha: 0.3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.auto_awesome,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20),
                    bottomLeft: Radius.circular(isUser ? 20 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 20),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? kPrimaryPink
                            : (isDark
                                ? const Color(0xFF241F30).withValues(alpha: 0.85)
                                : Colors.white.withValues(alpha: 0.9)),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: Radius.circular(isUser ? 20 : 4),
                          bottomRight: Radius.circular(isUser ? 4 : 20),
                        ),
                        border: Border.all(
                          color: isUser
                              ? Colors.transparent
                              : (isDark
                                  ? Colors.white12
                                  : Colors.white.withValues(alpha: 0.9)),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.25 : 0.04,
                            ),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: isUser
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          if (msg.isVoice)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.mic,
                                    size: 12,
                                    color: isUser
                                        ? Colors.white70
                                        : kPrimaryPink,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Voice Query',
                                    style: TextStyle(
                                      color: isUser
                                          ? Colors.white70
                                          : kPrimaryPink,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Text(
                            msg.text,
                            style: TextStyle(
                              color: isUser
                                  ? Colors.white
                                  : (isDark ? Colors.white : kTextDark),
                              fontSize: 14,
                              height: 1.35,
                              fontWeight:
                                  isUser ? FontWeight.w500 : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Inline dynamic product card if attached to this response
          if (msg.product != null) ...[
            const SizedBox(height: 10),
            MiaProductCanvasCard(
              product: msg.product!,
              onSelectShade: onSelectShade,
              onVoiceTrigger: onVoiceTrigger,
            ),
          ],

          // Inline dynamic ingredient analysis if attached to this response
          if (msg.ingredientAnalysis != null) ...[
            const SizedBox(height: 10),
            MiaIngredientAnalysisCard(
              isLoading: false,
              loadingStatus: '',
              analysis: msg.ingredientAnalysis,
            ),
          ],

          // Follow-up suggestion chips
          if (msg.suggestedFollowUps.isNotEmpty) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: msg.suggestedFollowUps.map((chipText) {
                  return GestureDetector(
                    onTap: () => onFollowUpTap(chipText),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF282236)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: kPrimaryPink.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        chipText,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : kPrimaryPink,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryPink,
            ),
            child: const Center(
              child: Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF241F30) : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: LoadingAnimationWidget.waveDots(
              color: kPrimaryPink,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
