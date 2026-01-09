import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class AddHouseForm extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController descCtrl;
  final TextEditingController priceCtrl;
  final Uint8List? selectedFile;
  final String? fileName;
  final VoidCallback onPickImage;
  final VoidCallback onSave;
  final String? editingId;
  final VoidCallback onCancel;

  const AddHouseForm({
    super.key,
    required this.nameCtrl,
    required this.descCtrl,
    required this.priceCtrl,
    required this.selectedFile,
    required this.fileName,
    required this.onPickImage,
    required this.onSave,
    required this.editingId,
    required this.onCancel,
    // Eliminamos onReset y formKey de aquí porque se manejan desde el padre
  });

  @override
  Widget build(BuildContext context) {
    final isEditing = editingId != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "📝 Editando Modelo",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              TextButton.icon(
                onPressed: onCancel,
                icon: const Icon(Icons.close, color: Colors.red),
                label: const Text(
                  "CANCELAR",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          )
        else
          const Text(
            "🏠 Añadir Nuevo Modelo",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),

        const SizedBox(height: 20),

        // --- CAMPO NOMBRE ---
        TextFormField(
          controller: nameCtrl,
          decoration: const InputDecoration(
            labelText: "Nombre del Proyecto",
            border: OutlineInputBorder(),
          ),
          // VALIDATOR: Esto crea las letras rojas de error
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor, ingresa un nombre';
            }
            return null;
          },
        ),

        const SizedBox(height: 15),

        // --- CAMPO DESCRIPCIÓN ---
        TextFormField(
          controller: descCtrl,
          decoration: const InputDecoration(
            labelText: "Descripción",
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'La descripción es obligatoria';
            }
            return null;
          },
        ),

        const SizedBox(height: 15),

        // --- CAMPO PRECIO ---
        TextFormField(
          controller: priceCtrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Precio (Q)",
            border: OutlineInputBorder(),
            prefixText: "Q ",
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa un monto';
            }
            // Validamos que sea un número real (Jerga: Numeric Parsing)
            final isNumber = double.tryParse(value);
            if (isNumber == null) {
              return 'Ingresa un monto numérico válido';
            }
            return null;
          },
        ),

        const SizedBox(height: 20),

        const Text(
          "Imagen del modelo:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onPickImage,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
          ),
          icon: const Icon(Icons.image_search),
          label: Text(fileName ?? "Seleccionar Imagen desde PC"),
        ),

        // Feedback visual de la imagen
        if (selectedFile != null)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "✅ Imagen lista para subir",
              style: TextStyle(
                color: Colors.green,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        else if (isEditing)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "ℹ️ Deja vacío para mantener la imagen actual",
              style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),

        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onSave,
            style: ElevatedButton.styleFrom(
              backgroundColor: isEditing
                  ? Colors.orange[700]
                  : AppColors.primaryRed,
              padding: const EdgeInsets.symmetric(vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              isEditing ? "ACTUALIZAR CAMBIOS" : "GUARDAR MODELO",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
