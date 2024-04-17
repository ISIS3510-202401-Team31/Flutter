import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String userImage;
  final String name;
  final String comment;
  final double rating;

  const ReviewCard({
    Key? key,
    required this.userImage,
    required this.name,
    required this.rating,
    required this.comment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Card(
      elevation: 3,
      color: Colors.white,
      child: SizedBox(
        width: screenWidth * 0.9,
        height: screenHeight * 0.10,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: screenHeight * 0.035,
                    backgroundImage: CachedNetworkImageProvider(userImage),
                  ),
                  SizedBox(width: screenWidth * 0.025),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style:  TextStyle(
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Text(
                                  rating.toString(),
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                                 SizedBox(width: screenWidth * 0.01),
                                 Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: screenWidth * 0.035,
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          comment,
                          style:  TextStyle(
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
