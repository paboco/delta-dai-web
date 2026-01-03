import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';

// IMPORTS DE TUS ARCHIVOS (Asegúrate que las rutas sean correctas)
import '../services/firebase_service.dart';
import '../models/house_model.dart';
import '../core/app_colors.dart';
import '../widgets/shared/app_logo.dart';
import '../widgets/admin/add_house_form.dart';
import '../widgets/admin/admin_house_list.dart'; // <--- ESTE IMPORT ES VITAL

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseService _service = FirebaseService();

  // Controladores
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  // Variables de estado
  Uint8List? _selectedFile;
  String? _fileName;
  String? _editingId; // null = Creando, !null = Editando

  // Función para cargar datos en el formulario (El puente)
  void _setupEdit(HouseModel house) {
    setState(() {
      _editingId = house.id;
      _nameCtrl.text = house.name;
      _descCtrl.text = house.description;
      _priceCtrl.text = house.price.toString();
      _selectedFile = null;
      _fileName = "Imagen actual (Toca para cambiar)";
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Editando: ${house.name}")));
  }

  Future<void> _handlePickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first.bytes;
        _fileName = result.files.first.name;
      });
    }
  }

  void _handleSave() async {
    // Si no hay archivo y no estamos editando, error
    if (_nameCtrl.text.isEmpty ||
        (_selectedFile == null && _editingId == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Completa los campos y selecciona una imagen"),
        ),
      );
      return;
    }

    try {
      String imageUrl = "";
      if (_selectedFile != null) {
        imageUrl = await _service.uploadImage(_selectedFile!, _fileName!);
      }

      final houseData = HouseModel(
        id: _editingId ?? '',
        name: _nameCtrl.text,
        description: _descCtrl.text,
        price: double.tryParse(_priceCtrl.text) ?? 0,
        imageUrl: imageUrl,
      );

      if (_editingId != null) {
        // Aquí llamarás a updateHouseModel en el futuro
        debugPrint("Actualizando ID: $_editingId");
      } else {
        await _service.addHouseModel(houseData);
      }

      _resetFields();
    } catch (e) {
      debugPrint("Error al guardar: $e");
    }
  }

  void _resetFields() {
    _nameCtrl.clear();
    _descCtrl.clear();
    _priceCtrl.clear();
    setState(() {
      _selectedFile = null;
      _fileName = null;
      _editingId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leadingWidth: 180,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: AppLogo(height: 60),
        ),
        title: const Text("Panel de Control Delta Dai"),
        backgroundColor: AppColors.greyDark,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // PANEL IZQUIERDO: Formulario
          Container(
            width: 400,
            color: Colors.grey[100],
            padding: const EdgeInsets.all(25),
            child: AddHouseForm(
              nameCtrl: _nameCtrl,
              descCtrl: _descCtrl,
              priceCtrl: _priceCtrl,
              selectedFile: _selectedFile,
              fileName: _fileName,
              onPickImage: _handlePickImage,
              onSave: _handleSave,
              editingId:
                  _editingId, // Le pasas la variable que ya tienes arriba
              onCancel: _resetFields,
            ),
          ),

          // PANEL DERECHO: Lista (Aquí usamos el widget independiente)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: AdminHouseList(
                service: _service,
                onEdit: _setupEdit, // <--- Conectamos la función aquí
              ),
            ),
          ),
        ],
      ),
    );
  }
}
