import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/house_model.dart';
import '../models/project_model.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- AUTH ---
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      debugPrint("Auth Error: $e");
      return null;
    }
  }

  // --- STORAGE (CORREGIDO PARA EVITAR ERROR QUIC) ---
  Future<String> uploadImage(
    Uint8List fileBytes,
    String fileName,
    String folder,
  ) async {
    try {
      Reference ref = _storage.ref().child('$folder/$fileName');

      // ESTA LÍNEA ES LA QUE FALTABA Y SOLUCIONA EL ERROR EN WEB:
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName},
      );

      // Usamos putData CON metadata
      UploadTask uploadTask = ref.putData(fileBytes, metadata);
      TaskSnapshot snap = await uploadTask;
      return await snap.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error subiendo imagen: $e");
      rethrow;
    }
  }

  // --- CONTENT ---
  Stream<DocumentSnapshot> getWebContent() =>
      _db.collection('settings').doc('content').snapshots();

  // --- HOUSES ---
  Stream<QuerySnapshot> getModels() => _db.collection('models').snapshots();

  Future<void> addHouseModel(HouseModel house) async =>
      await _db.collection('models').add(house.toMap());

  Future<void> updateHouseModel(HouseModel house) async =>
      await _db.collection('models').doc(house.id).update(house.toMap());

  Future<void> deleteHouseModel(String id) async =>
      await _db.collection('models').doc(id).delete();

  // --- PROJECTS ---
  Stream<List<ProjectModel>> getProjects() {
    return _db
        .collection('projects')
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => ProjectModel.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  Future<void> addProject(ProjectModel project) async =>
      await _db.collection('projects').add(project.toMap());

  Future<void> updateProject(ProjectModel project) async =>
      await _db.collection('projects').doc(project.id).update(project.toMap());

  Future<void> deleteProject(String id) async =>
      await _db.collection('projects').doc(id).delete();
}
