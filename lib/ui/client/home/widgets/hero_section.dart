import 'package:flutter/material.dart';
import '../../../shared/app_logo.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});
  @override
  Widget build(BuildContext context) {
    final double w = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 600,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/fondo.jpeg', fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.5)),
          ),
          Center(child: AppLogo(height: w < 700 ? 120 : 200)),
          const Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Text(
              "DISEÑO Y CONSTRUCCIÓN BIM",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
