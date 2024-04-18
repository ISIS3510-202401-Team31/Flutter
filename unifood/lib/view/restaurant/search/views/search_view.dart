import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/view/restaurant/search/widgets/restaurant_card.dart';
import 'package:unifood/view/restaurant/search/widgets/restaurant_logo.dart';
import 'package:unifood/view/restaurant/search/widgets/search_app_bar.dart';
import 'package:unifood/view_model/restaurant_view_model.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final List<Restaurant> _searchResults = [];
  List<Restaurant> _restaurantList = [];

  final TextEditingController _searchController = TextEditingController();

  void _onUserInteraction(String feature, String action) {
    final event = {
      'feature': feature,
      'action': action,
    };
    AnalyticsRepository().saveEvent(event);
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
        },
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
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
                          fontSize: MediaQuery.of(context).size.width * 0.04,
                          fontWeight: FontWeight.bold, // Letra en negrita
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
            } else {
              final restaurants = snapshot.data!;
              _restaurantList = restaurants;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: NotificationListener<ScrollUpdateNotification>(
                      onNotification: (notification) {
                        _onUserInteraction("Restaurants Search", "Scroll");
                        return true;
                      },
                      child: Row(
                        children: [
                          for (var restaurant in restaurants)
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
                  NotificationListener<ScrollUpdateNotification>(
                    onNotification: (notification) {
                      _onUserInteraction("Restaurants Search", "Scroll");
                      return true;
                    },
                    child: Expanded(
                      child: _buildRestaurantCards(restaurants),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildRestaurantCards(List<Restaurant> restaurants) {
    List<Restaurant> restaurantsToShow =
        _searchResults.isNotEmpty ? _searchResults : restaurants;

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
    setState(() {
      _searchResults.clear();

      if (query.isNotEmpty) {
        _searchResults.addAll(_restaurantList.where((restaurant) =>
            restaurant.name.toLowerCase().contains(query.toLowerCase())));
      }
    });
  }
}
