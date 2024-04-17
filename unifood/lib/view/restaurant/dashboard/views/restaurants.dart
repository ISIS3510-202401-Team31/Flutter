import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/view/widgets/custom_appbar_builder.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';
import 'package:unifood/view/restaurant/dashboard/widgets/custom_restaurant.dart';
import 'package:unifood/view_model/restaurant_view_model.dart';
import 'package:permission_handler/permission_handler.dart';

class Restaurants extends StatefulWidget {
  const Restaurants({Key? key}) : super(key: key);

  @override
  _RestaurantsState createState() => _RestaurantsState();
}

class _RestaurantsState extends State<Restaurants> {
  bool _locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final PermissionStatus status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      setState(() {
        _locationPermissionGranted = true;
      });
    }
  }

  void _onUserInteraction(String feature, String action) {
    final event = {
      'feature': feature,
      'action': action,
    };
    AnalyticsRepository().saveEvent(event);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.027;

    if (!_locationPermissionGranted) {
      // Si el permiso de ubicación aún no se ha concedido, muestra un indicador de carga
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
          showBackButton: false,
        )
            .setRightWidget(
              Row(
                children: [
                  Container(
                    child: CustomCircledButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/favorites');
                      },
                      diameter: 36,
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.black,
                      ),
                      buttonColor: const Color(0xFF965E4E),
                    ),
                  ),
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
                  'All restaurants',
                  style: TextStyle(
                      fontFamily: 'KeaniaOne', fontSize: fontSize * 1.8),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/restaurant_search');
                    _onUserInteraction("Restaurants Search", "Tap");
                  },
                  icon: Icon(
                    Icons.search_rounded,
                    size: screenHeight * 0.035,
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
            GestureDetector(
              onTap: () {
                _onUserInteraction("All restaurants", "Tap");
              },
              child: NotificationListener<ScrollUpdateNotification>(
                onNotification: (notification) {
                  _onUserInteraction("All restaurants", "Scroll");
                  return true;
                },
                child: SizedBox(
                  height: screenHeight * 0.338,
                  child: FutureBuilder<List<Restaurant>>(
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
                                    size: MediaQuery.of(context).size.width *
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
                        final List<Restaurant> favoriteRestaurants =
                            snapshot.data!;
                        return Container(
                          color: const Color(0xFF965E4E).withOpacity(0.15),
                          height: screenHeight * 0.338,
                          child: SingleChildScrollView(
                            child: Column(
                              children: favoriteRestaurants.map((restaurant) {
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
                          ),
                        );
                      } else {
                        return const Center(child: Text('No data available.'));
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.015),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: Text(
                    'Nearby',
                    style: TextStyle(
                        fontFamily: 'KeaniaOne', fontSize: fontSize * 1.8),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 50, right: 10),
              height: 2,
              color: const Color(0xFF965E4E),
            ),
            SizedBox(height: screenHeight * 0.01),
            GestureDetector(
              onTap: () {
                _onUserInteraction("Nearby restaurants", "Tap");
              },
              child: NotificationListener<ScrollUpdateNotification>(
                onNotification: (notification) {
                  _onUserInteraction("Nearby restaurants", "Scroll");
                  return true;
                },
                child: SizedBox(
                  height: screenHeight * 0.338,
                  child: FutureBuilder<List<Restaurant>>(
                    future: RestaurantViewModel().getRestaurantsNearby(),
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
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        final List<Restaurant> nearbyRestaurants =
                            snapshot.data!;
                        return Container(
                          height: screenHeight * 0.338,
                          color: const Color(0xFF965E4E).withOpacity(0.15),
                          child: SingleChildScrollView(
                            child: Column(
                              children: nearbyRestaurants.map((restaurant) {
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
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.all(screenWidth * 0.05),
                          child: Center(
                            child: Text(
                              'No restaurants available.\nYou are out of service areas',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenHeight * 0.02,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
          ],
        ),
      ),
    );
  }
}
