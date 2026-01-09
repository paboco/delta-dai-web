import 'package:delta_dai_bim_web/services/external/whatsapp_service.dart';
import 'package:delta_dai_bim_web/widgets/shared/custom_navbar.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../widgets/models/project_model.dart';
import '../core/app_colors.dart';

class ProjectsPage extends StatelessWidget {
  final FirebaseService _service = FirebaseService();
  final WhatsAppService _whatsappService = WhatsAppService();

  ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: const CustomNavBar(),

      body: Stack(
        // 2. STACK: Para poner un fondo y luego el contenido
        children: [
          // FONDO DECORATIVO (Para que el cristal tenga algo que difuminar)
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.greyDark.withAlpha(100), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // CONTENIDO PRINCIPAL
          SingleChildScrollView(
            child: Column(
              children: [
                // 3. ESPACIADOR: Como el contenido ahora empieza desde arriba,
                // necesitamos un espacio para que el Navbar no tape la frase.
                const SizedBox(height: 120),

                // --- BLOQUE DE BIENVENIDA ---
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 60,
                    horizontal: 20,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "CONSTRUYENDO SUEÑOS, HISTORIA A HISTORIA",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors
                              .black, // Cambiado a oscuro para que se lea sobre el blanco/rojo
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: 100,
                        height: 4,
                        color: AppColors.primaryRed,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Cada obra es un compromiso con la excelencia y la visión de nuestros clientes.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                ),

                // --- LISTADO EN ZIGZAG ---
                StreamBuilder<List<ProjectModel>>(
                  stream: _service.getProjects(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryRed,
                        ),
                      );
                    }
                    final projects = snapshot.data ?? [];
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        final project = projects[index];
                        bool isEven = index % 2 == 0;
                        return _buildProjectRow(project, isEven);
                      },
                    );
                  },
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProjectRow(ProjectModel project, bool imageLeft) {
    Widget imagePart = Expanded(
      child: Container(
        height: 400,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: NetworkImage(project.imageUrl),
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withAlpha(kRadialReactionAlpha),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
      ),
    );

    Widget textPart = Expanded(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          crossAxisAlignment: imageLeft
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            Text(
              project.location.toUpperCase(),
              style: const TextStyle(
                color: AppColors.greyDark,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              project.title,
              textAlign: imageLeft ? TextAlign.left : TextAlign.right,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.greyDark,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              project.description,
              textAlign: imageLeft ? TextAlign.left : TextAlign.right,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.6,
              ),
            ),

            // 4. EL BOTÓN DE CONTACTO NO INVASIVO
            const SizedBox(height: 30),
            OutlinedButton.icon(
              onPressed: () {
                _whatsappService.launchWhatsApp(
                  modelName:
                      "Proyecto: ${project.title} en ${project.location}",
                );
              },
              icon: const Icon(Icons.chat_bubble_outline, size: 20),
              label: const Text("ME INTERESA UN DISEÑO ASÍ"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.greyDark,
                side: const BorderSide(color: AppColors.primaryRed, width: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
      child: Row(
        children: imageLeft ? [imagePart, textPart] : [textPart, imagePart],
      ),
    );
  }
}
