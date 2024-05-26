import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/view/restaurant/search/widgets/restaurant_card.dart';
import 'package:unifood/view/restaurant/search/widgets/restaurant_logo.dart';
import 'package:unifood/view/restaurant/search/widgets/search_app_bar.dart';
import 'package:unifood/controller/restaurant_controller.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final List<Restaurant> _searchResults = [];
  List<Restaurant> _restaurantList = [];
  late bool _isConnected;
  late StreamSubscription _connectivitySubscription;
  final Stopwatch _stopwatch = Stopwatch();

  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _isLoading = true;

  void _onUserInteraction(String feature, String action) {
    final event = {
      'feature': feature,
      'action': action,
    };
    AnalyticsRepository().saveEvent(event);
  }

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

    // Fetch restaurants only once when the view is initialized
    _fetchRestaurants();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    debugPrint(
        'Time spent on the page: ${_stopwatch.elapsed.inSeconds} seconds');
    AnalyticsRepository().saveScreenTime({
      'screen': 'Search View',
      'time': _stopwatch.elapsed.inSeconds
    });
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Fetch restaurants and cache them
  void _fetchRestaurants() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final List<Restaurant> restaurants =
          await RestaurantController().getRestaurants();
      setState(() {
        _restaurantList = restaurants;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching restaurants: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: SearchAppBar(
        searchController: _searchController,
        onSearchChanged: _performSearch,
        onBackButtonPressed: () {
          Navigator.pushNamed(context, '/restaurants');
          _stopwatch.reset();
          AnalyticsRepository().saveScreenTime({
            'screen': 'Search View',
            'time': _stopwatch.elapsed.inSeconds
          });
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            _isLoading
                ? Center(
                    child: SpinKitThreeBounce(
                      color: Colors.black,
                      size: 30.0,
                    ),
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: NotificationListener<ScrollUpdateNotification>(
                      onNotification: (notification) {
                        _onUserInteraction("Restaurants Search", "Scroll");
                        return true;
                      },
                      child: Row(
                        children: [
                          for (var restaurant in _restaurantList)
                            Padding(
                              padding: EdgeInsets.all(screenWidth * 0.037),
                              child: RestaurantLogo(
                                logo: restaurant.logoUrl,
                                id: restaurant.id,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            SizedBox(height: screenHeight * 0.02),
            Expanded(
              child: _buildRestaurantCards(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCards() {
    List<Restaurant> restaurantsToShow =
        _searchResults.isNotEmpty ? _searchResults : _restaurantList;

    if (restaurantsToShow.isEmpty && _searchController.text.isNotEmpty) {
      return Center(
        child: Text(
          'No results',
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.width * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: restaurantsToShow.length,
      itemBuilder: (context, index) {
        final restaurant = restaurantsToShow[index];
        return RestaurantCard(
          id: restaurant.id,
          name: restaurant.name,
          logo: restaurant.logoUrl,
          state: restaurant.isOpen ? 'Open' : 'Closed',
        );
      },
    );
  }

  void _performSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchResults.clear();
        if (query.isNotEmpty) {
          _searchResults.addAll(_restaurantList.where((restaurant) =>
              restaurant.name.toLowerCase().contains(query.toLowerCase())));
        }
      });
    });
  }
}
