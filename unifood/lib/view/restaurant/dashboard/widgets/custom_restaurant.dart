import 'package:flutter/material.dart';

class CustomRestaurant extends StatelessWidget {
  final String imageUrl;
  final String logoUrl;
  final String name;
  final bool isOpen;
  final double distance;
  final double rating;
  final double avgPrice;

  const CustomRestaurant({
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
    // Obtenemos el ancho de la pantalla con MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/restaurant_detail');
        print('Card presionado!');
      },
      child: SizedBox(
        width: screenWidth * 0.9,
        height: screenHeight * 0.17,
        child: Card(
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0),
          ),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Image.asset(
                    imageUrl,
                    width: double.infinity,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                ],
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
                                  fontFamily: 'Gudea',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                isOpen ? 'Open' : 'Closed',
                                style: const TextStyle(
                                  fontSize: 10.0,
                                  fontFamily: 'Gudea',
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
                          Row(
                            children: [
                              const Icon(
                                Icons.wallet,
                                color: Colors.black,
                                size: 8.0,
                              ),
                              Text(
                                '${avgPrice.toStringAsFixed(1)} k',
                                style: TextStyle(
                                  fontSize: 8.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Colors.black,
                                size: 8.0,
                              ),
                              Text(
                                '${distance.toStringAsFixed(1)} km away',
                                style: TextStyle(
                                  fontSize: 8.0,
                                  color: Colors.grey[600],
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.black,
                                size: 8.0,
                              ),
                              Text(
                                rating.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 8.0,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
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
