import 'package:flutter/material.dart';
import 'package:unifood/features/restaurants_filtered/widgets/restaurant_card.dart';
import 'package:unifood/features/restaurants_filtered/widgets/restaurant_logo.dart';
import 'package:unifood/features/restaurants_filtered/widgets/search_app_bar.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final List<String> _dummyRestaurants = [
    'Restaurante 1',
    'Restaurante 2',
    'Restaurante 3',
    'Restaurante 4',
    'Restaurante 5',
  ];

  final List<String> _restaurantLogos = [
    'assets/images/elcarnal_logo.jpeg',
    'assets/images/elcarnal_logo.jpeg',
    'assets/images/elcarnal_logo.jpeg',
  ];

  List<String> _searchResults = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        searchController: _searchController,
        onSearchChanged: _performSearch,
        onBackButtonPressed: () {
          Navigator.pushNamed(context, '/landing');
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _restaurantLogos
                  .map((logo) => RestaurantLogo(logo: logo))
                  .toList(),
            ),
            const SizedBox(height: 16),
            Container(
              height: 1,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildRestaurantCards(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRestaurantCards() {
    List<String> restaurantsToShow =
        _searchResults.isNotEmpty ? _searchResults : _dummyRestaurants;

    if (_searchResults.isEmpty && _searchController.text.isNotEmpty) {
      return const Center(
        child: Text(
          'No results',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: restaurantsToShow.length,
      itemBuilder: (context, index) {
        return RestaurantCard(
          name: restaurantsToShow[index],
          logo: 'assets/images/restaurant_logo1.jpg',
          state: 'Abierto',
        );
      },
    );
  }

  void _performSearch(String query) {
    List<String> results = [];

    if (query.isNotEmpty) {
      results = _dummyRestaurants
          .where((restaurant) =>
              restaurant.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() {
      _searchResults = results;
    });
  }
}
