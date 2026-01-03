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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
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
            constraints: const BoxConstraints(maxWidth: 800),
            child: Text(
              content,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
