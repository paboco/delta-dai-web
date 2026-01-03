class HouseModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final double price;

  HouseModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  // Este método es el que le falta a tu código actual:
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
    };
  }

  factory HouseModel.fromFirestore(Map<String, dynamic> data, String id) {
    return HouseModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
    );
  }
}
