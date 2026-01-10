import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF9F6F2), // Blanco Hueso
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.greyDark),
            child: const Center(
              child: Text(
                "DELTA DAI BIM",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          _drawerItem(context, Icons.home_outlined, "Inicio", '/'),
          _drawerItem(
            context,
            Icons.business_outlined,
            "Proyectos",
            '/projects',
          ),
          _drawerItem(context, Icons.grid_view_outlined, "Modelos", '/models'),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "© Delta Dai BIM",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryRed),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.greyDark,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Cierra el menú antes de navegar
        Navigator.pushNamed(context, route);
      },
    );
  }
}
