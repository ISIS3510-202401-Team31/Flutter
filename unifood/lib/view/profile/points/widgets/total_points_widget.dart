import 'package:flutter/material.dart';

class TotalPointsWidget extends StatelessWidget {
  final int totalPoints;
  final String assetImagePath = 'assets/images/star.png'; 

  const TotalPointsWidget({required this.totalPoints, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final double imageSize = screenWidth * 0.08; 
    final double fontSize = screenWidth * 0.04; 

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    assetImagePath,
                    width: imageSize, 
                    height: imageSize, 
                  ),
                  const SizedBox(width: 20), 
                  Expanded(
                    child: Text(
                      'Total points available',
                      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold), 
                    ),
                  ),
                  Container(
                    height: 40, 
                    width: 1,
                    color: Colors.grey,
                    margin: const EdgeInsets.only(left: 10, right: 20),
                  ),
                  Text(
                    '$totalPoints',
                    style: TextStyle(
                      fontSize: fontSize, 
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1),
        ],
      ),
    );
  }
}
