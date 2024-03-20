import 'package:flutter/material.dart';
import 'package:unifood/utils/string_utils.dart';

class CustomSuggestedRestaurant extends StatelessWidget {
  final String restaurantName;
  final String restaurantImage;
  final double restaurantPrice;
  final VoidCallback onTap;

  const CustomSuggestedRestaurant({
    Key? key,
    required this.restaurantName,
    required this.restaurantImage,
    required this.restaurantPrice,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        width: screenWidth * 0.48, // Ancho del contenedor
        child: Card(
          elevation: 0, 
          color: Colors.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12), bottom: Radius.circular(12)), // Solo los bordes superiores
                child: Image.network(
                  restaurantImage,
                  height: screenHeight * 0.13,
                  fit: BoxFit.cover, // Ajuste de la imagen
                ),
              ),
              // Área de texto con padding que ocupa el 20% del alto del Card
              Padding(
                padding: const EdgeInsets.all(7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      restaurantName,
                      style: TextStyle(
                        fontSize: screenHeight *
                            0.015, // Tamaño del texto del nombre del restaurante
                        fontWeight: FontWeight.bold, // Negrita
                      ),
                    ),
                    Text(
                      formatNumberWithCommas(restaurantPrice),
                      style: TextStyle(
                        fontSize: screenHeight *
                            0.015, // Tamaño del texto de la ubicación del restaurante
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
