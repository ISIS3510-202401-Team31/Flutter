import 'package:flutter/material.dart';

class CustomSettingOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  const CustomSettingOption({
    required this.icon,
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onPressed, 
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        margin:  EdgeInsets.symmetric(vertical: screenHeight * 0.0095 ),
        padding:  EdgeInsets.symmetric(vertical: screenHeight * 0.0225 , horizontal: screenWidth * 0.04),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
               Icon(icon, color: const Color.fromARGB(255, 128, 126, 126), size: screenHeight * 0.0225,),
               SizedBox(width: screenWidth * 0.035),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: screenHeight * 0.0215,
                    color: const Color.fromARGB(255, 128, 126, 126),
                  ),
                ),
              ],
            ),
            Icon(Icons.chevron_right, color: Colors.black, size: screenHeight * 0.025),
          ],
        ),
      ),
    );
  }
}
