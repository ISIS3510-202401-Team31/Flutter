class Reservation {
  final String id;
  final String restaurantName;
  final DateTime dateTime;
  final int numberOfPeople;
  final String logoUrl;

  Reservation({
    required this.id,
    required this.restaurantName,
    required this.dateTime,
    required this.numberOfPeople,
    required this.logoUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantName': restaurantName,
      'dateTime': dateTime.toIso8601String(),
      'numberOfPeople': numberOfPeople,
      'logoUrl': logoUrl,
    };
  }

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      restaurantName: json['restaurantName'],
      dateTime: DateTime.parse(json['dateTime']),
      numberOfPeople: json['numberOfPeople'],
      logoUrl: json['logoUrl'],
    );
  }
}
