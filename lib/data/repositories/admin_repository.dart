import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/house_model.dart';
import '../models/project_model.dart';
import '../services/firebase_service.dart';

class AdminRepository {
  final FirebaseService _service = FirebaseService();

  // --- GUARDAR CASA ---
  Future<void> saveHouse({
    required String? editingId,
    required String name,
    required String description,
    required double price,
    required List<Uint8List> newFiles,
    required List<String> existingImages,
  }) async {
    List<String> imageUrls = [];

    // Si hay archivos nuevos, los subimos
    if (newFiles.isNotEmpty) {
      for (int i = 0; i < newFiles.length; i++) {
        String uniqueName = "${DateTime.now().millisecondsSinceEpoch}_$i.jpg";
        // El await aquí es vital para que suban en orden y no fallen
        String url = await _service.uploadImage(
          newFiles[i],
          uniqueName,
          'models',
        );
        imageUrls.add(url);
      }
    }
    // Si no hay nuevos, pero estamos editando, conservamos las fotos viejas
    else if (editingId != null) {
      imageUrls = existingImages;
    }

    // Si al final no hay fotos (ni nuevas ni viejas), usamos una cadena vacía o placeholder
    // Pero idealmente debería tener algo.

    final house = HouseModel(
      id: editingId ?? '',
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrls.isNotEmpty ? imageUrls.first : "",
      images: imageUrls,
    );

    if (editingId != null) {
      await _service.updateHouseModel(house);
    } else {
      await _service.addHouseModel(house);
    }
  }

  // --- GUARDAR PROYECTO ---
  Future<void> saveProject({
    required String? editingId,
    required String title,
    required String location,
    required String description,
    required Uint8List? newFile,
    required String? currentImageUrl,
  }) async {
    String imageUrl = currentImageUrl ?? "";

    if (newFile != null) {
      String uniqueName = "${DateTime.now().millisecondsSinceEpoch}_proj.jpg";
      imageUrl = await _service.uploadImage(newFile, uniqueName, 'projects');
    }

    final project = ProjectModel(
      id: editingId ?? '',
      title: title,
      location: location,
      description: description,
      imageUrl: imageUrl,
      date: DateTime.now(),
    );

    if (editingId != null) {
      await _service.updateProject(project);
    } else {
      await _service.addProject(project);
    }
  }
}
