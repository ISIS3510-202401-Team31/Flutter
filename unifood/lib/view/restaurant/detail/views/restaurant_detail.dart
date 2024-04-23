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
import 'package:connectivity/connectivity.dart';

class RestaurantDetail extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetail({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  _RestaurantDetailState createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  late Future<List<dynamic>> dataFuture = fetchData();
  late bool _isConnected;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
    fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    final restaurantInfoData =
        await RestaurantController().getRestaurantById(widget.restaurantId);

    if (_isConnected) {
      final menuItemsData =
          await PlateController().getPlatesByRestaurantId(widget.restaurantId);
      final reviewsData = await ReviewController()
          .getReviewsByRestaurantId(widget.restaurantId);

      return [restaurantInfoData, menuItemsData, reviewsData];
    }

    return [restaurantInfoData];
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
            return _buildErrorWidget(screenWidth, screenHeight);
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final data = snapshot.data!;
            
            final restaurantInfo = RestaurantInfo(restaurant: data[0]);
            Widget? menuWidget;
            Widget? reviewWidget;

            if (data.length > 1 && _isConnected) {
              menuWidget = MenuGrid(
                menuItems: data[1],
                restaurantId: widget.restaurantId,
              );
            }

            if (data.length > 2) {
              reviewWidget = ReviewList(reviews: data[data.length - 1]);
            }

            return NotificationListener<ScrollUpdateNotification>(
              onNotification: (notification) {
                _onUserInteraction("Restaurant Detail", "Scroll");
                return true;
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    restaurantInfo,
                    if (menuWidget != null) menuWidget,
                    if (reviewWidget != null) reviewWidget,
                    if (!_isConnected)
                      _buildNoInternetWidget(screenWidth, screenHeight),
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
                fontSize: MediaQuery.of(context).size.width * 0.04,
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
                setState(() {
                  dataFuture = fetchData();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoInternetWidget(double screenWidth, double screenHeight) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(screenHeight * 0.07),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              height: 1.0,
              color: Colors.grey[400],
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: screenHeight * 0.05,
                  color: Colors.grey[300],
                ),
                SizedBox(width: 20.0),
                Expanded(
                  child: Text(
                    'There is no connection, no plates and reviews are available. Please try again later',
                    style: TextStyle(
                      fontSize: screenHeight * 0.02,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _checkConnectivity();
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
              ),
              icon: Icon(Icons.refresh, color: Colors.grey[600]),
              label: Text(
                'Retry',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 10.0),
              height: 1.0,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
