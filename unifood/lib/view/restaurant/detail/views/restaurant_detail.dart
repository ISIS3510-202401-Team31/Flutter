import 'dart:async';
import 'package:async/async.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unifood/controller/plate_controller.dart';
import 'package:unifood/controller/restaurant_controller.dart';
import 'package:unifood/controller/review_controller.dart';
import 'package:unifood/model/plate_entity.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/model/review_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/view/restaurant/detail/widgets/menu_section/menu_grid.dart';
import 'package:unifood/view/restaurant/detail/widgets/restaurant_info.dart';
import 'package:unifood/view/restaurant/detail/widgets/reviews_section/review_list.dart';
import 'package:unifood/view/widgets/custom_appbar_builder.dart';

class RestaurantDetail extends StatefulWidget {
  final String restaurantId;

  const RestaurantDetail({Key? key, required this.restaurantId})
      : super(key: key);

  @override
  _RestaurantDetailState createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  final RestaurantController _restaurantViewModel = RestaurantController();
  final PlateController _plateViewModel = PlateController();
  final ReviewController _reviewViewModel = ReviewController();
  late StreamSubscription _subscription;
  late bool _isConnected;
  // ignore: unused_field
  late StreamSubscription _connectivitySubscription;
  Restaurant? _restaurant;
  List<Plate> _plates = [];
  List<Review> _reviews = [];
  final Stopwatch _stopwatch = Stopwatch();


  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    _checkConnectivity();
    _restaurantViewModel.getRestaurantById(widget.restaurantId);
    _plateViewModel.getPlatesByRestaurantId(widget.restaurantId);
    _reviewViewModel.getReviewsByRestaurantId(widget.restaurantId);

    _subscription = StreamGroup.merge([
      _restaurantViewModel.restaurantById,
      _plateViewModel.platesByRestaurantId,
      _reviewViewModel.reviewsByRestaurantId,
    ]).listen((data) {
      setState(() {
        if (data is Restaurant) {
          _restaurant = data;
        } else if (data is List<Plate>) {
          _plates = data;
        } else if (data is List<Review>) {
          _reviews = data;
        }
      });
    });

    _connectivitySubscription = Connectivity()
       .onConnectivityChanged
       .listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result!= ConnectivityResult.none;
      });
    });
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    debugPrint(
        'Time spent on the page: ${_stopwatch.elapsed.inSeconds} seconds');
    AnalyticsRepository().saveScreenTime({
      'screen': 'Restaurant Detail',
      'time': _stopwatch.elapsed.inSeconds
    });
    _restaurantViewModel.dispose();
    _plateViewModel.dispose();
    _reviewViewModel.dispose();
    _subscription.cancel();
    _connectivitySubscription.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
        child: CustomAppBarBuilder(
          screenHeight: MediaQuery.of(context).size.height,
          screenWidth: MediaQuery.of(context).size.width,
          showBackButton: true,
        )
            .setRightWidget(
              IconButton(
                icon: Icon(Icons.search,
                    size: MediaQuery.of(context).size.width * 0.07),
                onPressed: () {
                  Navigator.pushNamed(context, "/filtermenu");
                },
              ),
            )
            .build(context),
      ),
      body: StreamBuilder(
        stream: _restaurantViewModel.restaurantById,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitThreeBounce(
                color: Colors.black,
                size: 30.0,
              ),
            );
          } else if (snapshot.hasError) {
            return _buildErrorWidget(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height);
          } else if (snapshot.hasData) {
            return _buildContent(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height);
          } else {
            return const Center(
              child: Text('No data available.'),
            );
          }
        },
      ),
    );
  }

  Widget _buildContent(double screenWidth, double screenHeight) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_restaurant != null) RestaurantInfo(restaurant: _restaurant!),
        if (_isConnected) MenuGrid(menuItems: _plates, restaurantId: widget.restaurantId),
        if (_isConnected) ReviewList(reviews: _reviews),
        if (!_isConnected)
          _buildNoInternetWidget(screenWidth, screenHeight),
      ],
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
                  _checkConnectivity();
                  _subscription.resume();
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
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              height: 1.0,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20.0),
            Row(
              children: [
                Icon(
                  Icons.error_outline,
                  size: screenHeight * 0.05,
                  color: Colors.grey[300],
                ),
                const SizedBox(width: 20.0),
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
            const SizedBox(height: 20.0),
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
            const SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              height: 1.0,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
