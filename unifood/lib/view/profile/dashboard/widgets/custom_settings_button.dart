import 'package:flutter/material.dart';

class CustomSettingsButton extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const CustomSettingsButton({
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: Container(
        margin: EdgeInsets.all(screenWidth * 0.025),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: backgroundColor,
        ),
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            color: Colors.white,
            size: screenWidth * 0.06,
          ),
        ),
      ),
    );
  }
}
