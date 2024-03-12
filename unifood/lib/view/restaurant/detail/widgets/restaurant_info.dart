import 'package:flutter/material.dart';
import 'package:unifood/model/restaurant_entity.dart';
import 'package:unifood/view/restaurant/detail/widgets/details_bar.dart';
import 'package:unifood/view/restaurant/detail/widgets/location_details.dart';
import 'package:unifood/view/restaurant/detail/widgets/rating_stars.dart';

class RestaurantInfo extends StatelessWidget {
  final Restaurant restaurant;

  const RestaurantInfo({Key? key, required this.restaurant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.9,
      height: screenHeight * 0.62,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
            child: Image.asset(
              restaurant.imageUrl,
              height: screenHeight * 0.2,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.02, left: screenWidth * 0.08, right: screenWidth * 0.08),
            child: Row(
              children: [
                CircleAvatar(
                  radius: screenHeight * 0.035,
                  backgroundImage: AssetImage(restaurant.logoUrl),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        restaurant.phoneNumber,
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
                          restaurant.likes.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(width: 5),
                        const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 16,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    RatingStars(
                      rating: restaurant.rating,
                      iconSize: 16,
                    ),
                  ],
                ),
              ],
            ),
          ),
          DetailsBar(
            foodType: restaurant.foodType,
            avgPrice: restaurant.avgPrice,
            workingHours: restaurant.workingHours,
          ),
          LocationDetails(
            address: restaurant.address,
            addressDetail: restaurant.addressDetail,
            distance: restaurant.distance,
          ),
        ],
      ),
    );
  }
}
