import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unifood/view/restaurant/detail/widgets/menu_section/menu_grid.dart';
import 'package:unifood/view/restaurant/detail/widgets/restaurant_info.dart';
import 'package:unifood/view/restaurant/detail/widgets/reviews_section/review_list.dart';
import 'package:unifood/view/widgets/custom_circled_button.dart';
import 'package:unifood/view_model/plate_view_model.dart';
import 'package:unifood/view_model/restaurant_view_model.dart';
import 'package:unifood/view_model/review_view_model.dart';

class RestaurantDetail extends StatefulWidget {
  const RestaurantDetail({Key? key}) : super(key: key);

  @override
  _RestaurantDetailState createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  late Future<List<dynamic>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    final restaurantInfoData = await RestaurantViewModel().getRestaurantByName("El Carnal");
    final menuItemsData = await PlateViewModel().getMenuItems();
    final reviewsData = await ReviewViewModel().getReviews();

    return [restaurantInfoData, menuItemsData, reviewsData];
  }

  @override
  Widget build(BuildContext context) {
    
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.025),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            alignment: Alignment.centerLeft,
            margin:  EdgeInsets.only(left: screenWidth*0.015 , top: screenHeight*0.03),
            child: CustomCircledButton(
              onPressed: () {
                Navigator.pushNamed(context, '/landing');
              },
              diameter: 28,
              icon: const Icon(
                Icons.chevron_left_sharp,
                color: Colors.black,
              ),
              buttonColor: Colors.white,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitThreeBounce(
                color: Colors.black,
                size: 30.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Column(
              children: [
                Text('Error: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: () {
                    // Retry fetching data
                    PlateViewModel().getMenuItems();
                  },
                  child: const Text('Retry'),
                ),
              ],
            );
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            final restaurantInfo = RestaurantInfo(restaurant: data[0]);
            final menuGrid = MenuGrid(menuItems: data[1]);
            final reviewList = ReviewList(reviews: data[2]);

            return Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    restaurantInfo,
                    menuGrid,
                    reviewList,
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text('No data available.'),
            );
          }
        },
      ),
    );
  }
}
