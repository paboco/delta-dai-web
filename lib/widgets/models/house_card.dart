import 'package:delta_dai_bim_/services/external/whatsapp_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import agregado
import '../../models/house_model.dart';

class HouseCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
              child: Image.network(
                house.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  house.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "Q${house.price}",
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onMoreInfo,
                        child: const Text("Ver más"),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // CAMBIO A FAICON
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.green,
                      ),
                      onPressed: () =>
                          service.launchWhatsApp(modelName: house.name),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
