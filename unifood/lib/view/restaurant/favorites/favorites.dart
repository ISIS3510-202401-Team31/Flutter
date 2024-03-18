import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/view/widgets/custom_appbar.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';
import 'package:unifood/view/restaurant/dashboard/widgets/custom_restaurant.dart';
import 'package:unifood/view_model/restaurant_view_model.dart';

class Favorites extends StatelessWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.06),
        child: CustomAppBar(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          showBackButton: true,
          rightWidget: Row(
            children: [
              Container(
                child: CustomCircledButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  diameter: 36,
                  icon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  buttonColor: const Color(0xFF965E4E),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Favorite Restaurants',
                  style: TextStyle(fontFamily: 'KeaniaOne', fontSize: 22),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/restaurant_search');
                  },
                  icon: const Icon(
                    Icons.search_rounded,
                    size: 25,
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 50, right: 10),
              height: 2,
              color: const Color(0xFF965E4E),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<Restaurant>>(
              future: RestaurantViewModel().getRestaurants(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitThreeBounce(
                      color: Colors.black,
                      size: 30.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final List<Restaurant> favoriteRestaurants = snapshot.data!;

                  return Container(
                    color: const Color(0xFF965E4E).withOpacity(0.15),
                    height: screenHeight * 0.338,
                    child: SingleChildScrollView(
                      child: Column(
                        children: favoriteRestaurants.map((restaurant) {
                          return CustomRestaurant(
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
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available.'));
                }
              },
            ),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 7),
                  child: Text(
                    'Favorite Plates',
                    style: TextStyle(fontFamily: 'KeaniaOne', fontSize: 22),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 50, right: 10),
              height: 2,
              color: const Color(0xFF965E4E),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<Restaurant>>(
              future: RestaurantViewModel().getRestaurants(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SpinKitThreeBounce(
                      color: Colors.black,
                      size: 30.0,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  final List<Restaurant> nearbyRestaurants = snapshot.data!;

                  return Container(
                    height: screenHeight * 0.338,
                    color: const Color(0xFF965E4E).withOpacity(0.15),
                    child: SingleChildScrollView(
                      child: Column(
                        children: nearbyRestaurants.map((restaurant) {
                          return CustomRestaurant(
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
                    ),
                  );
                } else {
                  return const Center(child: Text('No data available.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
