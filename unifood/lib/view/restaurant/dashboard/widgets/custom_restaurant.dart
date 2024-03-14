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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double basePadding = screenWidth * 0.01;
    double avatarRadius = screenWidth * 0.04;
    double fontSize = screenWidth * 0.027;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/restaurant_detail');
      },
      child: Card(
        child: Container(
          width: screenWidth * 0.9,
          height: screenHeight * 0.16,
          child: Column(
            children: [
              Expanded(
                flex: 2, // Asigna más espacio a la imagen
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                flex: 1, // Asigna espacio proporcional a los detalles
                child: Container(
                  color: const Color(0xFFE2D2B4),
                  child: Padding(
                    padding: EdgeInsets.all(basePadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: avatarRadius,
                              backgroundImage: NetworkImage(logoUrl),
                            ),
                            SizedBox(width: screenWidth * 0.02),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Alinea los textos verticalmente al centro
                              children: [
                                Text(
                                  name,
                                  style: TextStyle(
                                    fontSize: fontSize,
                                    color: Colors.black,
                                    fontFamily: 'Gudea',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  isOpen ? 'Open' : 'Closed',
                                  style: TextStyle(
                                    fontSize: fontSize * 0.8,
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
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Alinea verticalmente al centro
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.wallet,
                                  color: Colors.black,
                                  size: fontSize * 0.8,
                                ),
                                SizedBox(width: screenWidth * 0.005),
                                Text(
                                  '${avgPrice.toStringAsFixed(1)} k',
                                  style: TextStyle(
                                    fontSize: fontSize * 0.8,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                  size: fontSize * 0.8,
                                ),
                                SizedBox(width: screenWidth * 0.005),
                                Text(
                                  '${distance.toStringAsFixed(1)} km away',
                                  style: TextStyle(
                                    fontSize: fontSize * 0.8,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  color: Colors.black,
                                  size: fontSize * 0.8,
                                ),
                                SizedBox(width: screenWidth * 0.005),
                                Text(
                                  rating.toStringAsFixed(1),
                                  style: TextStyle(
                                    fontSize: fontSize * 0.8,
                                    color: Colors.grey.shade600,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
