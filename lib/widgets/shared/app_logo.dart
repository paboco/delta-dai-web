import 'package:delta_dai_bim_web/core/app_colors.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double height;
  const AppLogo({super.key, this.height = 50});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo_delta.png',
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => _buildFallbackText(),
    );
  }
}

class AppLogoNavbar extends StatelessWidget {
  final double? height; // Opcional para flexibilidad
  const AppLogoNavbar({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Si hay un height fijo (Admin), usa ese.
    // Si es nulo (Home), usa un cálculo "gradecito" (0.12 de la pantalla)
    double responsiveHeight = height ?? (screenWidth * 0.12).clamp(65.0, 110.0);

    return Image.asset(
      'assets/images/logo_delta_navbar.png',
      height: responsiveHeight,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      errorBuilder: (context, error, stackTrace) => _buildFallbackText(),
    );
  }
}

Widget _buildFallbackText() {
  return RichText(
    text: const TextSpan(
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      children: [
        TextSpan(
          text: "DELTA ",
          style: TextStyle(color: AppColors.primaryRed),
        ),
        TextSpan(
          text: "DAI ",
          style: TextStyle(color: AppColors.grey),
        ),
        TextSpan(
          text: "BIM ",
          style: TextStyle(color: AppColors.blueAccent),
        ),
      ],
    ),
  );
}
