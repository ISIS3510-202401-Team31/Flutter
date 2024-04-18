import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/view/restaurant/detail/widgets/menu_section/menu_grid.dart';
import 'package:unifood/view/restaurant/detail/widgets/restaurant_info.dart';
import 'package:unifood/view/restaurant/detail/widgets/reviews_section/review_list.dart';
import 'package:unifood/view/widgets/custom_appbar_builder.dart';
import 'package:unifood/view_model/plate_controller.dart';
import 'package:unifood/view_model/restaurant_controller.dart';
import 'package:unifood/view_model/review_controller.dart';

class RestaurantDetail extends StatefulWidget {
  final String restaurantId;
  const RestaurantDetail({Key? key, required this.restaurantId})
      : super(key: key);

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
    final restaurantInfoData =
        await RestaurantController().getRestaurantById(widget.restaurantId);
    final menuItemsData =
        await PlateController().getPlatesByRestaurantId(widget.restaurantId);
    final reviewsData =
        await ReviewController().getReviewsByRestaurantId(widget.restaurantId);

    return [restaurantInfoData, menuItemsData, reviewsData];
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
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.05),
        child: CustomAppBarBuilder(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          showBackButton: true,
        )
            .setRightWidget(
              IconButton(
                icon: Icon(Icons.search, size: screenWidth * 0.07),
                onPressed: () {
                  Navigator.pushNamed(context, "/filtermenu");
                  _onUserInteraction("Menu Search", "Tap");
                },
              ),
            )
            .build(context),
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
                        setState(() {
                          dataFuture = fetchData();
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final data = snapshot.data!;
            final restaurantInfo = RestaurantInfo(restaurant: data[0]);
            final menuGrid =
                MenuGrid(menuItems: data[1], restaurantId: widget.restaurantId);
            final reviewList = ReviewList(reviews: data[2]);

            return NotificationListener<ScrollUpdateNotification>(
              onNotification: (notification) {
                _onUserInteraction("Restaurant Detail", "Scroll");
                return true;
              },
              child: Container(
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
