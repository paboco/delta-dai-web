import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'app_logo.dart';
import '../../services/external/whatsapp_service.dart';

class CustomNavBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _CustomNavBarState extends State<CustomNavBar> {
  final WhatsAppService _whatsappService = WhatsAppService();
  int _logoClicks = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      decoration: const BoxDecoration(
        color: AppColors.black,
        boxShadow: [
          BoxShadow(
            color: AppColors.bgLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              setState(() => _logoClicks++);
              if (_logoClicks >= 5) {
                _logoClicks = 0;
                Navigator.pushNamed(context, '/login');
              }
            },
            child: const AppLogo(height: 60),
          ),
          Row(
            children: [
              _navBtn("Inicio", () => Navigator.pushNamed(context, '/')),
              _navBtn(
                "Proyectos",
                () => Navigator.pushNamed(context, '/ProjectsPage'),
              ),
              _navBtn("Modelos", () => Navigator.pushNamed(context, '/models')),
              const SizedBox(width: 45),
              _actionBtn("COTIZAR", () {
                _whatsappService.launchWhatsApp(isGeneral: true);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navBtn(String title, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(foregroundColor: AppColors.white),
      child: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
    );
  }

  Widget _actionBtn(String title, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryRed,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
