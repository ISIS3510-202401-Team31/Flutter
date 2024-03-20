import 'package:flutter/material.dart';
import 'package:unifood/view/restaurant/detail/views/restaurant_detail.dart';

class RestaurantLogo extends StatelessWidget {
  final String logo;
  final String id;

  const RestaurantLogo({
    Key? key,
    required this.logo,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: () {
         Navigator.of(context).push(MaterialPageRoute(builder: (_) => RestaurantDetail(restaurantId: id )));
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: screenWidth * 0.005,
              blurRadius: screenWidth * 0.01,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: screenWidth * 0.07,
          backgroundImage: NetworkImage(logo),
        ),
      ),
    );
  }
}
