import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unifood/model/plate_entity.dart';
import 'package:unifood/model/review_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/view/restaurant/detail/widgets/reviews_section/review_list.dart';
import 'package:unifood/view/restaurant/plateDetail/widgets/plate_info.dart';
import 'package:unifood/view/restaurant/plateDetail/widgets/ranking_info.dart';
import 'package:unifood/view/widgets/custom_appbar_builder.dart';
import 'package:unifood/controller/plate_controller.dart';
import 'package:unifood/controller/review_controller.dart';
import 'package:connectivity/connectivity.dart';

class PlateDetail extends StatefulWidget {
  final String plateId;
  final String restaurantId;

  const PlateDetail(
      {Key? key, required this.plateId, required this.restaurantId})
      : super(key: key);

  @override
  _PlateDetailState createState() => _PlateDetailState();
}

class _PlateDetailState extends State<PlateDetail> {
  late Future<List<dynamic>> dataFuture;
  late bool _isConnected;
  // ignore: unused_field
  late StreamSubscription _connectivitySubscription;
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _stopwatch.start();
    dataFuture = fetchData();

    _connectivitySubscription = Connectivity()
       .onConnectivityChanged
       .listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result!= ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    debugPrint(
        'Time spent on the page: ${_stopwatch.elapsed.inSeconds} seconds');
    AnalyticsRepository().saveScreenTime({
      'screen': 'Plate Detail',
      'time': _stopwatch.elapsed.inSeconds
    });
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<List<dynamic>> fetchData() {
    return PlateController()
        .getPlateById(widget.plateId, widget.restaurantId)
        .then((plateInfoData) {
      return ReviewController()
          .getReviewsByPlateId(widget.plateId, widget.restaurantId)
          .then((reviewsData) {
        return [plateInfoData, reviewsData];
      });
    });
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
        ).build(context),
      ),
      body: _isConnected
          ? FutureBuilder<List<dynamic>>(
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
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final Plate plate = data[0];
                  final List<Review> reviews = data[1];
                  return NotificationListener<ScrollUpdateNotification>(
                    onNotification: (notification) {
                      _onUserInteraction("Plate Detail", "Scroll");
                      return true;
                    },
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            PlateInfo(plate: plate),
                            RankingInfo(characteristics: plate.ranking),
                            ReviewList(reviews: reviews),
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
            )
          : _buildNoInternetWidget(screenWidth, screenHeight),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20.0),
          Text(
            'Oops! No Internet Connection',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
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
              'Refresh',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
