import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class InfoSection extends StatelessWidget {
  final String title;
  final String content;
  final Color backgroundColor;

  const InfoSection({
    super.key,
    required this.title,
    required this.content,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isDesktop = size.width > 900;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: 80,
        horizontal: isDesktop ? size.width * 0.2 : 25,
      ),
      color: backgroundColor,
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryRed,
            ),
          ),
          const SizedBox(height: 20),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                height: 1.8,
                color: AppColors.greyDark,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
