import 'package:delta_dai_bim_web/services/external/whatsapp_service.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import agregado
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
      appBar: AppBar(
        title: const Text("Catálogo de Modelos"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _service.getModels(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 380,
              childAspectRatio: 0.75,
              crossAxisSpacing: 25,
              mainAxisSpacing: 25,
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
    );
  }

  void _showHouseDetails(BuildContext context, HouseModel house) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 850,
          padding: const EdgeInsets.all(30),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    house.imageUrl,
                    fit: BoxFit.cover,
                    height: 400,
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      house.name,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Precio base: Q${house.price}",
                      style: const TextStyle(fontSize: 22, color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      house.description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                    const SizedBox(height: 40),
                    // CAMBIO A ELEVATEDBUTTON CON FAICON
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () =>
                          _service.launchWhatsApp(modelName: house.name),
                      icon: const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "SOLICITAR MODELO",
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
            ],
          ),
        ),
      ),
    );
  }
}
