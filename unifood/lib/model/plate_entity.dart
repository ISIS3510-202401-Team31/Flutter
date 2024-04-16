class Plate {
  final String id;
  final String restaurantId;
  final Map<String, dynamic> ranking;
  final String imagePath;
  final String name;
  final String description;
  final double price;

  Plate({
    required this.id,
    required this.restaurantId,
    required this.ranking,
    required this.imagePath,
    required this.name,
    required this.description,
    required this.price,
  });
}
