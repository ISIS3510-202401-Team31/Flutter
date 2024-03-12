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
      child: SizedBox(
        width: screenWidth * 0.9,
        height: screenHeight * 0.10,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: screenHeight * 0.035,
                    backgroundImage: AssetImage(userImage),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Text(
                                  rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const Icon(
                                  Icons.star,
                                  color: Colors.yellow,
                                  size: 16,
                                ),
                              ],
                            ),
                          ],
                        ),
                        Text(
                          comment,
                          style: const TextStyle(
                            fontSize: 12,
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
