import 'package:flutter/material.dart';

class RestaurantLogo extends StatelessWidget {
  final String logo;

  const RestaurantLogo({
    Key? key,
    required this.logo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage('assets/elcarnal_logo.jpeg'),
          ),
        );
  }
}