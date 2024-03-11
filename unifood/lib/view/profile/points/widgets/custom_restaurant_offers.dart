import 'package:flutter/material.dart';

class CustomRestaurantOffers extends StatelessWidget {
  final String imageUrl;
  final String logoUrl;
  final String name;
  final bool isOpen;
  final double distance;
  final double rating;
  final double avgPrice;

  const CustomRestaurantOffers({
    super.key,
    required this.imageUrl,
    required this.logoUrl,
    required this.name,
    required this.isOpen,
    required this.distance,
    required this.rating,
    required this.avgPrice,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/offers');
      },
      child: SizedBox(
        width: screenWidth * 0.9,
        height: screenHeight * 0.17,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                children: [
                  Image.asset(
                    imageUrl,
                    width: double.infinity,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: const Color(0xFFE2D2B4),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundImage: AssetImage(logoUrl),
                              ),
                              const SizedBox(width: 7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    isOpen ? 'Open' : 'Closed',
                                    style: const TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('${avgPrice.toStringAsFixed(1)} k', style: TextStyle(fontSize: 8.0, color: Colors.grey[600])),
                              Text('${distance.toStringAsFixed(1)} km away', style: TextStyle(fontSize: 8.0, color: Colors.grey[600])),
                              Text(rating.toStringAsFixed(1), style: TextStyle(fontSize: 8.0, color: Colors.grey[600])),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 5, // Adjusted to position above the card's bottom edge
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/offers');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[300], // Button color
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'See Offers',
                      style: TextStyle(
                        color: Colors.black, // Text color
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
