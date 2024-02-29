import 'package:flutter/material.dart';

class CustomCircledButton extends StatelessWidget {
  final double diameter;
  final VoidCallback onPressed;
  final Icon icon;
  final Color buttonColor;

  CustomCircledButton(
      {required this.onPressed,
      required this.diameter,
      required this.icon,
      required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
          shape: MaterialStateProperty.all<CircleBorder>(CircleBorder()),
          minimumSize:
              MaterialStateProperty.all<Size>(Size(diameter, diameter))),
      child: icon,
    );
  }
}
