import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/model/user_entity.dart';
import 'package:unifood/repository/user_repository.dart';
import 'package:unifood/view/restaurant/favorites/widgets/suggestions_list.dart';
import 'package:unifood/view/widgets/custom_appbar.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';
import 'package:unifood/view/restaurant/dashboard/widgets/custom_restaurant.dart';
import 'package:unifood/view_model/restaurant_view_model.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late Future<List<dynamic>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    final restaurantInfoData = await RestaurantViewModel().getRestaurants();
    final user = await UserRepository().getUserSession();

    return [restaurantInfoData, user];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: dataFuture,
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
          return Scaffold(
            body: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        } else if (snapshot.hasData) {
          final Users? currentUser = snapshot.data![1];
          final List<Restaurant> favoriteRestaurants = snapshot.data![0];

          return _FavoritesWidget(currentUser!, favoriteRestaurants);
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
}

class _FavoritesWidget extends StatefulWidget {
  final Users currentUser;
  final List<Restaurant> favoriteRestaurants;

  const _FavoritesWidget(this.currentUser, this.favoriteRestaurants);

  @override
  _FavoritesWidgetState createState() => _FavoritesWidgetState();
}

class _FavoritesWidgetState extends State<_FavoritesWidget> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
        padding: EdgeInsets.only(top: screenHeight * 0.015, left: screenWidth * 0.04, right: screenWidth * 0.04),
        child: Column(
          children: [
            SuggestedRestaurantsSection(userId: widget.currentUser.uid),
            SizedBox(height: screenHeight * 0.025),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Favorite Restaurants',
                  style: TextStyle(fontFamily: 'KeaniaOne', fontSize: screenWidth * 0.06),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/restaurant_search');
                  },
                  icon: Icon(
                    Icons.search_rounded,
                    size: screenWidth * 0.08,
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: screenWidth * 0.1, right: screenWidth * 0.025),
              height: screenHeight * 0.005,
              color: const Color(0xFF965E4E),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              color: const Color(0xFF965E4E).withOpacity(0.15),
              height: screenHeight * 0.4,
              child: SingleChildScrollView(
                child: Column(
                  children: widget.favoriteRestaurants.map((restaurant) {
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
            ),
          ],
        ),
      ),
    );
  }
}
