class WebContent {
  final String aboutUs;
  final String mission;
  final String vision;

  WebContent({
    required this.aboutUs,
    required this.mission,
    required this.vision,
  });

  factory WebContent.fromMap(Map<String, dynamic> data) {
    return WebContent(
      aboutUs: data['aboutUs'] ?? "Cargando información...",
      mission: data['mission'] ?? "Cargando información...",
      vision: data['vision'] ?? "Cargando información...",
    );
  }
}
