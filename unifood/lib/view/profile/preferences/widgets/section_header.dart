import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onTap;

  const SectionHeader({
    Key? key,
    required this.title,
    required this.actionText,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;


    double fontSizeTitle = width * 0.045; 
    double fontSizeAction = width * 0.03; 
    double padding = width * 0.02; 

    return Padding(
      padding: EdgeInsets.only(top: padding, bottom: padding, left: padding * 0.8, right: padding * 0.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: fontSizeTitle,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(padding * 0.4), // Ajusta el padding del contenedor de acción
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                actionText,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSizeAction,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
