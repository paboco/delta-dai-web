import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/web_content.dart';
import '../widgets/shared/custom_navbar.dart';
import '../widgets/shared/custom_footer.dart';
import '../widgets/home/info_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/home/hero_section.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseService service = FirebaseService();

    return Scaffold(
      appBar: const CustomNavBar(),
      body: StreamBuilder<DocumentSnapshot>(
        stream: service.getWebContent(), // Escuchando a Firebase...
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // 1. Verificamos si la conexión está cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Verificamos si el documento EXISTE en Firebase
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "El documento 'settings/content' no existe en Firebase. ¡Créalo para ver los datos!",
              ),
            );
          }

          // 3. Ahora sí, extraemos los datos de forma segura
          final data = snapshot.data!.data() as Map<String, dynamic>?;

          // 4. Si por alguna razón la data es nula, ponemos un respaldo
          if (data == null) {
            return const Center(child: Text("El documento está vacío"));
          }

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
}
