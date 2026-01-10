import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class AddProjectForm extends StatelessWidget {
  final TextEditingController titleCtrl, locCtrl, descCtrl;
  final String? fileName;
  final VoidCallback onPick, onSave, onCancel;
  final bool isEditing;

  const AddProjectForm({
    super.key,
    required this.titleCtrl,
    required this.locCtrl,
    required this.descCtrl,
    this.fileName,
    required this.onPick,
    required this.onSave,
    required this.onCancel,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isEditing ? "Editar Proyecto" : "Nuevo Proyecto",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (isEditing)
              IconButton(icon: const Icon(Icons.close), onPressed: onCancel),
          ],
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: titleCtrl,
          decoration: const InputDecoration(
            labelText: "Título",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: locCtrl,
          decoration: const InputDecoration(
            labelText: "Ubicación",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: descCtrl,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: "Historia",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ListTile(
          title: Text(fileName ?? "Subir foto"),
          leading: const Icon(Icons.camera),
          onTap: onPick,
          tileColor: Colors.grey[200],
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
            ),
            child: const Text("GUARDAR", style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}
