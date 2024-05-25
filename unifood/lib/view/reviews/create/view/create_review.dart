import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unifood/controller/restaurant_controller.dart';
import 'package:unifood/controller/review_controller.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/view/reviews/create/widgets/comment_section.dart';
import 'package:unifood/view/reviews/create/widgets/restaurant_dropdown.dart';
import 'package:unifood/view/widgets/custom_appbar_builder.dart';
import 'package:unifood/view/widgets/custom_auth_button.dart';

class RestaurantReviewPage extends StatefulWidget {
  const RestaurantReviewPage({Key? key}) : super(key: key);
  @override
  _RestaurantReviewPageState createState() => _RestaurantReviewPageState();
}

class _RestaurantReviewPageState extends State<RestaurantReviewPage> {
  bool isSubmitted = false;
  int _rating = 0;
  String _comment = '';
  late Future<List<Restaurant>> _restaurantsFuture;
  late Restaurant _selectedRestaurant;
  final RestaurantController _restaurantController = RestaurantController();
  late bool _isConnected;
  late StreamSubscription _connectivitySubscription;
  final Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _stopwatch.start();

    _restaurantsFuture = _restaurantController.getRestaurants();

    _restaurantsFuture.then((restaurants) {
      if (restaurants.isNotEmpty) {
        setState(() {
          _selectedRestaurant = restaurants.first;
        });
      }
    });

    _checkConnectivity();

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    debugPrint(
        'Time spent on the page: ${_stopwatch.elapsed.inSeconds} seconds');
    AnalyticsRepository().saveScreenTime(
        {'screen': 'Add Review', 'time': _stopwatch.elapsed.inSeconds});
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  void _setRating(int rating) {
    setState(() {
      _rating = rating;
    });
  }

  void fetchData() async {
    _restaurantsFuture = _restaurantController.getRestaurants();
  }

  void _submitReview() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a rating.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a comment.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await ReviewController().saveReview(
          _selectedRestaurant.id,
          _selectedRestaurant.logoUrl,
          _selectedRestaurant.name,
          _rating,
          _comment);
      setState(() {
        _rating = 0;
        _comment = '';
        isSubmitted = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Review submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint('Error submitting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit review. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
        child: CustomAppBarBuilder(
          screenHeight: MediaQuery.of(context).size.height,
          screenWidth: MediaQuery.of(context).size.width,
          showBackButton: true,
        ).build(context),
      ),
      backgroundColor: Colors.grey.shade100,
      body: !_isConnected
          ? _buildNoInternetWidget(screenWidth, screenHeight)
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.075),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        'Add your review...',
                        style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: screenHeight * 0.04),
                      Text(
                        'Select a Restaurant',
                        style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      FutureBuilder<List<Restaurant>>(
                        future: _restaurantsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: SpinKitThreeBounce(
                                color: Colors.black,
                                size: 20.0,
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return RestaurantDropdown(
                              initialValue: snapshot.data!.first,
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedRestaurant = newValue!;
                                });
                                debugPrint(
                                    'Selected restaurant: ${_selectedRestaurant.name}');
                              },
                              restaurants: snapshot.data!,
                            );
                          }
                        },
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Text(
                        'Rating:',
                        style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int i = 1; i <= 5; i++)
                            IconButton(
                              icon: Icon(Icons.star,
                                  color: _rating >= i
                                      ? Colors.amber
                                      : Colors.grey),
                              onPressed: () => _setRating(i),
                            ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Text(
                        'Comment:',
                        style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      CommentSection(
                        screenWidth: screenWidth,
                        screenHeight: screenHeight,
                        onCommentChanged: (comment) {
                          setState(() {
                            _comment = comment;
                          });
                        },
                        isSubmitted: isSubmitted,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      CustomAuthButton(
                        text: 'Submit Review',
                        onPressed: () {
                          _submitReview();
                          setState(() {
                            isSubmitted = false;
                          });
                        },
                        height: screenHeight * 0.05,
                        width: screenWidth * 0.1,
                        fontSize: screenHeight * 0.02,
                        textColor: Colors.black,
                      ),
                      SizedBox(height: screenHeight * 0.05),
                    ],
                  ),
                ),
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
                    'There is no connection, this functionality is not available. Please try again later',
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
              icon: Icon(Icons.refresh, size: screenHeight * 0.03),
              label: Text('Try Again',
                  style: TextStyle(fontSize: screenHeight * 0.02)),
            ),
          ],
        ),
      ),
    );
  }
}
