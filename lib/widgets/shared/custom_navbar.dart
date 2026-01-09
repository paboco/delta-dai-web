import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'app_logo.dart';
import '../../services/external/whatsapp_service.dart';

class CustomNavBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80); // Aumentado para el logo gradecito
}

class _CustomNavBarState extends State<CustomNavBar> {
  final WhatsAppService _whatsappService = WhatsAppService();
  int _logoClicks = 0;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isMobile = screenWidth < 900;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.4),
            border: Border(
              bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.0,
              ),
            ),
          ),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 80, // Ajustado al PreferredSize
            titleSpacing: isMobile ? 20 : 50,
            title: GestureDetector(
              onTap: () {
                setState(() => _logoClicks++);
                if (_logoClicks >= 5) {
                  _logoClicks = 0;
                  Navigator.pushNamed(context, '/login');
                }
              },
              // Quitamos el height fijo para que use el responsive de app_logo.dart
              child: const AppLogoNavbar(),
            ),
            actions: [
              if (!isMobile) ...[
                _navBtn("Inicio", () => Navigator.pushNamed(context, '/')),
                _navBtn(
                  "Proyectos",
                  () => Navigator.pushNamed(context, '/projects'),
                ),
                _navBtn(
                  "Modelos",
                  () => Navigator.pushNamed(context, '/models'),
                ),
                const SizedBox(width: 20),
                _actionBtn(
                  "COTIZAR",
                  () => _whatsappService.launchWhatsApp(isGeneral: true),
                ),
                const SizedBox(width: 50),
              ] else
                Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu,
                      color: Colors.black87,
                      size: 32,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navBtn(String title, VoidCallback onTap) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(foregroundColor: Colors.black87),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }

  Widget _actionBtn(String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryRed,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          shape: const StadiumBorder(),
        ),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
