import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class AddProjectForm extends StatelessWidget {
  final TextEditingController titleCtrl;
  final TextEditingController locationCtrl;
  final TextEditingController descCtrl;
  final Uint8List? selectedFile;
  final String? fileName;
  final VoidCallback onPickImage;
  final VoidCallback onSave;
  final String? editingId; // <--- Para saber si estamos editando
  final VoidCallback onCancel;

  const AddProjectForm({
    super.key,
    required this.titleCtrl,
    required this.locationCtrl,
    required this.descCtrl,
    required this.selectedFile,
    required this.fileName,
    required this.onPickImage,
    required this.onSave,
    required this.onCancel,
    this.editingId,
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
              editingId == null ? "Nueva Historia" : "Editando Historia",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (editingId != null)
              IconButton(icon: const Icon(Icons.close), onPressed: onCancel),
          ],
        ),
        const SizedBox(height: 20),

        // CAMPO TÍTULO
        TextFormField(
          controller: titleCtrl,
          decoration: const InputDecoration(
            labelText: "Título del Proyecto",
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              value!.isEmpty ? "El título es obligatorio" : null,
        ),
        const SizedBox(height: 15),

        // CAMPO UBICACIÓN
        TextFormField(
          controller: locationCtrl,
          decoration: const InputDecoration(
            labelText: "Ubicación (Ej: Mixco, Guatemala)",
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              value!.isEmpty ? "La ubicación es necesaria" : null,
        ),
        const SizedBox(height: 15),

        // CAMPO HISTORIA (MULTILÍNEA)
        TextFormField(
          controller: descCtrl,
          maxLines: 8,
          decoration: const InputDecoration(
            labelText: "Escribe la historia aquí...",
            alignLabelWithHint: true,
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              value!.length < 10 ? "La historia es muy corta" : null,
        ),
        const SizedBox(height: 20),

        // SELECTOR DE IMAGEN
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            leading: const Icon(Icons.camera_alt),
            title: Text(fileName ?? "Subir foto de la obra"),
            subtitle: Text(
              selectedFile != null
                  ? "Imagen seleccionada"
                  : "Formatos: JPG, PNG",
            ),
            onTap: onPickImage,
          ),
        ),

        const SizedBox(height: 30),

        // BOTÓN DE GUARDAR / ACTUALIZAR
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: editingId == null
                  ? AppColors.primaryRed
                  : Colors.blueGrey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              editingId == null ? "PUBLICAR HISTORIA" : "GUARDAR CAMBIOS",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
