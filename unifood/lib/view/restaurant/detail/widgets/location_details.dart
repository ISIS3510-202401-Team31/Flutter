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

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: screenWidth * 0.9,
            height: screenHeight * 0.06, // Adjusted height
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address,
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        addressDetail,
                        style: const TextStyle(fontSize: 14),
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
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.location_on,
                          color: Color.fromARGB(255, 129, 128, 128),
                          size: 14,
                        ),
                      ],
                    ),
                    Flexible(
                      child: CustomButton(
                        text: 'Open in Google Maps',
                        onPressed: () {
                          // Add the desired functionality for the button
                        },
                        height: screenHeight * 0.025, // Adjusted height
                        width: screenWidth * 0.2,
                        fontSize: 10,
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
    );
  }
}
