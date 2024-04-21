import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unifood/model/plate_entity.dart';
import 'package:unifood/model/review_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/view/restaurant/detail/widgets/reviews_section/review_list.dart';
import 'package:unifood/view/restaurant/plateDetail/widgets/plate_info.dart';
import 'package:unifood/view/restaurant/plateDetail/widgets/ranking_info.dart';
import 'package:unifood/view/widgets/custom_appbar_builder.dart';
import 'package:unifood/view_model/plate_controller.dart';
import 'package:unifood/view_model/review_controller.dart';
import 'package:connectivity/connectivity.dart';

class PlateDetail extends StatefulWidget {
  final String plateId;
  final String restaurantId;

  const PlateDetail({Key? key, required this.plateId, required this.restaurantId}) : super(key: key);

  @override
  _PlateDetailState createState() => _PlateDetailState();
}

class _PlateDetailState extends State<PlateDetail> {
  late Future<List<dynamic>> dataFuture;
  late bool _isConnected;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    dataFuture = fetchData();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  Future<List<dynamic>> fetchData() async {
    final plateInfoData = await PlateController().getPlateById(widget.plateId, widget.restaurantId);
    final reviewsData = await ReviewController().getReviewsByPlateId(widget.plateId, widget.restaurantId);
    return [plateInfoData, reviewsData];
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
                },
              ),
            )
            .build(context),
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
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          IconButton(
                            icon: Icon(
                              Icons.refresh,
                              size: screenWidth * 0.08,
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
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Internet Connection',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _checkConnectivity();
                      });
                    },
                    child: Text('Refresh'),
                  ),
                ],
              ),
            ),
    );
  }
}
