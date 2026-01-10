import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Asegúrate de tenerlo en pubspec.yaml
import '../../core/app_colors.dart';
import '../../data/services/whatsapp_service.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  // FUNCIÓN REAL PARA ABRIR ENLACES
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // Aumenté un poco el padding vertical para que no se vea pegado
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
      color: AppColors.greyDark, // Mantenemos el fondo negro/gris oscuro
      child: Column(
        children: [
          // LOGO O NOMBRE DE LA EMPRESA
          const Text(
            "DELTA DAI BIM",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
              color: Colors
                  .white, // Texto en blanco para resaltar sobre el fondo oscuro
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Innovación y precisión en cada construcción.",
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 30),

          // REDES SOCIALES
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon(
                icon: FontAwesomeIcons.facebookF,
                color: const Color(0xFF1877F2),
                onTap: () => _launchURL(
                  "https://www.facebook.com/vivienda.unifamiliardelta",
                ),
              ),
              _socialIcon(
                icon: FontAwesomeIcons.instagram,
                color: const Color(0xFFE4405F),
                onTap: () => _launchURL(
                  "https://www.instagram.com/deltadaibim?utm_source=ig_web_button_share_sheet&igsh=ZDNlZDc0MzIxNw==",
                ),
              ),
              _socialIcon(
                icon: FontAwesomeIcons.tiktok,
                color: const Color(0xFF111111),
                onTap: () => _launchURL(
                  "https://www.tiktok.com/@deltadaibimgt?is_from_webapp=1&sender_device=pc",
                ),
              ),
              _socialIcon(
                icon: FontAwesomeIcons.whatsapp,
                color: const Color(0xFF25D366),
                onTap: () => WhatsAppService().launchWhatsApp(isGeneral: true),
              ),
            ],
          ),

          const SizedBox(height: 40),
          const Divider(thickness: 1, color: Colors.white10), // Divider sutil
          const SizedBox(height: 20),

          // COPYRIGHT
          Text(
            "© ${DateTime.now().year} Delta Dai BIM. Todos los derechos reservados.",
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _socialIcon({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white, // Círculo blanco para que el icono destaque
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: FaIcon(icon, color: color, size: 22),
        ),
      ),
    );
  }
}
