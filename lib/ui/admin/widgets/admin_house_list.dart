import 'package:flutter/material.dart';
import '../../../data/models/house_model.dart';
import '../../../data/services/firebase_service.dart';

class AdminHouseList extends StatelessWidget {
  final FirebaseService service;
  final Function(HouseModel) onEdit;
  const AdminHouseList({
    super.key,
    required this.service,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: service.getModels(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data!.docs;
        return ListView.builder(
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final house = HouseModel.fromFirestore(
              docs[index].data() as Map<String, dynamic>,
              docs[index].id,
            );
            return Card(
              child: ListTile(
                leading: Image.network(
                  house.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.home),
                ),
                title: Text(house.name),
                subtitle: Text("Q${house.price}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => onEdit(house),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => service.deleteHouseModel(house.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
