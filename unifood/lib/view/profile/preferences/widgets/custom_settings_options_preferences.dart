import 'package:flutter/material.dart';

class CustomSettingOptionWithIcons extends StatelessWidget {
  final List<String> imagePaths;
  final List<String> texts;
  final VoidCallback onPressed;
  final double imageSize;

  const CustomSettingOptionWithIcons({
    required this.imagePaths,
    required this.texts,
    required this.onPressed,
    this.imageSize = 70, // Valor por defecto, ajusta según necesidad
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double itemWidth = imageSize + 20; // Espacio adicional para padding y separación
    double fontSize = screenWidth * 0.035;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
        height: imageSize + fontSize * 3, // Ajustar basado en el tamaño de imagen y texto
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: imagePaths.length,
          itemBuilder: (context, index) {
            return Container(
              width: itemWidth,
              padding: const EdgeInsets.symmetric(horizontal: 10), // Añade un poco de espacio entre los elementos
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imagePaths[index], width: imageSize, height: imageSize),
                  const SizedBox(height: 4), // Espacio entre la imagen y el texto
                  Text(texts[index], style: TextStyle(fontSize: fontSize * 0.9, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
