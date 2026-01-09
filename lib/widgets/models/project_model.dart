class ProjectModel {
  final String id;
  final String title;
  final String description; // Aquí irá la "historia"
  final String imageUrl;
  final String location; // Añadimos ubicación para dar realismo
  final DateTime date; // Para ordenar por la más reciente

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.date,
  });

  // Para convertir los datos de Firebase (JSON) a nuestro objeto Dart
  factory ProjectModel.fromMap(Map<String, dynamic> map, String id) {
    return ProjectModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      location: map['location'] ?? '',
      date: map['date'] != null ? DateTime.parse(map['date']) : DateTime.now(),
    );
  }

  // Para enviar los datos a Firebase
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'location': location,
      'date': date.toIso8601String(),
    };
  }
}
