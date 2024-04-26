import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:unifood/repository/analytics_repository.dart';
import 'package:unifood/view/widgets/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationDetails extends StatefulWidget {
  final String address;
  final String addressDetail;
  final double distance;
  final String latitude;
  final String longitude;

  const LocationDetails({
    Key? key,
    required this.address,
    required this.addressDetail,
    required this.distance,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  _LocationDetailsState createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
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

    _connectivitySubscription = Connectivity()
       .onConnectivityChanged
       .listen((ConnectivityResult result) {
      setState(() {
        _isConnected = result!= ConnectivityResult.none;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: screenWidth * 0.9,
      height: screenHeight * 0.11,
      child: Padding(
        padding: EdgeInsets.only(
            top: screenWidth * 0.03,
            left: screenWidth * 0.03,
            right: screenWidth * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location',
              style: TextStyle(
                fontSize: screenHeight * 0.0225,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: screenHeight * 0.005),
            SizedBox(
              height: screenHeight * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.address,
                          style: TextStyle(fontSize: screenHeight * 0.016),
                        ),
                        Text(
                          widget.addressDetail,
                          style: TextStyle(fontSize: screenHeight * 0.016),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          _isConnected
                              ? Text(
                                  '${widget.distance.toStringAsFixed(1)} km away',
                                  style:
                                      TextStyle(fontSize: screenHeight * 0.015))
                              : Text('Distance is not available',
                                  style: TextStyle(
                                      fontSize: screenHeight * 0.015)),
                          SizedBox(width: screenWidth * 0.01),
                          Icon(
                            Icons.location_on,
                            color: const Color.fromARGB(255, 129, 128, 128),
                            size: screenHeight * 0.02,
                          ),
                        ],
                      ),
                      Flexible(
                        child: CustomButton(
                          text: 'Open in Map',
                          onPressed: () {
                            if (!_isConnected) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('No Internet'),
                                  content: Text(
                                      'This function is not available without internet connection.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              _launchMaps(widget.latitude, widget.longitude);
                            }
                            _onUserInteraction('Open in Map', 'Tap');
                          },
                          height: screenHeight * 0.025,
                          width: screenWidth * 0.015,
                          fontSize: screenWidth * 0.025,
                          textColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchMaps(latitude, longitude) async {
    // The URL scheme for launching Google Maps with a specific location
    final url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.inAppWebView)) {
      throw Exception('Could not launch $url');
    }
  }
}
