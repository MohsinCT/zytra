import 'package:flutter/material.dart';
import 'package:zytranow/core/constants/app_constants.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          color: context.textDark,
        ),
      ),
    );
  }
}

class SectionTitleWithAction extends StatelessWidget {
  final String title;
  final String action;
  final String? subtitle;

  const SectionTitleWithAction({
    super.key,
    required this.title,
    required this.action,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: context.textDark,
                ),
              ),
              Text(
                action,
                style: const TextStyle(
                  color: Color(0xFFFF2D6F),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 3),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: context.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
