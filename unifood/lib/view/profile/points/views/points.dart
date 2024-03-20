import 'package:flutter/material.dart';
import 'package:unifood/view/profile/points/widgets/restaurant_points_widget.dart';
import 'package:unifood/view/profile/points/widgets/total_points_widget.dart';
import 'package:unifood/view/profile/points/widgets/custom_restaurant_offers.dart';

class Points extends StatelessWidget {
  const Points({super.key});

  @override
  Widget build(BuildContext context) {
    final List<RestaurantPoints> allPoints = [
      RestaurantPoints(
          imagePath: 'assets/images/elcarnal_logo.jpeg',
          earnedPoints: 20,
          redeemedPoints: 0,
          availablePoints: 20),
      RestaurantPoints(
          imagePath: 'assets/images/BW.png',
          earnedPoints: 50,
          redeemedPoints: 20,
          availablePoints: 30),
      RestaurantPoints(
          imagePath: 'assets/images/Randys.jpg',
          earnedPoints: 20,
          redeemedPoints: 0,
          availablePoints: 20),
      RestaurantPoints(
          imagePath: 'assets/images/elcarnal_logo.jpeg',
          earnedPoints: 10,
          redeemedPoints: 5,
          availablePoints: 5),
      RestaurantPoints(
          imagePath: 'assets/images/elcarnal_logo.jpeg',
          earnedPoints: 30,
          redeemedPoints: 10,
          availablePoints: 20),
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.045; 
    final paddingHorizontal = screenWidth * 0.04;

    return Scaffold(
      appBar: AppBar(
        title: const Text('UniFood Points'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const TotalPointsWidget(totalPoints: 300),
            Container(
              margin: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: const Divider(color: Colors.grey, thickness: 1),
            ),
            SizedBox(height: screenWidth * 0.05),
            Padding(
              padding: EdgeInsets.only(left: paddingHorizontal),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Restaurant Points',
                  style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.05),
            RestaurantPointsWidget(restaurantPointsList: allPoints),
            Container(
              margin: EdgeInsets.symmetric(horizontal: paddingHorizontal),
              child: const Divider(color: Colors.grey, thickness: 1),
            ),
            Padding(
              padding: EdgeInsets.all(paddingHorizontal),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Redeem Points',
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
