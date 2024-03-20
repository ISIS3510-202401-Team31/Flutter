import 'package:flutter/material.dart';
import 'package:unifood/utils/string_utils.dart';

class DetailsBar extends StatelessWidget {
  final String foodType;
  final double avgPrice;
  final String workingHours;

  const DetailsBar({
    Key? key,
    required this.foodType,
    required this.avgPrice,
    required this.workingHours,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin:  EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
      padding:  EdgeInsets.only(top: screenHeight * 0.015, left: screenWidth * 0.05, right: screenWidth * 0.05),
      width: screenWidth * 0.9,
      height: screenHeight * 0.085,
      
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildColumnWithDivider(' Avg Price', Icons.attach_money,
              formatNumberWithCommas(avgPrice), screenHeight, screenWidth),
          Container(
            height: screenHeight * 0.05,
            width: 1,
            color: const Color.fromARGB(255, 203, 201, 201),
          ),
          _buildColumnWithDivider('FoodType', Icons.restaurant_menu, foodType, screenHeight, screenWidth),
          Container(
            height: screenHeight * 0.05,
            width: 1,
            color: const Color.fromARGB(255, 203, 201, 201),
          ),
          _buildColumnWithDivider(
              'Working hours', Icons.access_time, workingHours, screenHeight, screenWidth),
        ],
      ),
    );
  }

  Widget _buildColumnWithDivider(String title, IconData icon, String content, double height, double width) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style:  TextStyle(fontSize: height * 0.0125),
            ),
            SizedBox(width: width * 0.01),
            Icon(icon, size: height * 0.0125),
          ],
        ),
        Container(
          margin:  EdgeInsets.symmetric(vertical: height*0.0075),
          child: Text(
            content,
            style:  TextStyle(fontWeight: FontWeight.bold, fontSize: height * 0.015),
          ),
        ),
      ],
    );
  }
}
