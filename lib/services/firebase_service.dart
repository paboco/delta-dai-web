// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delta_dai_bim_web/widgets/models/project_model.dart'; // Verifica que la ruta sea widgets/models o solo models
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/house_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- SECCIÓN: AUTENTICACIÓN ---
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint("Error de autenticación: $e");
      return null;
    }
  }

  // --- SECCIÓN: STORAGE REFACTORIZADA ---
  // Ahora le pasamos el folder ('models' o 'projects') para mantener orden
  Future<String> uploadImage(
    Uint8List fileBytes,
    String fileName,
    String folder,
  ) async {
    try {
      Reference ref = _storage.ref().child('$folder/$fileName');
      UploadTask uploadTask = ref.putData(fileBytes);
      TaskSnapshot snap = await uploadTask;
      return await snap.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error al subir imagen: $e");
      rethrow;
    }
  }

  // --- SECCIÓN: FIRESTORE (CONTENIDO GENERAL) ---
  Stream<DocumentSnapshot> getWebContent() =>
      _db.collection('settings').doc('content').snapshots();

  Future<void> updateContent(String field, String newValue) async {
    await _db.collection('settings').doc('content').update({field: newValue});
  }

  // --- SECCIÓN: MODELOS DE CASAS ---
  Stream<QuerySnapshot> getModels() => _db.collection('models').snapshots();

  Future<void> addHouseModel(HouseModel house) async {
    try {
      await _db.collection('models').add(house.toMap());
    } catch (e) {
      debugPrint("Error al guardar el modelo: $e");
      rethrow;
    }
  }

  // --- SECCIÓN DE PROYECTOS (HISTORIAS) ---

  // Obtener todos los proyectos ordenados por fecha
  Stream<List<ProjectModel>> getProjects() {
    return _db
        .collection('projects')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ProjectModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Agregar un nuevo proyecto
  Future<void> addProject(ProjectModel project) async {
    try {
      await _db.collection('projects').add(project.toMap());
    } catch (e) {
      debugPrint("Error al agregar proyecto: $e");
      rethrow;
    }
  }

  // Actualizar un proyecto existente
  Future<void> updateProject(ProjectModel project) async {
    try {
      await _db.collection('projects').doc(project.id).update(project.toMap());
    } catch (e) {
      debugPrint("Error al actualizar proyecto: $e");
      rethrow;
    }
  }

  // Eliminar un proyecto
  Future<void> deleteProject(String id) async {
    try {
      await _db.collection('projects').doc(id).delete();
    } catch (e) {
      debugPrint("Error al eliminar proyecto: $e");
      rethrow;
    }
  }

  void launchWhatsApp({required String modelName}) {
    // Implementación de WhatsApp si fuera necesaria
  }
}
