import 'package:flutter/material.dart';
import '../../models/house_model.dart';
import '../../services/firebase_service.dart';

class AdminHouseList extends StatelessWidget {
  final FirebaseService service;
  // Esta función envía la casa seleccionada a la AdminPage para editar
  final Function(HouseModel) onEdit;

  const AdminHouseList({
    super.key,
    required this.service,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Modelos en la Web",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: StreamBuilder(
            stream: service.getModels(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final docs = snapshot.data!.docs;

              if (docs.isEmpty) {
                return const Center(child: Text("No hay modelos publicados."));
              }

              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final house = HouseModel.fromFirestore(
                    docs[index].data() as Map<String, dynamic>,
                    docs[index].id,
                  );
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    elevation: 2,
                    child: ListTile(
                      // Eliminamos el onTap de toda la fila para evitar errores
                      leading: house.imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.network(
                                house.imageUrl,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Icons.home, size: 40),
                      title: Text(
                        house.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Q${house.price}"),
                      // Agrupamos las acciones en el extremo derecho
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // BOTÓN DE EDITAR
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            tooltip: "Editar este modelo",
                            onPressed: () => onEdit(
                              house,
                            ), // <--- La magia ahora ocurre aquí
                          ),
                          // BOTÓN DE ELIMINAR
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: "Eliminar definitivamente",
                            onPressed: () =>
                                _confirmDelete(context, docs[index].reference),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, dynamic reference) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Eliminar modelo?"),
        content: const Text(
          "Esta acción eliminará el registro de la base de datos de forma permanente.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              reference.delete();
              Navigator.pop(context);
            },
            child: const Text(
              "Eliminar",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
