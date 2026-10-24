import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/auth_provider.dart';
import 'package:zytranow/controllers/carousel_provider.dart';
import 'package:zytranow/view/screens/main_screen.dart';

class LoginScreen extends StatelessWidget {
  final VoidCallback? onLoginSuccess;

  const LoginScreen({super.key, this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final carousel = context.watch<CarouselProvider>();
    final canPop = Navigator.canPop(context);
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final bottomInset = mediaQuery.viewInsets.bottom;
    final bottomPadding = bottomInset > 0
        ? 16.0
        : (mediaQuery.padding.bottom + 20.0);

    // Carousel spans the upper ~62% of the screen with a seamless fade
    final carouselHeight = screenHeight * 0.62;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // ─── 1. Background Carousel Layer ─────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: carouselHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Full-width PageView carousel rendered with CachedNetworkImage
                PageView.builder(
                  controller: carousel.pageController,
                  itemCount: carousel.images.length,
                  onPageChanged: carousel.setIndex,
                  itemBuilder: (context, index) {
                    return CachedNetworkImage(
                      imageUrl: carousel.images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFFF3F4F6),
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Color(0xFFFF2D6F),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFFE5E7EB),
                        child: const Center(
                          child: Icon(
                            Icons.broken_image_rounded,
                            color: Colors.black26,
                            size: 40,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Top & Bottom Overlay Gradients
                // Top gradient guarantees high contrast for "Skip >" and back buttons.
                // Bottom vertical gradient smoothly fades into the white content card.
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.40),
                          Colors.black.withValues(alpha: 0.10),
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.75),
                          Colors.white,
                        ],
                        stops: const [0.0, 0.22, 0.50, 0.85, 1.0],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── 2. Foreground Interactive Layer ──────────────────────────
          Positioned.fill(
            child: SafeArea(
              bottom: false,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            // Top Action Bar (Skip > & Back button)
                            _buildTopBar(context, canPop),

                            const Spacer(),

                            // Subtle Animated Page Indicator (Dots) near transition area
                            _buildPageIndicator(carousel),

                            const SizedBox(height: 16),

                            // Pinned Elevated Bottom Content Card
                            _buildBottomCard(
                              context,
                              auth: auth,
                              bottomPadding: bottomPadding,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Top action bar with back button (if canPop) and high-contrast "Skip >" pill button.
  Widget _buildTopBar(BuildContext context, bool canPop) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (canPop)
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.08),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black87,
                  size: 16,
                ),
              ),
            )
          else
            const SizedBox.shrink(),
          GestureDetector(
            onTap: () {
              if (canPop) {
                Navigator.pop(context);
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainScreen()),
                  (route) => false,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.94),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFFFF2D6F).withValues(alpha: 0.25),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFF2D6F),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 11,
                    color: Color(0xFFFF2D6F),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Subtle animated page indicator dots positioned subtly near the content transition area.
  Widget _buildPageIndicator(CarouselProvider carousel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(carousel.images.length, (index) {
        final isSelected = carousel.currentIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isSelected ? 22 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFFF2D6F)
                : Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFFF2D6F)
                  : Colors.black.withValues(alpha: 0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected
                    ? const Color(0xFFFF2D6F).withValues(alpha: 0.40)
                    : Colors.black.withValues(alpha: 0.10),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        );
      }),
    );
  }

  /// Pinned bottom white container / card housing the login elements.
  Widget _buildBottomCard(
    BuildContext context, {
    required AuthProvider auth,
    required double bottomPadding,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(24, 28, 24, bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // App circular logo (Pink circle with 'e' icon)
          _buildAppLogo(),

          const SizedBox(height: 18),

          // Primary headline
          const Text(
            "Evermi AI - Smart Decision Care",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
              height: 1.25,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          const Text(
            "Log in or sign up",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8A8A9A),
              letterSpacing: 0.1,
            ),
          ),

          const SizedBox(height: 28),

          // Mobile number input container
          _buildPhoneInputField(auth),

          const SizedBox(height: 20),

          // Primary CTA button: High-contrast pink rounded button
          _buildContinueButton(context, auth),
        ],
      ),
    );
  }

  /// Pink circular brand logo with 'e' icon
  Widget _buildAppLogo() {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFF2D6F),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF2D6F).withValues(alpha: 0.32),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/images/evermi_logo.png',
          width: 76,
          height: 76,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Text(
              'e',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontFamily: 'Inter',
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Mobile number input container (+91 | Enter mobile number)
  Widget _buildPhoneInputField(AuthProvider auth) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "+91",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E),
              ),
            ),
          ),
          Container(width: 1, height: 24, color: const Color(0xFFE5E7EB)),
          Expanded(
            child: TextField(
              controller: auth.phoneController,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
                letterSpacing: 0.8,
              ),
              decoration: const InputDecoration(
                hintText: "Enter mobile number",
                hintStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF9CA3AF),
                  letterSpacing: 0,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// High-contrast pink rounded action button labeled "Continue"
  Widget _buildContinueButton(BuildContext context, AuthProvider auth) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () => auth.validatePhone(context, onSuccess: onLoginSuccess),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF2D6F),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: const Color(0xFFFF2D6F).withValues(alpha: 0.35),
        ),
        child: const Text(
          "Continue",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
