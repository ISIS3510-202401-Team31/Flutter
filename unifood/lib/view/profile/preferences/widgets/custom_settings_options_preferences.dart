import 'package:flutter/material.dart';

class CustomSettingOptionWithIcons extends StatelessWidget {
  final String imagePath1, imagePath2, imagePath3, imagePath4;
  final VoidCallback onPressed;
  final double imageSize; // Nuevo parámetro para el tamaño de las imágenes

  const CustomSettingOptionWithIcons({
    required this.imagePath1,
    required this.imagePath2,
    required this.imagePath3,
    required this.imagePath4,
    required this.onPressed,
    this.imageSize = 80, // Valor por defecto de 80, ajusta según necesidad
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Añadir margen
        padding: const EdgeInsets.symmetric(vertical: 20),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround, // Distribuir espacio uniformemente
          children: <Widget>[
            Image.asset(imagePath1, width: imageSize),
            Image.asset(imagePath2, width: imageSize),
            Image.asset(imagePath3, width: imageSize),
            Image.asset(imagePath4, width: imageSize),
          ],
        ),
      ),
    );
  }
}
