import 'package:delta_dai_bim_web/services/external/whatsapp_service.dart';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final whatsAppService = WhatsAppService();

    return Container(
      width: double.infinity,
      color: AppColors.black,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Text(
            "DELTA DAI BIM - © 2026",
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          TextButton.icon(
            onPressed: () => whatsAppService.launchWhatsApp(isGeneral: true),
            icon: const Icon(Icons.chat, color: Colors.green),
            label: const Text(
              "Contáctanos por WhatsApp",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
