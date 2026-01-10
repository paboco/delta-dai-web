import 'package:flutter/material.dart';
import '../../../data/models/project_model.dart';
import '../../../data/services/firebase_service.dart';

class AdminProjectList extends StatelessWidget {
  final FirebaseService service;
  final Function(ProjectModel) onEdit;
  const AdminProjectList({
    super.key,
    required this.service,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProjectModel>>(
      stream: service.getProjects(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final p = snapshot.data![index];
            return Card(
              child: ListTile(
                leading: Image.network(
                  p.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image),
                ),
                title: Text(p.title),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => onEdit(p),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => service.deleteProject(p.id),
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
