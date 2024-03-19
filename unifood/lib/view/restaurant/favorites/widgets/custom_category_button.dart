import 'package:flutter/material.dart';

class CustomCategoryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  const CustomCategoryButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth * 0.27,
      height: screenHeight * 0.04,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 1.0, // Controla la elevación del botón
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: screenHeight * 0.013,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
