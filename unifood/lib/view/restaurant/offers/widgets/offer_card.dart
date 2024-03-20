import 'package:flutter/material.dart';

class OfferCard extends StatelessWidget {
  final String imagePath;
  final String mainText;
  final String subText;
  final int points;
  final VoidCallback onRedeem;

  const OfferCard({
    Key? key,
    required this.imagePath,
    required this.mainText,
    required this.subText,
    required this.points,
    required this.onRedeem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use MediaQuery to adjust sizes dynamically
    double screenWidth = MediaQuery.of(context).size.width;

    // Adjust font sizes based on screen width
    double titleFontSize = screenWidth < 350 ? 14 : 16;
    double subtitleFontSize = screenWidth < 350 ? 10 : 12;
    double pointsFontSize = screenWidth < 350 ? 12 : 14;
    double buttonFontSize = screenWidth < 350 ? 10 : 12;

    // Adjust padding based on screen width
    EdgeInsets padding = screenWidth < 350 ? const EdgeInsets.all(8.0) : const EdgeInsets.all(12.0);
    EdgeInsets buttonPadding = screenWidth < 350 ? const EdgeInsets.symmetric(horizontal: 12, vertical: 6) : const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mainText,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                  ),
                ),
                SizedBox(height: screenWidth < 350 ? 2 : 4),
                Text(
                  subText,
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: screenWidth < 350 ? 4 : 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$points points',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: pointsFontSize,
                        color: Colors.grey[600]
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onRedeem,
                      style: ElevatedButton.styleFrom(
                        padding: buttonPadding,
                      ),
                      child: Text(
                        'Redeem',
                        style: TextStyle(fontSize: buttonFontSize, color: Colors.black),

                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
