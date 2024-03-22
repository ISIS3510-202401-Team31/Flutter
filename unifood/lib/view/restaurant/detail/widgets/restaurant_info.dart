import 'package:flutter/material.dart';
import 'package:unifood/model/restaurant_entity.dart';
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
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.04,
                      left: screenWidth * 0.08,
                      right: screenWidth * 0.08),
                  child: Image.network(
                    widget.restaurant.imageUrl,
                    height: screenHeight * 0.12,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: screenHeight * 0.02,
                      left: screenWidth * 0.08,
                      right: screenWidth * 0.08),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: screenHeight * 0.028,
                        backgroundImage:
                            NetworkImage(widget.restaurant.logoUrl),
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
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.restaurant.likes.toString(),
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
          ),
        ],
      ),
    );
  }
}
