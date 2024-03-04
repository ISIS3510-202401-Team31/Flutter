import 'package:flutter/material.dart';

class DetailsBar extends StatelessWidget {
  const DetailsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
          // Columna 1
          _buildColumnWithDivider('Price', Icons.attach_money, '\$10.99'),
          Container(
            height: 40,
            width: 1,
            color: const Color.fromARGB(255, 203, 201, 201),
          ),
          // Columna 2
          _buildColumnWithDivider('FoodType', Icons.restaurant_menu, 'Mexican'),
          Container(
            height: 40,
            width: 1,
            color: const Color.fromARGB(255, 203, 201, 201),
          ),
          // Columna 3
          _buildColumnWithDivider(
              'Working hours', Icons.access_time, '8:00 AM - 10:00 PM'),
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
