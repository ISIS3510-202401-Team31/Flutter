import 'package:flutter/material.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';
import 'package:unifood/view/restaurant/dashboard/widgets/custom_restaurant.dart';

class Restaurants extends StatelessWidget {
  const Restaurants({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final List<Map<String, dynamic>> restaurants = [
      {
        'imageUrl': 'assets/images/elcarnal_image.jpg',
        'logoUrl': 'assets/images/elcarnal_logo.jpeg',
        'name': 'El Carnal',
        'isOpen': true,
        'distance': 2.3,
        'rating': 3.0,
        'avgPrice': 25.500,
      },
      {
        'imageUrl': 'assets/images/elcarnal_image.jpg',
        'logoUrl': 'assets/images/elcarnal_logo.jpeg',
        'name': 'El Carnal',
        'isOpen': true,
        'distance': 2.3,
        'rating': 3.0,
        'avgPrice': 25.500,
      },
      {
        'imageUrl': 'assets/images/elcarnal_image.jpg',
        'logoUrl': 'assets/images/elcarnal_logo.jpeg',
        'name': 'El Carnal',
        'isOpen': true,
        'distance': 2.3,
        'rating': 3.0,
        'avgPrice': 25.500,
      },
    ];

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 0),
              child: Container(
                padding: const EdgeInsets.only(left: 8),
                height: 45,
                width: 138,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF965E4E),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.food_bank, color: Colors.black),
                    SizedBox(width: 8),
                    Text(
                      'UNIFOOD',
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'KeaniaOne',
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          ],
          flexibleSpace: Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(left: 16, top: 55),
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
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Favorites',
                    style: TextStyle(fontFamily: 'KeaniaOne', fontSize: 22),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/restaurant_search');
                      },
                      icon: const Icon(
                        Icons.search_rounded,
                        size: 25,
                      ))
                ],
              ),
              Container(
                padding: const EdgeInsets.only(left: 50, right: 10),
                height: 2,
                color: const Color(0xFF965E4E),
              ),
              const SizedBox(height: 10),
              Container(
                color: const Color(0xFF965E4E).withOpacity(0.15),
                height: screenHeight * 0.338,
                child: SingleChildScrollView(
                  child: Column(
                    children: restaurants.map((restaurant) {
                      return CustomRestaurant(
                          imageUrl: restaurant['imageUrl'],
                          logoUrl: restaurant['logoUrl'],
                          name: restaurant['name'],
                          isOpen: restaurant['isOpen'],
                          distance: restaurant['distance'],
                          rating: restaurant['rating'],
                          avgPrice: restaurant['avgPrice']);
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 7),
                    child: Text(
                      'Nearby',
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
              Container(
                height: screenHeight * 0.338,
                color: const Color(0xFF965E4E).withOpacity(0.15),
                child: SingleChildScrollView(
                  child: Column(
                    children: restaurants.map((restaurant) {
                      return CustomRestaurant(
                          imageUrl: restaurant['imageUrl'],
                          logoUrl: restaurant['logoUrl'],
                          name: restaurant['name'],
                          isOpen: restaurant['isOpen'],
                          distance: restaurant['distance'],
                          rating: restaurant['rating'],
                          avgPrice: restaurant['avgPrice']);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
