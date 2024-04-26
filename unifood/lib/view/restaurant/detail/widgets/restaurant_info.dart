import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/view/restaurant/detail/widgets/details_bar.dart';
import 'package:unifood/view/restaurant/detail/widgets/location_details.dart';
import 'package:unifood/view/restaurant/detail/widgets/rating_stars.dart';

class RestaurantInfo extends StatefulWidget {
  final Restaurant restaurant;

  const RestaurantInfo({Key? key, required this.restaurant}) : super(key: key);

  @override
  _RestaurantInfoState createState() => _RestaurantInfoState();
}

class _RestaurantInfoState extends State<RestaurantInfo> {
  bool _isLiked = false;
  late bool _isConnected;
  // ignore: unused_field
  late StreamSubscription _connectivitySubscription;

  void _onUserInteraction(String feature, String action) {
    final event = {
      'feature': feature,
      'action': action,
    };
    AnalyticsRepository().saveEvent(event);
  }

  void _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkConnectivity();

     _connectivitySubscription = Connectivity()
       .onConnectivityChanged
       .listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result!= ConnectivityResult.none;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * 0.9,
      height: screenHeight * 0.5,
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.25,
            child: Column(
              children: [
                _isConnected
                    ? Container()
                    : Container(
                        padding: EdgeInsets.only(bottom: screenHeight * 0.01),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning,
                              color: Colors.grey,
                              size: screenWidth * 0.05,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'No Connection. Data might not be updated',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.02,
                      left: screenWidth * 0.08,
                      right: screenWidth * 0.08),
                  child: CachedNetworkImage(
                    imageUrl: widget.restaurant.imageUrl,
                    height: screenHeight * 0.12,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const SizedBox.shrink(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.01,
                      left: screenWidth * 0.08,
                      right: screenWidth * 0.08),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: screenHeight * 0.028,
                        backgroundImage: CachedNetworkImageProvider(
                            widget.restaurant.logoUrl),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.restaurant.name,
                              style: TextStyle(
                                fontSize: screenHeight * 0.0225,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.restaurant.phoneNumber,
                              style: TextStyle(fontSize: screenWidth * 0.03),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isLiked = !_isLiked;
                          });
                          _onUserInteraction("Like Restaurant", "Tap");
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _isLiked
                                      ? (widget.restaurant.likes + 1).toString()
                                      : widget.restaurant.likes.toString(),
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.035),
                                ),
                                SizedBox(width: screenWidth * 0.01),
                                Icon(
                                  _isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: _isLiked ? Colors.red : Colors.red,
                                  size: screenWidth * 0.04,
                                ),
                              ],
                            ),
                            RatingStars(
                              rating: widget.restaurant.rating,
                              iconSize: screenWidth * 0.04,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DetailsBar(
            foodType: widget.restaurant.foodType,
            avgPrice: widget.restaurant.avgPrice,
            workingHours: widget.restaurant.workingHours,
          ),
          LocationDetails(
            address: widget.restaurant.address,
            addressDetail: widget.restaurant.addressDetail,
            distance: widget.restaurant.distance,
            latitude: widget.restaurant.latitude,
            longitude: widget.restaurant.longitude,
          ),
        ],
      ),
    );
  }
}
