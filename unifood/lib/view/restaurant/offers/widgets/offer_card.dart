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
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image is now expanded to fit the content better vertically
          Expanded(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover, // Cover the area of the card
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mainText,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16, // Smaller font size
                  ),
                ),
                const SizedBox(height: 2), // Reduced space
                Text(
                  subText,
                  style: TextStyle(
                    fontSize: 12, // Smaller font size
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4), // Reduced space
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$points points',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14, // Smaller font size
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onRedeem,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Smaller padding for the button
                      ),
                      child: const Text(
                        'Redeem',
                        style: TextStyle(fontSize: 12), // Smaller text in the button
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
