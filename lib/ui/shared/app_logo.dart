import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double height;
  const AppLogo({super.key, this.height = 50});
  @override
  Widget build(BuildContext context) => Image.asset(
    'assets/images/logo_delta.png',
    height: height,
    errorBuilder: (_, __, ___) => _fallback(),
  );
}

class AppLogoNavbar extends StatelessWidget {
  final double? height;
  const AppLogoNavbar({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    // Mantengo tu lógica de tamaño que es muy buena
    double h =
        height ?? (MediaQuery.of(context).size.width * 0.12).clamp(65.0, 110.0);

    return Container(
      // CLAVE 1: Fuerza la alineación a la izquierda dentro del espacio asignado
      alignment: Alignment.centerLeft,
      child: Image.asset(
        'assets/images/logo_delta_navbar.png',
        height: h,
        // CLAVE 2: Asegura que la imagen mantenga su forma sin recortes fantasma
        fit: BoxFit.contain,
        filterQuality: FilterQuality.high,
        errorBuilder: (_, __, ___) => _fallback(),
      ),
    );
  }
}

Widget _fallback() => const Text(
  "DELTA DAI BIM",
  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryRed),
);
