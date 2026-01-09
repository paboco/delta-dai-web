// ignore_for_file: use_build_context_synchronously
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';

import '../services/firebase_service.dart';
import '../models/house_model.dart';
import '../widgets/models/project_model.dart'; // Asegúrate de importar tu nuevo modelo
import '../core/app_colors.dart';
import '../widgets/shared/app_logo.dart';
import '../widgets/admin/add_house_form.dart';
import '../widgets/admin/admin_house_list.dart';
import '../widgets/admin/add_project_form.dart'; // El widget que creamos antes
import '../widgets/admin/admin_project_list.dart'; // El widget que creamos antes

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final FirebaseService _service = FirebaseService();

  // --- CONTROLADORES Y LLAVES PARA CASAS ---
  final _houseFormKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  // --- CONTROLADORES Y LLAVES PARA PROYECTOS ---
  final _projectFormKey = GlobalKey<FormState>();
  final _pTitleCtrl = TextEditingController();
  final _pLocationCtrl = TextEditingController();
  final _pDescCtrl = TextEditingController();

  // VARIABLES COMPARTIDAS (Se limpian al cambiar o guardar)
  Uint8List? _selectedFile;
  String? _fileName;
  String? _editingId;

  // --- LÓGICA DE EDICIÓN ---
  void _setupEditHouse(HouseModel house) {
    setState(() {
      _editingId = house.id;
      _nameCtrl.text = house.name;
      _descCtrl.text = house.description;
      _priceCtrl.text = house.price.toString();
      _selectedFile = null;
      _fileName = "Imagen actual (Toca para cambiar)";
    });
  }

  void _setupEditProject(ProjectModel project) {
    setState(() {
      _editingId = project.id;
      _pTitleCtrl.text = project.title;
      _pLocationCtrl.text = project.location;
      _pDescCtrl.text = project.description;
      _selectedFile = null;
      _fileName = "Imagen actual (Toca para cambiar)";
    });
  }

  // --- MANEJO DE IMÁGENES ---
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

  // --- GUARDADO DE CASAS ---
  void _handleSaveHouse() async {
    if (!_houseFormKey.currentState!.validate()) return;
    if (_selectedFile == null && _editingId == null) {
      _showSnackBar("Por favor, selecciona una imagen");
      return;
    }

    try {
      String imageUrl = "";
      if (_selectedFile != null) {
        imageUrl = await _service.uploadImage(
          _selectedFile!,
          _fileName!,
          'models',
        );
      }

      final houseData = HouseModel(
        id: _editingId ?? '',
        name: _nameCtrl.text,
        description: _descCtrl.text,
        price: double.tryParse(_priceCtrl.text) ?? 0,
        imageUrl: imageUrl,
      );

      if (_editingId != null) {
        // await _service.updateHouseModel(houseData);
      } else {
        await _service.addHouseModel(houseData);
      }

      _showSnackBar("¡Casa guardada exitosamente!");
      _resetFields();
    } catch (e) {
      _showSnackBar("Error al guardar casa: $e");
    }
  }

  // --- GUARDADO DE PROYECTOS ---
  void _handleSaveProject() async {
    if (!_projectFormKey.currentState!.validate()) return;
    if (_selectedFile == null && _editingId == null) {
      _showSnackBar("Selecciona una foto de la obra realizada");
      return;
    }

    try {
      String imageUrl = "";
      if (_selectedFile != null) {
        imageUrl = await _service.uploadImage(
          _selectedFile!,
          _fileName!,
          'projects',
        );
      }

      final projectData = ProjectModel(
        id: _editingId ?? '',
        title: _pTitleCtrl.text,
        location: _pLocationCtrl.text,
        description: _pDescCtrl.text,
        imageUrl: imageUrl,
        date: DateTime.now(),
      );

      if (_editingId != null) {
        await _service.updateProject(projectData);
      } else {
        await _service.addProject(projectData);
      }

      _showSnackBar("¡Historia de proyecto guardada!");
      _resetFields();
    } catch (e) {
      _showSnackBar("Error al guardar proyecto: $e");
    }
  }

  void _resetFields() {
    _nameCtrl.clear();
    _descCtrl.clear();
    _priceCtrl.clear();
    _pTitleCtrl.clear();
    _pLocationCtrl.clear();
    _pDescCtrl.clear();
    setState(() {
      _selectedFile = null;
      _fileName = null;
      _editingId = null;
    });
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 110,
          leadingWidth: 200,
          leading: const Center(
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: AppLogoNavbar(height: 90),
            ),
          ),
          title: const Text(
            "Panel del Administrador",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: AppColors.greyDark,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) return;
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.primaryRed,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.house), text: "MODELOS DE CASAS"),
              Tab(
                icon: Icon(Icons.history_edu),
                text: "HISTORIAS DE PROYECTOS",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // PESTAÑA 1: GESTIÓN DE CASAS
            _buildTabLayout(
              form: Form(
                key: _houseFormKey,
                child: AddHouseForm(
                  nameCtrl: _nameCtrl,
                  descCtrl: _descCtrl,
                  priceCtrl: _priceCtrl,
                  selectedFile: _selectedFile,
                  fileName: _fileName,
                  onPickImage: _handlePickImage,
                  onSave: _handleSaveHouse,
                  editingId: _editingId,
                  onCancel: _resetFields,
                ),
              ),
              list: AdminHouseList(service: _service, onEdit: _setupEditHouse),
            ),

            // PESTAÑA 2: GESTIÓN DE PROYECTOS
            // PESTAÑA 2: GESTIÓN DE PROYECTOS
            _buildTabLayout(
              form: Form(
                key: _projectFormKey,
                child: AddProjectForm(
                  titleCtrl: _pTitleCtrl,
                  locationCtrl: _pLocationCtrl,
                  descCtrl: _pDescCtrl,
                  selectedFile: _selectedFile,
                  fileName: _fileName,
                  onPickImage: _handlePickImage,
                  onSave: _handleSaveProject,
                  editingId: _editingId,
                  onCancel: _resetFields,
                ),
              ),
              // AQUÍ CONECTAMOS LA LISTA Y LA FUNCIÓN DE EDICIÓN
              list: AdminProjectList(
                service: _service,
                onEdit:
                    _setupEditProject, // Esto quita el warning automáticamente
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para no repetir el Row y el Container en cada Tab
  Widget _buildTabLayout({required Widget form, required Widget list}) {
    return Row(
      children: [
        Container(
          width: 400,
          color: Colors.grey[100],
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(child: form),
        ),
        Expanded(
          child: Padding(padding: const EdgeInsets.all(20), child: list),
        ),
      ],
    );
  }
}
