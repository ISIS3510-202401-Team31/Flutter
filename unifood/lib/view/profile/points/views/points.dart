import 'package:flutter/material.dart';
import 'package:unifood/view/profile/points/widgets/restaurant_points_widget.dart';
import 'package:unifood/view/profile/points/widgets/total_points_widget.dart';
import 'package:unifood/view/restaurant/dashboard/widgets/custom_restaurant.dart';
import 'package:unifood/view_model/restaurant_controller.dart'; 
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/view_model/points_controller.dart';
import 'package:unifood/model/points_entity.dart';


class PointsView extends StatelessWidget {
  const PointsView({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final fontSize = screenWidth * 0.045;
    final paddingHorizontal = screenWidth * 0.04;

    final Future<List<Points>> pointsFuture = PointsController().fetchPoints();
    return Scaffold(
      appBar: AppBar(
        title: const Text('UniFood Points'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const TotalPointsWidget(totalPoints: 120),
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
            FutureBuilder<List<Points>>(
              future: pointsFuture,  // Use the pre-declared future
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return RestaurantPointsWidget(restaurantPointsList: snapshot.data!);
                } else {
                  return Text('No points available.');
                }
              },
            ),
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
            FutureBuilder<List<Restaurant>>(
              future: RestaurantController().getRestaurants(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: snapshot.data!.map((restaurant) {
                      return CustomRestaurant(
                        id: restaurant.id,
                        imageUrl: restaurant.imageUrl,
                        logoUrl: restaurant.logoUrl,
                        name: restaurant.name,
                        isOpen: restaurant.isOpen,
                        distance: restaurant.distance,
                        rating: restaurant.rating,
                        avgPrice: restaurant.avgPrice,
                      );
                    }).toList(),
                  ),
                  );
                } else {
                  return Center(child: Text('No data available.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
