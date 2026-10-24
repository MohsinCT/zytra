import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/quiz_provider.dart';
import 'package:zytranow/view/screens/quiz/setting_up_space_screen.dart';

/// High-Conversion Ad Container for "evermi" Skin Quiz
/// Features the 16:9 high-resolution clean background visual asset with a REAL,
/// tactile, interactive Flutter button positioned dynamically on the container.
class QuizCtaBanner extends StatelessWidget {
  const QuizCtaBanner({super.key});

  void _navigateToQuiz(BuildContext context) {
    context.read<QuizProvider>().resetQuiz();
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SettingUpSpaceScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF2D6F).withValues(alpha: 0.16),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: AspectRatio(
          aspectRatio: 16 / 9, // Approximately 2:1 horizontal aspect ratio
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bannerWidth = constraints.maxWidth;
              // Responsive scale factor based on standard mobile width of 360px
              final scale = (bannerWidth / 360).clamp(0.8, 1.4);

              final buttonFontSize = (11.0 * scale).clamp(9.5, 14.0);
              final buttonHPad = (14.0 * scale).clamp(10.0, 20.0);
              final buttonVPad = (8.0 * scale).clamp(6.0, 12.0);
              final buttonLeft = (16.0 * scale).clamp(12.0, 24.0);
              final buttonBottom = (14.0 * scale).clamp(10.0, 22.0);

              return Stack(
                fit: StackFit.expand,
                children: [
                  // 1. High-resolution clean visual banner (button removed from image)
                  Image.asset(
                    'assets/images/quiz_cta_banner.jpg',
                    fit: BoxFit.cover,
                  ),

                  // 2. Full banner tap handler
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _navigateToQuiz(context),
                        splashColor:
                            const Color(0xFFFF2D6F).withValues(alpha: 0.1),
                        highlightColor:
                            const Color(0xFFFF2D6F).withValues(alpha: 0.05),
                      ),
                    ),
                  ),

                  // 3. Real Interactive Flutter CTA Button
                  Positioned(
                    left: buttonLeft,
                    bottom: buttonBottom,
                    child: _RealCtaButton(
                      fontSize: buttonFontSize,
                      hPad: buttonHPad,
                      vPad: buttonVPad,
                      onPressed: () => _navigateToQuiz(context),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _RealCtaButton extends StatefulWidget {
  final double fontSize;
  final double hPad;
  final double vPad;
  final VoidCallback onPressed;

  const _RealCtaButton({
    required this.fontSize,
    required this.hPad,
    required this.vPad,
    required this.onPressed,
  });

  @override
  State<_RealCtaButton> createState() => _RealCtaButtonState();
}

class _RealCtaButtonState extends State<_RealCtaButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.94 : 1.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.hPad,
            vertical: widget.vPad,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF2D6F),
                Color(0xFFFF4880),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.white,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF2D6F).withValues(alpha: 0.45),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Take the Quiz & Unlock Care Mode",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.1,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: widget.fontSize + 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
