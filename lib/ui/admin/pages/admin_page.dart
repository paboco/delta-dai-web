import 'dart:typed_data';
import 'dart:ui';
import 'package:delta_dai_bim_web/ui/shared/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import '../../../data/repositories/admin_repository.dart';
import '../../../data/services/firebase_service.dart';
import '../../../data/models/house_model.dart';
import '../../../data/models/project_model.dart';
import '../../../core/app_colors.dart';
import '../widgets/add_house_form.dart';
import '../widgets/admin_house_list.dart';
import '../widgets/add_project_form.dart';
import '../widgets/admin_project_list.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final AdminRepository _repo = AdminRepository();
  final FirebaseService _service = FirebaseService();

  // Controles
  final _houseKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _price = TextEditingController();

  final _projKey = GlobalKey<FormState>();
  final _pTitle = TextEditingController();
  final _pLoc = TextEditingController();
  final _pDesc = TextEditingController();

  List<Uint8List> _files = [];
  List<String> _names = [];
  String? _editId;
  List<String> _existingImgs = [];
  String? _existingProjImg;

  // Lógica de Selección de Imágenes
  void _pickImages({bool multi = true}) async {
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: multi,
        withData: true,
      );

      if (res != null) {
        setState(() {
          if (_names.isNotEmpty && _names[0].contains("actual")) {
            _names.clear();
            _files.clear();
          }
          if (!multi) {
            _files = [];
            _names = [];
          }
          _files.addAll(res.files.map((f) => f.bytes!));
          _names.addAll(res.files.map((f) => f.name));
        });
      }
    } catch (e) {
      _msg("Error seleccionando foto: $e");
    }
  }

  void _saveHouse() async {
    // AQUÍ OCURRÍA EL ERROR: _houseKey no estaba asignada
    if (!_houseKey.currentState!.validate()) return;

    if (_files.isEmpty && _editId == null) return _msg("Faltan fotos");

    _load(true);
    try {
      await _repo.saveHouse(
        editingId: _editId,
        name: _name.text,
        description: _desc.text,
        price: double.tryParse(_price.text) ?? 0.0,
        newFiles: (_names.isNotEmpty && !_names[0].contains("actual"))
            ? _files
            : [],
        existingImages: _existingImgs,
      );
      _msg("Modelo guardado correctamente");
      _reset();
    } catch (e) {
      _msg("Error al guardar: $e");
    } finally {
      _load(false);
    }
  }

  void _saveProj() async {
    // Y AQUÍ TAMBIÉN HUBIERA FALLADO
    if (!_projKey.currentState!.validate()) return;

    _load(true);
    try {
      await _repo.saveProject(
        editingId: _editId,
        title: _pTitle.text,
        location: _pLoc.text,
        description: _pDesc.text,
        newFile: (_files.isNotEmpty && !_names[0].contains("actual"))
            ? _files.first
            : null,
        currentImageUrl: _existingProjImg,
      );
      _msg("Proyecto guardado correctamente");
      _reset();
    } catch (e) {
      _msg("Error al guardar: $e");
    } finally {
      _load(false);
    }
  }

  void _editHouse(HouseModel h) {
    setState(() {
      _editId = h.id;
      _name.text = h.name;
      _desc.text = h.description;
      _price.text = h.price.toString();
      _existingImgs = h.images;
      _files = [];
      _names = ["Fotos actuales cargadas (Toca para cambiar)"];
    });
  }

  void _editProj(ProjectModel p) {
    setState(() {
      _editId = p.id;
      _pTitle.text = p.title;
      _pLoc.text = p.location;
      _pDesc.text = p.description;
      _existingProjImg = p.imageUrl;
      _files = [];
      _names = ["Foto actual cargada (Toca para cambiar)"];
    });
  }

  void _reset() {
    _name.clear();
    _desc.clear();
    _price.clear();
    _pTitle.clear();
    _pLoc.clear();
    _pDesc.clear();
    setState(() {
      _files = [];
      _names = [];
      _editId = null;
      _existingImgs = [];
      _existingProjImg = null;
    });
  }

  void _load(bool v) => v
      ? showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(
            child: CircularProgressIndicator(color: AppColors.primaryRed),
          ),
        )
      : Navigator.pop(context);

  void _msg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(160),
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AppBar(
                automaticallyImplyLeading: false,
                toolbarHeight: 110,
                leadingWidth: 300,
                backgroundColor: AppColors.greyDark.withValues(alpha: 0.7),
                elevation: 0,
                leading: const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: AppLogoNavbar(height: 100),
                ),
                title: const Text(
                  "ADMINISTRACIÓN",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      if (mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/',
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
                bottom: const TabBar(
                  indicatorColor: AppColors.primaryRed,
                  labelColor: Colors.white,
                  tabs: [
                    Tab(text: "CASAS"),
                    Tab(text: "PROYECTOS"),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            // --- AQUÍ ESTÁ EL ARREGLO ---
            // Envolvemos AddHouseForm con Form(key: _houseKey)
            _layout(
              Form(
                key: _houseKey,
                child: AddHouseForm(
                  nameCtrl: _name,
                  descCtrl: _desc,
                  priceCtrl: _price,
                  fileNames: _names,
                  onPick: () => _pickImages(multi: true),
                  onSave: _saveHouse,
                  onCancel: _reset,
                  isEditing: _editId != null,
                ),
              ),
              AdminHouseList(service: _service, onEdit: _editHouse),
            ),

            // Envolvemos AddProjectForm con Form(key: _projKey)
            _layout(
              Form(
                key: _projKey,
                child: AddProjectForm(
                  titleCtrl: _pTitle,
                  locCtrl: _pLoc,
                  descCtrl: _pDesc,
                  fileName: _names.isNotEmpty ? _names.first : null,
                  onPick: () => _pickImages(multi: false),
                  onSave: _saveProj,
                  onCancel: _reset,
                  isEditing: _editId != null,
                ),
              ),
              AdminProjectList(service: _service, onEdit: _editProj),
            ),
          ],
        ),
      ),
    );
  }

  Widget _layout(Widget form, Widget list) => Row(
    children: [
      SizedBox(
        width: 400,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: form,
        ),
      ),
      Expanded(
        child: Padding(padding: const EdgeInsets.all(20), child: list),
      ),
    ],
  );
}
