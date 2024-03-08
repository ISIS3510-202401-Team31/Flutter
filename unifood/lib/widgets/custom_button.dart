import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final double height;
  final double width;
  final double fontSize;
  final VoidCallback onPressed;
  final Color textColor;

  const CustomButton(
      {super.key,
      required this.text,
      required this.onPressed,
      required this.height,
      required this.width,
      required this.fontSize,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    Color buttonColor = const Color(0xFFE2D2B4);

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
          foregroundColor: MaterialStateProperty.all<Color>(textColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          minimumSize: MaterialStateProperty.all<Size>(Size(width, height))),
      child: Text(
        text,
        style: TextStyle(
            fontSize: fontSize, // Tamaño de la fuente
            fontFamily: 'Gudea',
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
