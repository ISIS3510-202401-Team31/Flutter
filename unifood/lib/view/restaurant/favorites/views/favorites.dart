import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unifood/controller/plate_controller.dart';
import 'package:unifood/model/plate_entity.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/repository/user_repository.dart';
import 'package:unifood/view/restaurant/detail/widgets/menu_section/plate_card.dart';
import 'package:unifood/view/restaurant/favorites/widgets/suggestions_list.dart';
import 'package:unifood/view/widgets/custom_appbar_builder.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';
import 'package:unifood/view/restaurant/dashboard/widgets/custom_restaurant.dart';
import 'package:unifood/controller/restaurant_controller.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late Users? userSession;
  late Future<Users?> userData;
  late StreamSubscription<List<Restaurant>> _restaurantSubscription;
  final RestaurantController _restaurantController = RestaurantController();

  @override
  void initState() {
    super.initState();
    userData = fetchUser();
    _restaurantController.fetchRestaurants();
    _restaurantSubscription =
        _restaurantController.restaurants.listen((restaurant) {
      setState(() {});
    });
  }

  Future<Users?> fetchUser() async {
    return UserRepository().getUserSession().then((user) {
      userSession = user;
      return userSession;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<List<Restaurant>>(
      stream: _restaurantController.restaurants,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: SpinKitThreeBounce(
                color: Colors.black,
                size: 30.0,
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return _buildErrorWidget(screenWidth, screenHeight);
        } else if (snapshot.hasData) {
          final Users? currentUser = userSession;
          final List<Restaurant> favoriteRestaurants = snapshot.data!;

          return _FavoritesWidget(
            currentUser!,
            favoriteRestaurants,
            screenHeight,
            screenWidth,
          );
        } else {
          return const Scaffold(
            body: Center(
              child: Text('No data available.'),
            ),
          );
        }
      },
    );
  }

  Widget _buildErrorWidget(double screenWidth, double screenHeight) {
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
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            IconButton(
              icon: Icon(
                Icons.refresh,
                size: MediaQuery.of(context).size.width * 0.08,
              ),
              onPressed: () {
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoritesWidget extends StatefulWidget {
  final Users currentUser;
  final List<Restaurant> favoriteRestaurants;
  final double screenHeight;
  final double screenWidth;

  const _FavoritesWidget(
    this.currentUser,
    this.favoriteRestaurants,
    this.screenHeight,
    this.screenWidth,
  );

  @override
  _FavoritesWidgetState createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends State<_FavoritesWidget> {
  late bool _isConnected;
  late StreamSubscription _connectivitySubscription;
  final Stopwatch _stopwatch = Stopwatch();
  final PlateController _plateController = PlateController();

  void _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _stopwatch.start();

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    debugPrint(
        'Time spent on the page: ${_stopwatch.elapsed.inSeconds} seconds');
    AnalyticsRepository().saveScreenTime(
        {'screen': 'Favorites', 'time': _stopwatch.elapsed.inSeconds});
    _connectivitySubscription.cancel();
    super.dispose();
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
        padding: EdgeInsets.only(
          top: screenHeight * 0.015,
          left: screenWidth * 0.04,
          right: screenWidth * 0.04,
        ),
        child: Column(
          children: [
            if (!_isConnected)
              Container(
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
            NotificationListener<ScrollUpdateNotification>(
              onNotification: (notification) {
                _onUserInteraction("Suggested Restaurants", "Scroll");
                return true;
              },
              child:
                  SuggestedRestaurantsSection(userId: widget.currentUser.uid),
            ),
            SizedBox(height: screenHeight * 0.025),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: screenHeight * 0.007),
                  child: Text(
                    'Suggested plates',
                    style: TextStyle(
                      fontFamily: 'KeaniaOne',
                      fontSize: screenWidth * 0.06,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                left: screenWidth * 0.1,
                right: screenWidth * 0.025,
              ),
              height: screenHeight * 0.005,
              color: const Color(0xFF965E4E),
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
                child: SizedBox(
                  height: screenHeight * 0.425,
                  child: LazyLoadingListView(
                    fetchFunction: () =>
                        _plateController.fetchPlatesByPriceRange(),
                    itemBuilder: (context, plate) {
                      return PlateCard(
                        id: plate.id,
                        restaurantId: plate.restaurantId,
                        imagePath: plate.imagePath,
                        name: plate.name,
                        description: plate.description,
                        price: plate.price,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LazyLoadingListView extends StatefulWidget {
  final Future<List<Plate>> Function() fetchFunction;
  final Widget Function(BuildContext context, Plate item) itemBuilder;

  const LazyLoadingListView({
    required this.fetchFunction,
    required this.itemBuilder,
    Key? key,
  }) : super(key: key);

  @override
  _LazyLoadingListViewState createState() => _LazyLoadingListViewState();
}

class _LazyLoadingListViewState extends State<LazyLoadingListView> {
  late ScrollController _scrollController;
  List<Plate> _plates = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      List<Plate> fetchedPlates = await widget.fetchFunction();
      setState(() {
        _plates.addAll(fetchedPlates);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _plates.length + 1,
      itemBuilder: (context, index) {
        if (index < _plates.length) {
          return widget.itemBuilder(context, _plates[index]);
        } else {
          return _buildProgressIndicator();
        }
      },
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SpinKitThreeBounce(
          color: Colors.black,
          size: 30.0,
        ),
      ),
    );
  }
}
