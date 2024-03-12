import 'package:flutter/material.dart';

class TotalPointsWidget extends StatelessWidget {
  final int totalPoints;
  final String assetImagePath = 'assets/images/star.png'; // Use your own asset image path

  const TotalPointsWidget({required this.totalPoints, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor, // Match the background color of the scaffold
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
              padding: const EdgeInsets.all(10.0), // Padding inside the container
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    assetImagePath,
                    width: 36,
                    height: 36,
                  ),
                  const SizedBox(width: 20), // Space between the image and the text
                  const Expanded(
                    child: Text(
                      'Total points available',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    height: 40, // Height of the vertical line
                    width: 1,
                    color: Colors.grey,
                    margin: const EdgeInsets.only(left: 10, right: 20), // Adjusted margins to move the line to the left
                  ),
                  Text(
                    '$totalPoints',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, thickness: 1), // Line separation
        ],
      ),
    );
  }
}
