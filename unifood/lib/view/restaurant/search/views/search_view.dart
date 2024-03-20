import 'package:flutter/material.dart';
import 'package:unifood/model/restaurant_entity.dart';
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
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              final restaurants = snapshot.data!;
              _restaurantList = restaurants;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: restaurants
                        .map((restaurant) => RestaurantLogo(
                              logo: restaurant.logoUrl,
                              id: restaurant.id,
                            ))
                        .toList(),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Container(
                    height: 1,
                    color: Colors.grey,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Expanded(
                    child: _buildRestaurantCards(restaurants),
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
