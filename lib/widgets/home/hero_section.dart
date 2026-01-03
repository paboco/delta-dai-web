import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../services/external/whatsapp_service.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final whatsappService = WhatsAppService();
    return Container(
      height: 500,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          // Aquí usaremos una de tus fotos de casas de Firebase Storage
          image: NetworkImage(
            'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?q=80&w=1000',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        color: Colors.black.withValues(
          alpha: 200,
        ), // Capa oscura para que se lea el texto
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "DISEÑO Y CONSTRUCCIÓN BIM",
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Modelos de casas vanguardistas en Guatemala",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => whatsappService.launchWhatsApp(isGeneral: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
              ),
              child: const Text(
                "COTIZAR AHORA",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
