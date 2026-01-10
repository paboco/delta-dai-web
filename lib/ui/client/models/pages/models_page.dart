import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../data/services/firebase_service.dart';
import '../../../../data/services/whatsapp_service.dart';
import '../../../../data/models/house_model.dart';
import '../../../../core/app_colors.dart';
import '../../../shared/custom_navbar.dart';
import '../../../shared/custom_drawer.dart';
import '../widgets/house_card.dart';

class ModelsPage extends StatelessWidget {
  const ModelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomNavBar(),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          // FONDO CON GRADIENTE HUESO
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  const Color(0xFFFAF9F6),
                  const Color(0xFFF9F6F2),
                  AppColors.primaryRed.withOpacity(0.04),
                ],
              ),
            ),
          ),
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
                      textAlign: TextAlign.center,
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
                        padding: const EdgeInsets.all(20),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 450,
                              childAspectRatio: 0.85,
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
    int currentIndex = 0;
    final size = MediaQuery.of(context).size;
    final bool isMobile = size.width < 800;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: 1000,
                maxHeight: isMobile ? size.height * 0.85 : 600,
              ),
              child: Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                children: [
                  // --- LADO DE IMAGEN (CARRUSEL) ---
                  Expanded(
                    flex: isMobile ? 0 : 6,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Container(
                          height: isMobile ? 250 : double.infinity,
                          color: Colors.black,
                          child: house.images.isEmpty
                              ? Image.network(house.imageUrl, fit: BoxFit.cover)
                              : CarouselSlider(
                                  items: house.images
                                      .map(
                                        (url) => Image.network(
                                          url,
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                        ),
                                      )
                                      .toList(),
                                  options: CarouselOptions(
                                    height: isMobile ? 250 : 600,
                                    viewportFraction: 1.0,
                                    autoPlay: house.images.length > 1,
                                    autoPlayInterval: const Duration(
                                      seconds: 4,
                                    ),
                                    onPageChanged: (index, reason) =>
                                        setState(() => currentIndex = index),
                                  ),
                                ),
                        ),
                        if (house.images.length > 1)
                          Positioned(
                            bottom: 15,
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
                  // --- LADO DE INFORMACIÓN ---
                  Expanded(
                    flex: isMobile ? 0 : 4,
                    child: Container(
                      padding: EdgeInsets.all(isMobile ? 20 : 40),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            house.name.toUpperCase(),
                            style: TextStyle(
                              fontSize: isMobile ? 22 : 28,
                              fontWeight: FontWeight.w900,
                              color: AppColors.greyDark,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Desde Q${house.price}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          const Divider(height: 40),
                          // DESCRIPCIÓN CON SCROLL PROPIO
                          Flexible(
                            child: SingleChildScrollView(
                              child: Text(
                                house.description,
                                style: const TextStyle(
                                  fontSize: 15,
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
