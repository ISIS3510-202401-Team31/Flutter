import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:unifood/controller/review_controller.dart';
import 'package:unifood/model/review_entity.dart';
import 'package:unifood/view/restaurant/detail/widgets/reviews_section/review_card.dart';
import 'package:unifood/view/widgets/custom_appbar_builder.dart';

class MyReviews extends StatefulWidget {
  @override
  _MyReviewsState createState() => _MyReviewsState();
}

class _MyReviewsState extends State<MyReviews> {
  final ReviewController _reviewController = ReviewController();
  late StreamSubscription<List<Review?>> _reviewSubscription;
  late List<Review?> _reviews = [];
  String _filterName = '';
  double? _filterRating;
  late bool _isConnected;
  late StreamSubscription _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    _reviewController.getReviewsByUserId();

    _reviewSubscription = _reviewController.reviewsByUserId.listen((reviews) {
      setState(() {
        _reviews = reviews;
      });
    });

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  List<Review?> getFilteredReviews() {
    List<Review?> filteredReviews = _reviews;
    if (_filterName.isNotEmpty) {
      filteredReviews = filteredReviews
          .where((review) =>
              review!.name.toLowerCase().contains(_filterName.toLowerCase()))
          .toList();
    }
    if (_filterRating != null) {
      filteredReviews = filteredReviews
          .where((review) => review!.rating == _filterRating)
          .toList();
    }
    return filteredReviews;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSize = screenWidth * 0.027;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * 0.06),
        child: CustomAppBarBuilder(
          screenHeight: screenHeight,
          screenWidth: screenWidth,
          showBackButton: true,
        )
            .setRightWidget(
              Row(
                children: [
                  Center(
                    child: Text(
                      'My reviews',
                      style: TextStyle(
                          fontSize: fontSize * 1.8,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'KeaniaOne'),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.38)
                ],
              ),
            )
            .build(context),
      ),
      body: Stack(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Filter by name',
                              border: InputBorder.none,
                              icon: Icon(Icons.search),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _filterName = value;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: DropdownButton<double>(
                          hint: Text('Filter by rating'),
                          value: _filterRating,
                          onChanged: (value) {
                            setState(() {
                              _filterRating = value;
                            });
                          },
                          items: [null, 1.0, 2.0, 3.0, 4.0, 5.0]
                              .map((rating) => DropdownMenuItem<double>(
                                    value: rating,
                                    child: Text(rating == null
                                        ? 'All'
                                        : rating.toString()),
                                  ))
                              .toList(),
                          underline: SizedBox(), // Remove underline
                          icon: Icon(Icons.arrow_drop_down),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: StreamBuilder<List<Review?>>(
                    stream: _reviewController.reviewsByUserId,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SpinKitThreeBounce(
                            color: Colors.black,
                            size: 30.0,
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        List<Review?> filteredReviews = getFilteredReviews();

                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: filteredReviews.map((review) {
                              return Center(
                                child: ReviewCard(
                                  userImage: review!.userImage,
                                  name: review.name,
                                  rating: review.rating,
                                  comment: review.comment,
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      } else {
                        return const Center(child: Text('No data available.'));
                      }
                    },
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
          if (!_isConnected)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.red,
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8.0),
                    Text(
                      'No Connection. Data might not be updated',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_review');
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.orange,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _reviewSubscription.cancel(); // Cancelar la suscripción al Stream
    _reviewController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
