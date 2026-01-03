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
      aboutUs: data['aboutUs'] ?? "Sobre nosotros...",
      mission: data['mission'] ?? "Nuestra misión...",
      vision: data['vision'] ?? "Nuestra visión...",
    );
  }
}
