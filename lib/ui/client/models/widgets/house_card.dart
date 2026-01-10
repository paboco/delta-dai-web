import 'package:delta_dai_bim_web/core/app_colors.dart';
import 'package:delta_dai_bim_web/data/models/house_model.dart';
import 'package:delta_dai_bim_web/data/services/whatsapp_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HouseCard extends StatefulWidget {
  final HouseModel house;
  final WhatsAppService service;
  final VoidCallback onMoreInfo;

  const HouseCard({
    super.key,
    required this.house,
    required this.service,
    required this.onMoreInfo,
  });

  @override
  State<HouseCard> createState() => _HouseCardState();
}

class _HouseCardState extends State<HouseCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: Container(
        // Este contenedor NO se mueve, sirve de "ancla" para el mouse
        color: Colors.transparent,
        child: AnimatedContainer(
          duration: const Duration(
            milliseconds: 250,
          ), // Un poco más rápido para que sea responsivo
          curve: Curves.easeOutCubic, // Curva más suave
          transform: isHovered
              ? (Matrix4.identity()..translate(0, -7, 0)) // Elevación más sutil
              : Matrix4.identity(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isHovered ? 0.15 : 0.05),
                blurRadius: isHovered ? 20 : 10,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contenedor de Imagen con Zoom
              Expanded(
                flex: 6,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: AnimatedScale(
                        scale: isHovered ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 500),
                        child: Image.network(
                          widget.house.imageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Badge de Precio Elegante
                    Positioned(
                      top: 15,
                      right: 15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "Q${widget.house.price}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Información de la Casa
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.house.name.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          color: AppColors.greyDark,
                          letterSpacing: 1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // --- CORRECCIÓN: Ahora es dinámico y estético ---
                      Text(
                        widget.house.description, // Trae la descripción real
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          height: 1.3, // Interlineado para mejor lectura
                        ),
                        maxLines: 2, // Evita que el texto rompa el diseño
                        overflow:
                            TextOverflow.ellipsis, // Pone "..." si es muy largo
                      ),

                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: widget.onMoreInfo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.greyDark,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                "DETALLES",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.green,
                              size: 28,
                            ),
                            onPressed: () => widget.service.launchWhatsApp(
                              modelName: widget.house.name,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
