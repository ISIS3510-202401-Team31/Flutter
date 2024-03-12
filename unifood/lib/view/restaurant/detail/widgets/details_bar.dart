import 'package:flutter/material.dart';

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

      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
              '${avgPrice.toStringAsFixed(1)} k'),
          Container(
            height: 40,
            width: 1,
            color: const Color.fromARGB(255, 203, 201, 201),
          ),
          _buildColumnWithDivider('FoodType', Icons.restaurant_menu, foodType),
          Container(
            height: 40,
            width: 1,
            color: const Color.fromARGB(255, 203, 201, 201),
          ),
          _buildColumnWithDivider(
              'Working hours', Icons.access_time, workingHours),
        ],
      ),
    );
  }

  Widget _buildColumnWithDivider(String title, IconData icon, String content) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12),
            ),
            Icon(icon, size: 12),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Text(
            content,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
