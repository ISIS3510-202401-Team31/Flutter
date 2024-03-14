import 'package:flutter/material.dart';

class CustomHeaderWidget extends StatelessWidget {
  final String text;
  final double fontSize;

  const CustomHeaderWidget({
    Key? key,
    required this.text,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(fontWeight: FontWeight.normal, fontSize: fontSize),
        ),
      ),
    );
  }
}
