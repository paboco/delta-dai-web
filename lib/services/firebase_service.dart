// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
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

  // --- SECCIÓN: STORAGE ---
  Future<String> uploadImage(Uint8List fileBytes, String fileName) async {
    Reference ref = _storage.ref().child('models/$fileName');
    UploadTask uploadTask = ref.putData(fileBytes);
    TaskSnapshot snap = await uploadTask;
    return await snap.ref.getDownloadURL();
  }

  // --- SECCIÓN: FIRESTORE ---
  Stream<DocumentSnapshot> getWebContent() =>
      _db.collection('settings').doc('content').snapshots();

  Future<void> updateContent(String field, String newValue) async {
    await _db.collection('settings').doc('content').update({field: newValue});
  }

  Stream<QuerySnapshot> getModels() => _db.collection('models').snapshots();

  Future<void> addHouseModel(HouseModel house) async {
    try {
      await _db.collection('models').add(house.toMap());
    } catch (e) {
      debugPrint("Error al guardar el modelo: $e");
      rethrow;
    }
  }

  void launchWhatsApp({required String modelName}) {}
}
