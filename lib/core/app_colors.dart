import 'package:flutter/material.dart';

class AppColors {
  // Tu rojo corporativo
  static const Color primaryRed = Color(0xFFAC1C1C);
  // Fondo de secciones claras (como usabas en el código anterior)
  static const Color bgLight = Color(0xFFF9F9F9);
  static const Color white = Colors.white;
  static const Color black = Color(0xFF121212);
  static const Color grey = Color(0xFF757575);
  static const Color blueAccent = Colors.blueAccent;
  static const Color greyDark = Color(0xFF424242);
  static const Color lightGrey = Color.fromARGB(255, 114, 24, 24);
  static const Color blackgray = Color.fromARGB(0, 100, 98, 98);
}

class AppStyles {
  // El sombreado (Shadow) que querías
  static List<BoxShadow> standardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 200),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  // Estilo de botón reutilizable
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryRed,
    foregroundColor: Colors.white,
    elevation: 5, // Sombreado automático de Flutter
    shadowColor: Colors.black.withValues(alpha: 128),
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
