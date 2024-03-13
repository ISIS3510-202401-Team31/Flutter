class Restaurant {
  final String imageUrl;
  final String logoUrl;
  final String name;
  final bool isOpen;
  final double distance;
  final double rating;
  final double avgPrice;
  final String foodType;
  final String phoneNumber;
  final String workingHours;
  final int likes;
  final String address;
  final String addressDetail;

  Restaurant({
    required this.imageUrl,
    required this.logoUrl,
    required this.name,
    required this.isOpen,
    required this.distance,
    required this.rating,
    required this.avgPrice,
    required this.foodType,
    required this.phoneNumber,
    required this.workingHours,
    required this.likes,
    required this.address,
    required this.addressDetail,
  });
}