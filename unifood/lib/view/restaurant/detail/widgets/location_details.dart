import 'package:flutter/material.dart';
import 'package:unifood/view/widgets/custom_button.dart';

class LocationDetails extends StatelessWidget {
  final String address;
  final String addressDetail;
  final double distance;

  const LocationDetails({
    Key? key,
    required this.address,
    required this.addressDetail,
    required this.distance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.11,
      child: Padding(
        padding:  EdgeInsets.only(top: screenWidth*0.03, left:  screenWidth*0.03, right:  screenWidth*0.03),
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
            Container(
              height: screenHeight * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          address,
                          style:  TextStyle(fontSize: screenHeight * 0.017),
                        ),
                        Text(
                          addressDetail,
                          style:  TextStyle(fontSize: screenHeight * 0.017),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${distance.toString()} km away',
                            style:  TextStyle(fontSize: screenHeight * 0.017),
                          ),
                          SizedBox(width: screenWidth * 0.01),
                           Icon(
                            Icons.location_on,
                            color: Color.fromARGB(255, 129, 128, 128),
                            size: screenHeight * 0.02,
                          ),
                        ],
                      ),
                      Flexible(
                        child: CustomButton(
                          text: 'Open in Map',
                          onPressed: () {
                            // Add the desired functionality for the button
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
}
