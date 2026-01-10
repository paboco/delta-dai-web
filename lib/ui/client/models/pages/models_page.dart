import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../data/services/firebase_service.dart';
import '../../../../data/services/whatsapp_service.dart';
import '../../../../data/models/house_model.dart';
import '../../../../core/app_colors.dart';
import '../../../shared/custom_navbar.dart';
import '../widgets/house_card.dart';

class ModelsPage extends StatelessWidget {
  const ModelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomNavBar(),
      body: Stack(
        children: [
          // 1. FONDO PREMIUM
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  Colors.white,
                  const Color(0xFFF7F7F7),
                  AppColors.primaryRed.withOpacity(0.04),
                ],
              ),
            ),
          ),

          // 2. CONTENIDO PRINCIPAL
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 140),
                // ENCABEZADO
                Column(
                  children: [
                    const Text(
                      "NUESTROS MODELOS",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 4,
                        color: AppColors.greyDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 60,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "Diseños arquitectónicos con precisión BIM para su hogar",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // GRID DE MODELOS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: StreamBuilder(
                    stream: FirebaseService().getModels(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryRed,
                          ),
                        );
                      }
                      final docs = snapshot.data!.docs;

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(30),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 450,
                              childAspectRatio:
                                  0.85, // Ajuste para evitar efecto "estirado"
                              mainAxisSpacing: 30,
                              crossAxisSpacing: 30,
                            ),
                        itemCount: docs.length,
                        itemBuilder: (ctx, i) {
                          final house = HouseModel.fromFirestore(
                            docs[i].data() as Map<String, dynamic>,
                            docs[i].id,
                          );
                          return HouseCard(
                            house: house,
                            onMoreInfo: () => _showDetails(context, house),
                            service: WhatsAppService(),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDetails(BuildContext context, HouseModel house) {
    int currentIndex = 0; // Índice local para los dots

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: SizedBox(
              width: 950,
              height: 600,
              child: Row(
                children: [
                  // LADO IZQUIERDO: CARRUSEL + DOTS
                  Expanded(
                    flex: 6,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          color: Colors.black,
                          child: house.images.isEmpty
                              ? Image.network(house.imageUrl, fit: BoxFit.cover)
                              : CarouselSlider(
                                  items: house.images.map((url) {
                                    return Image.network(
                                      url,
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                    );
                                  }).toList(),
                                  options: CarouselOptions(
                                    height: 600,
                                    viewportFraction: 1.0,
                                    autoPlay: house.images.length > 1,
                                    autoPlayInterval: const Duration(
                                      seconds: 4,
                                    ),
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        currentIndex = index;
                                      });
                                    },
                                  ),
                                ),
                        ),
                        // INDICADORES (DOTS)
                        if (house.images.length > 1)
                          Positioned(
                            bottom: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: house.images.asMap().entries.map((
                                entry,
                              ) {
                                return Container(
                                  width: 8.0,
                                  height: 8.0,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentIndex == entry.key
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.4),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // LADO DERECHO: INFO
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            house.name.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppColors.greyDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Desde Q${house.price}",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          const Divider(height: 40),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                house.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  height: 1.6,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: () => WhatsAppService().launchWhatsApp(
                              modelName: house.name,
                            ),
                            icon: const FaIcon(
                              FontAwesomeIcons.whatsapp,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: const Text(
                              "SOLICITAR COTIZACIÓN",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[600],
                              minimumSize: const Size(double.infinity, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
