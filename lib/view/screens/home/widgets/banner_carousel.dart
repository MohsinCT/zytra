import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zytranow/controllers/home_provider.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final homeProvider = context.watch<HomeProvider>();

    if (homeProvider.banners.isEmpty) return const SizedBox();

    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: homeProvider.bannerController,
            onPageChanged: homeProvider.setBannerIndex,
            itemCount: homeProvider.banners.length,
            itemBuilder: (context, index) {
              final banner = homeProvider.banners[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF2D6F).withValues(alpha: 0.25),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Stack(
                    children: [
                      // 1. Background image (if available)
                      if (banner.backgroundImage != null)
                        Positioned.fill(
                          child: banner.backgroundImage!.startsWith('http')
                              ? Image.network(
                                  banner.backgroundImage!,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  banner.backgroundImage!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      // 2. Gradient overlay to ensure text contrast and maintain brand color
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: banner.backgroundImage != null
                                  ? [
                                      const Color(
                                        0xFFFF2D6F,
                                      ).withValues(alpha: 0.85),
                                      const Color(
                                        0xFFFF5E8F,
                                      ).withValues(alpha: 0.45),
                                    ]
                                  : [
                                      const Color(0xFFFF2D6F),
                                      const Color(0xFFFF5E8F),
                                    ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                      // 3. Banner contents
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.25,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      banner.category.toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    banner.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              banner.icon,
                              color: Colors.white.withValues(alpha: 0.9),
                              size: 56,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            homeProvider.banners.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: homeProvider.currentBannerIndex == index ? 24 : 6,
              decoration: BoxDecoration(
                color: homeProvider.currentBannerIndex == index
                    ? const Color(0xFFFF2D6F)
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
