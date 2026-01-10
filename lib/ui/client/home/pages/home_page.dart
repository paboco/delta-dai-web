import 'package:flutter/material.dart';
import '../../../../data/services/firebase_service.dart';
import '../../../../data/models/web_content.dart';
import '../../../shared/custom_navbar.dart';
import '../../../shared/custom_drawer.dart'; // IMPORTANTE
import '../../../shared/custom_footer.dart';
import '../widgets/hero_section.dart';
import '../widgets/info_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomNavBar(),
      drawer: const CustomDrawer(), // ESTO HACE QUE EL MENÚ FUNCIONE
      body: StreamBuilder(
        stream: FirebaseService().getWebContent(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final content = WebContent.fromMap(
            snapshot.data!.data() as Map<String, dynamic>,
          );

          return SingleChildScrollView(
            child: Column(
              children: [
                const HeroSection(),
                InfoSection(
                  title: "Quiénes Somos",
                  content: content.aboutUs,
                  bg: Colors.white,
                ),
                InfoSection(
                  title: "Misión",
                  content: content.mission,
                  bg: const Color.fromARGB(255, 245, 198, 192),
                ),
                InfoSection(
                  title: "Visión",
                  content: content.vision,
                  bg: Colors.white,
                ),
                const CustomFooter(),
              ],
            ),
          );
        },
      ),
    );
  }
}
