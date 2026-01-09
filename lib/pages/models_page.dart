import 'package:delta_dai_bim_web/services/external/whatsapp_service.dart';
import 'package:delta_dai_bim_web/widgets/shared/custom_navbar.dart';
import 'package:delta_dai_bim_web/core/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../services/firebase_service.dart';
import '../models/house_model.dart';
import '../widgets/models/house_card.dart';

class ModelsPage extends StatelessWidget {
  ModelsPage({super.key});

  final FirebaseService _service = FirebaseService();
  final WhatsAppService _whatsappService = WhatsAppService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CustomNavBar(),
      body: Stack(
        children: [
          // FONDO DECORATIVO - Corregido con .withValues para evitar avisos de deprecación
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryRed.withValues(alpha: 0.08),
                  Colors.white,
                  AppColors.greyDark.withValues(alpha: 0.05),
                ],
              ),
            ),
          ),

          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryRed.withValues(alpha: 0.05),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 40, bottom: 20),
                  child: Column(
                    children: [
                      Text(
                        "NUESTROS MODELOS",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                          color: AppColors.greyDark,
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        indent: 100,
                        endIndent: 100,
                        color: AppColors.primaryRed,
                        thickness: 3,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: StreamBuilder(
                    stream: _service.getModels(),
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
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 20,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 400,
                              childAspectRatio: 0.72,
                              crossAxisSpacing: 30,
                              mainAxisSpacing: 30,
                            ),
                        itemCount: docs.length,
                        itemBuilder: (context, index) {
                          final house = HouseModel.fromFirestore(
                            docs[index].data() as Map<String, dynamic>,
                            docs[index].id,
                          );
                          return HouseCard(
                            house: house,
                            service: _whatsappService,
                            onMoreInfo: () => _showHouseDetails(context, house),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showHouseDetails(BuildContext context, HouseModel house) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: 900,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 500,
                  child: Image.network(house.imageUrl, fit: BoxFit.cover),
                ),
              ),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        house.name.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight
                              .w900, // CORRECCIÓN: black no existe, usamos w900
                          color: AppColors.greyDark,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Desde Q${house.price}",
                        style: const TextStyle(
                          fontSize: 24,
                          color: AppColors.primaryRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        house.description,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.grey[700],
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          minimumSize: const Size(double.infinity, 65),
                          elevation: 5,
                          // CORRECCIÓN: .withValues para el shadowColor
                          shadowColor: Colors.green.withValues(alpha: 0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () =>
                            _service.launchWhatsApp(modelName: house.name),
                        icon: const FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.white,
                          size: 28,
                        ),
                        label: const Text(
                          "COTIZAR POR WHATSAPP",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
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
      ),
    );
  }
}
