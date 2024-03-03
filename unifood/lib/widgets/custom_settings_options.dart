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
    return  Container(
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromARGB(255, 124, 62, 57), width: 1.5),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: const Color.fromARGB(255, 128, 126, 126)),
                const SizedBox(width: 20),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromARGB(255, 128, 126, 126),
                  ),
                ),
              ],
            ),
            const Icon(Icons.chevron_right, color: Colors.black),
          ],
        ),
    );
  } 
}
