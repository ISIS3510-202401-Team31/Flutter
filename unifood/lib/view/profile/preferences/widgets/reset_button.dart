import 'package:flutter/material.dart';

class ResetWidget extends StatelessWidget {
  final VoidCallback onReset;

  const ResetWidget({
    Key? key,
    required this.onReset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    double fontSizeAction = width * 0.03;
    double padding = width * 0.02;

    return Padding(
      padding: EdgeInsets.only(
          top: padding,
          bottom: padding,
          left: padding * 0.8,
          right: padding * 0.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment
            .end, // Align to the end similar to the actionText in SectionHeader
        children: [
          GestureDetector(
            onTap: onReset,
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: padding, vertical: padding * 0.5),
              decoration: BoxDecoration(
                color: Colors.red, // Background color set to red
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.refresh, // Example icon, adjust as necessary
                    color: Colors.white,
                    size: fontSizeAction *
                        1.5, // Sizing the icon a bit larger than the text
                  ),
                  SizedBox(width: padding * 0.5), // Space between icon and text
                  Text(
                    "Reset",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSizeAction,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
