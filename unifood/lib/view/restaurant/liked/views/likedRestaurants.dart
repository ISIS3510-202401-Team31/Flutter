import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unifood/controller/restaurant_controller.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/view/widgets/custom_appbar_builder.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';
import 'package:unifood/view/restaurant/dashboard/widgets/custom_restaurant.dart';
import 'package:permission_handler/permission_handler.dart';

class LikedRestaurants extends StatefulWidget {
  const LikedRestaurants({Key? key}) : super(key: key);

  @override
  _LikedRestaurantsState createState() => _LikedRestaurantsState();
}

class _LikedRestaurantsState extends State<LikedRestaurants> {
  final RestaurantController _restaurantController = RestaurantController();
  bool _locationPermissionGranted = false;
  late bool _isConnected;
  // ignore: unused_field
  late StreamSubscription _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _requestLocationPermission();

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  void _onUserInteraction(String feature, String action) {
    final event = {
      'feature': feature,
      'action': action,
    };
    AnalyticsRepository().saveEvent(event);
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<void> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      setState(() {
        _locationPermissionGranted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.027;

    if (!_locationPermissionGranted) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.06),
        child: CustomAppBarBuilder(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          showBackButton: true,
        )
            .setRightWidget(
              Row(
                children: [
                  Container(
                    child: CustomCircledButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/restaurants');
                        _onUserInteraction("Favorites", "Tap");
                      },
                      diameter: 36,
                      icon: const Icon(
                        Icons.home,
                        color: Colors.black,
                      ),
                      buttonColor: const Color(0xFF965E4E),
                    ),
                  ),
                  Container(
                    child: CustomCircledButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/profile');
                        _onUserInteraction("Profile", "Tap");
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
            )
            .build(context),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.01, left: 20, right: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top 5 Restaurants',
                  style: TextStyle(
                      fontFamily: 'KeaniaOne', fontSize: fontSize * 1.8),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(
                left: 50,
                right: 10,
              ),
              height: 2,
              color: const Color(0xFF965E4E),
            ),
            const SizedBox(height: 10),
            _isConnected
                ? Container()
                : Container(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.warning,
                          color: Colors.grey,
                          size: screenWidth * 0.05,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'No Connection. Data might not be updated',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
            GestureDetector(
                onTap: () {
                  _onUserInteraction("Most liked restaurants", "Tap");
                },
                child: NotificationListener<ScrollUpdateNotification>(
                    onNotification: (notification) {
                      _onUserInteraction("Most liked restaurants", "Scroll");
                      return true;
                    },
                    child: Container(
                      height: screenHeight * 0.75,
                      child: FutureBuilder<List<Restaurant>>(
                        future: _restaurantController.getLikedRestaurants(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: SpinKitThreeBounce(
                                color: Colors.black,
                                size: 30.0,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Padding(
                              padding: EdgeInsets.all(screenWidth * 0.03),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Oops! Something went wrong.\nPlease try again later.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        fontWeight:
                                            FontWeight.bold, // Letra en negrita
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    IconButton(
                                      icon: Icon(
                                        Icons.refresh,
                                        size:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                      ),
                                      onPressed: () {
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else if (snapshot.hasData &&
                              snapshot.data!.isNotEmpty) {
                            List<Restaurant> favorites = snapshot.data!;
                            return Container(
                              color: const Color(0xFF965E4E).withOpacity(0.15),
                              height: screenHeight * 0.338,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: favorites.map((restaurant) {
                                    return CustomRestaurant(
                                      id: restaurant.id,
                                      imageUrl: restaurant.imageUrl,
                                      logoUrl: restaurant.logoUrl,
                                      name: restaurant.name,
                                      isOpen: restaurant.isOpen,
                                      distance: restaurant.distance,
                                      rating: restaurant.likes.toDouble(),
                                      avgPrice: restaurant.avgPrice,
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                          } else {
                            return const Center(
                                child: Text('No data available.'));
                          }
                        },
                      ),
                    ))),
          ],
        ),
      ),
    );
  }
}
