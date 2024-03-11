import 'package:flutter/material.dart';

class RestaurantPoints {
  final String imagePath;
  final int earnedPoints;
  final int redeemedPoints;
  final int availablePoints;

  RestaurantPoints({
    required this.imagePath,
    required this.earnedPoints,
    required this.redeemedPoints,
    required this.availablePoints,
  });
}

class RestaurantPointsWidget extends StatelessWidget {
  final List<RestaurantPoints> restaurantPointsList;

  RestaurantPointsWidget({Key? key, required this.restaurantPointsList})
      : super(key: key);

  Widget _buildHeader(String text) {
    return Expanded(
      flex: 2,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2), // Add space between each box
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        alignment: Alignment.center,
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 14)),
      ),
    );
  }

  Widget _buildPoints(int points) {
    return Expanded(
      flex: 2,
      child: Text(
        '$points',
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          const Text(
            'Restaurant Points',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(width: 50), // Adjust for larger image space
              _buildHeader('Earned'),
              _buildHeader('Redeemed'),
              _buildHeader('Available'),
            ],
          ),
          const SizedBox(height: 12),
          ...restaurantPointsList.map((point) => Padding(
            padding: const EdgeInsets.only(bottom: 20.0), // More space between rows
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 50, // Larger image size
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(point.imagePath),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                _buildPoints(point.earnedPoints),
                _buildPoints(point.redeemedPoints),
                _buildPoints(point.availablePoints),
              ],
            ),
          )).toList(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    // Action for "see more" button
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 3.0), // Reduced padding for a tighter fit
                    primary: Colors.black, // Text color
                  ),
                  child: const Text('See more', style: TextStyle(fontSize: 14)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
