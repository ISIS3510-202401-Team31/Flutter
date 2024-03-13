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
      height: screenHeight * 0.5,
      child: Column(
        children: [
          Container(
            height: screenHeight * 0.25,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.04, left: screenWidth * 0.08, right: screenWidth * 0.08),
                  child: Image.asset(
                    restaurant.imageUrl,
                    height: screenHeight * 0.115,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.02, left: screenWidth * 0.08, right: screenWidth * 0.08),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: screenHeight * 0.028,
                        backgroundImage: AssetImage(restaurant.logoUrl),
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              restaurant.name,
                              style:  TextStyle(
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              restaurant.phoneNumber,
                              style:  TextStyle(fontSize: screenWidth * 0.03),
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
                                style:  TextStyle(fontSize: screenWidth * 0.035),
                              ),
                              SizedBox(width: screenWidth * 0.01),
                               Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: screenWidth * 0.04,
                              ),
                            ],
                          ),
                          RatingStars(
                            rating: restaurant.rating,
                            iconSize: screenWidth * 0.04,
                          ),
                        ],
                      ),
                    ],
                  ),
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
