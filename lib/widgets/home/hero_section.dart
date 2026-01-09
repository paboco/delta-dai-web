import 'dart:ui';
import 'package:flutter/material.dart';
import '../shared/app_logo.dart'; // Asegúrate de que la ruta sea correcta

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 700;

    return SizedBox(
      height: isMobile ? 600 : 650,
      width: double.infinity,
      child: Stack(
        children: [
          // 1. FONDO (Se mantiene igual)
          Positioned.fill(
            child: Image.asset(
              'assets/images/fondo.jpeg',
              fit: BoxFit.cover,
              alignment: const Alignment(0, -0.75),
            ),
          ),

          // 2. DIFUMINADO GENERAL DEL FONDO
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 4.0,
                  sigmaY: 4.0,
                ), // Un poco menos de blur general
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                        Colors.black,
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. LOGO CENTRAL CON EFECTO CRISTAL (Aquí usamos la Clase)
          Positioned(
            top: isMobile ? 140 : 180,
            left: 0,
            right: 0,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(
                        alpha: 0.1,
                      ), // Capa de claridad
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    // USAMOS LA CLASE OPTIMIZADA
                    child: AppLogo(height: isMobile ? 120 : 200),
                  ),
                ),
              ),
            ),
          ),

          // 4. TEXTOS (Se mantienen igual)
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Text(
                  "DISEÑO Y CONSTRUCCIÓN BIM",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isMobile ? 26 : 52,
                    fontWeight: FontWeight.w900,
                    shadows: const [
                      Shadow(color: Colors.black, blurRadius: 15),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Innovación y precisión en cada metro cuadrado",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: isMobile ? 16 : 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
