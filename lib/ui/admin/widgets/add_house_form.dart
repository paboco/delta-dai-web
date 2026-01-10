import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class AddHouseForm extends StatelessWidget {
  final TextEditingController nameCtrl, descCtrl, priceCtrl;
  final List<String> fileNames;
  final VoidCallback onPick, onSave, onCancel;
  final bool isEditing;

  const AddHouseForm({
    super.key,
    required this.nameCtrl,
    required this.descCtrl,
    required this.priceCtrl,
    required this.fileNames,
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
              isEditing ? "Editar Modelo" : "Nuevo Modelo",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            if (isEditing)
              IconButton(icon: const Icon(Icons.close), onPressed: onCancel),
          ],
        ),
        const SizedBox(height: 20),
        TextFormField(
          controller: nameCtrl,
          decoration: const InputDecoration(
            labelText: "Nombre",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: descCtrl,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: "Descripción",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: priceCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Precio",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: onPick,
          icon: const Icon(Icons.photo),
          label: const Text("Seleccionar Fotos"),
        ),
        if (fileNames.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text("Fotos: ${fileNames.length}"),
        ],
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
