import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../data/services/whatsapp_service.dart';
import 'app_logo.dart';

class CustomNavBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomNavBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(80);
  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  int _logoClicks = 0;

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 900;

    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          color: Colors.white.withValues(alpha: 0.4),
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 80,
            title: GestureDetector(
              onTap: () {
                setState(() => _logoClicks++);
                if (_logoClicks >= 5) {
                  _logoClicks = 0;
                  Navigator.pushNamed(context, '/login');
                }
              },
              child: const MouseRegion(
                cursor: SystemMouseCursors.basic,
                child: AppLogoNavbar(),
              ),
            ),
            actions: isDesktop
                ? [
                    _btn(context, "Inicio", '/'),
                    _btn(context, "Proyectos", '/projects'),
                    _btn(context, "Modelos", '/models'),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () =>
                          WhatsAppService().launchWhatsApp(isGeneral: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                      ),
                      child: const Text(
                        "COTIZAR",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 50),
                  ]
                : [
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.black),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ],
          ),
        ),
      ),
    );
  }

  Widget _btn(BuildContext context, String text, String route) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
