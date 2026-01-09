class WebContent {
  final String aboutUs;
  final String mission;
  final String vision;

  WebContent({
    required this.aboutUs,
    required this.mission,
    required this.vision,
  });

  // Transforma lo que viene de Firebase (Mapa) en este objeto de Flutter
  factory WebContent.fromMap(Map<String, dynamic> data) {
    return WebContent(
      aboutUs: data['aboutUs'] ?? "Cargando información...",
      mission: data['mission'] ?? "Cargando información...",
      vision: data['vision'] ?? "Cargando información...",
    );
  }
}
