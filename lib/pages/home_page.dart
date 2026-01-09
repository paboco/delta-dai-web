import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/web_content.dart';
import '../widgets/shared/custom_navbar.dart';
import '../widgets/shared/custom_footer.dart';
import '../widgets/home/info_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/home/hero_section.dart';
import '../core/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService service = FirebaseService();
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor:
          Colors.black, // Fondo base oscuro para transiciones limpias
      extendBodyBehindAppBar: true, // CLAVE: La imagen ahora sube hasta arriba
      appBar: const CustomNavBar(),

      drawer: screenWidth < 900
          ? Drawer(
              child: Container(
                color: const Color(0xFF121212),
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    const DrawerHeader(
                      decoration: BoxDecoration(color: AppColors.primaryRed),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "DELTA DAI BIM",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Precisión e Innovación",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _drawerItem(context, "Inicio", "/", Icons.home),
                    _drawerItem(
                      context,
                      "Proyectos",
                      "/ProjectsPage",
                      Icons.business,
                    ),
                    _drawerItem(context, "Modelos", "/models", Icons.home_work),
                  ],
                ),
              ),
            )
          : null,

      body: StreamBuilder<DocumentSnapshot>(
        stream: service.getWebContent(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Cargando contenido..."));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>?;
          if (data == null) return const Center(child: Text("Sin datos"));

          final content = WebContent.fromMap(data);

          return SingleChildScrollView(
            child: Column(
              children: [
                const HeroSection(),
                InfoSection(
                  title: "Quiénes Somos",
                  content: content.aboutUs,
                  backgroundColor: Colors.white,
                ),
                InfoSection(
                  title: "Misión",
                  content: content.mission,
                  backgroundColor: const Color(0xFFFDECEA),
                ),
                InfoSection(
                  title: "Visión",
                  content: content.vision,
                  backgroundColor: Colors.white,
                ),
                const CustomFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    String title,
    String route,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, route);
      },
    );
  }
}
