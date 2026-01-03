import 'package:delta_dai_bim_/core/app_colors.dart';
import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double height;

  const AppLogo({super.key, this.height = 50});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/logo_delta.png', // Solo cambias esta ruta aquí
      height: height,
      fit: BoxFit.contain,
      // Esto evita que la app truene si el archivo no existe aún
      errorBuilder: (context, error, stackTrace) {
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
      },
    );
  }
}
