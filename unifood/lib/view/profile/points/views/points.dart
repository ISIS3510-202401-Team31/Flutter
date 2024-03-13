import 'package:flutter/material.dart';
import 'package:unifood/view/profile/points/widgets/restaurant_points_widget.dart';
import 'package:unifood/view/profile/points/widgets/total_points_widget.dart';
import 'package:unifood/view/profile/points/widgets/custom_restaurant_offers.dart'; // Import your CustomRestaurant widget

class Points extends StatelessWidget {
  const Points({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UniFood Points'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const TotalPointsWidget(totalPoints: 300), // Use the previously defined widget
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0), // Small horizontal margin
              child: const Divider(color: Colors.grey, thickness: 1), // The horizontal line
            ),
            RestaurantPointsWidget(
              restaurantPointsList: [
                RestaurantPoints(imagePath: 'assets/images/elcarnal_logo.jpeg', earnedPoints: 20, redeemedPoints: 0, availablePoints: 20),
                RestaurantPoints(imagePath: 'assets/images/BW.png', earnedPoints: 50, redeemedPoints: 20, availablePoints: 30),
                RestaurantPoints(imagePath: 'assets/images/Randys.jpg', earnedPoints: 20, redeemedPoints: 0, availablePoints: 20),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0), // Small horizontal margin
              child: const Divider(color: Colors.grey, thickness: 1), // The horizontal line
            ),
            // Use the CustomRestaurant widget twice for example
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Redeem Points',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // You can choose the color that fits your design
                  ),
                ),
              ),
            ),
            const CustomRestaurantOffers(
              imageUrl: 'assets/images/elcarnal_image.jpg',
              logoUrl: 'assets/images/elcarnal_logo.jpeg',
              name: 'El Carnal',
              isOpen: true,
              distance: 0.2,
              rating: 4.5,
              avgPrice: 12,
            ),
            const CustomRestaurantOffers(
              imageUrl: 'assets/images/elcarnal_image.jpg',
              logoUrl: 'assets/images/elcarnal_logo.jpeg',
              name: 'El Carnal',
              isOpen: true,
              distance: 0.4,
              rating: 4.7,
              avgPrice: 15,
            ),
          ],
        ),
      ),
    );
  }
}
