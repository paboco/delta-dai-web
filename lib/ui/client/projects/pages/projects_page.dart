import 'package:delta_dai_bim_web/core/app_colors.dart';
import 'package:delta_dai_bim_web/data/models/project_model.dart';
import 'package:delta_dai_bim_web/data/services/firebase_service.dart';
import 'package:delta_dai_bim_web/data/services/whatsapp_service.dart';
import 'package:delta_dai_bim_web/ui/shared/custom_navbar.dart';
import 'package:delta_dai_bim_web/ui/shared/custom_drawer.dart'; // IMPORTANTE
import 'package:flutter/material.dart';

class ProjectsPage extends StatelessWidget {
  final FirebaseService _service = FirebaseService();
  final WhatsAppService _whatsappService = WhatsAppService();

  ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomNavBar(),
      drawer: const CustomDrawer(), // ESTO HACE QUE EL MENÚ FUNCIONE
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.greyDark.withOpacity(0.1), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 140),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Text(
                        "CONSTRUYENDO SUEÑOS, HISTORIA A HISTORIA",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.black,
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
                    ],
                  ),
                ),
                const SizedBox(height: 50),
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
                        bool imageLeft = index % 2 == 0;
                        return _buildProjectRow(context, project, imageLeft);
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

  Widget _buildProjectRow(
    BuildContext context,
    ProjectModel project,
    bool imageLeft,
  ) {
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 900;

    Widget imagePart = Expanded(
      flex: isMobile ? 0 : 1,
      child: Container(
        height: isMobile ? 300 : 450,
        margin: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(project.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );

    Widget textPart = Expanded(
      flex: isMobile ? 0 : 1,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 60,
          vertical: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: isMobile
              ? CrossAxisAlignment.center
              : (imageLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end),
          children: [
            Text(
              project.location.toUpperCase(),
              style: const TextStyle(
                color: AppColors.primaryRed,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              project.title,
              textAlign: isMobile
                  ? TextAlign.center
                  : (imageLeft ? TextAlign.left : TextAlign.right),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.greyDark,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              project.description,
              textAlign: isMobile
                  ? TextAlign.center
                  : (imageLeft ? TextAlign.left : TextAlign.right),
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 30),
            OutlinedButton.icon(
              onPressed: () => _whatsappService.launchWhatsApp(
                modelName: "Proyecto: ${project.title} en ${project.location}",
              ),
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text("MÁS INFORMACIÓN"),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.greyDark,
                side: const BorderSide(color: AppColors.primaryRed, width: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 20,
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

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: isMobile
          ? Column(children: [imagePart, textPart])
          : Row(
              children: imageLeft
                  ? [imagePart, textPart]
                  : [textPart, imagePart],
            ),
    );
  }
}
