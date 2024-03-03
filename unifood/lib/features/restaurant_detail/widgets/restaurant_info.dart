import 'package:flutter/material.dart';
import 'package:unifood/features/restaurant_detail/widgets/rating_stars.dart';

class RestaurantInfo extends StatelessWidget {
  const RestaurantInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, left: 30, right: 30),
                  child: Image.asset(
                    'assets/elcarnal_image.jpg', // Reemplaza con la ubicación de tu imagen banner
                    height: 150, // Ajusta la altura según tus preferencias
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Fila con el logo, nombre y teléfono
                const Padding(
                  padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                  child: Row(
                    children: [
                      // Imagen del logo
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage('assets/elcarnal_logo.jpeg'),
                      ),
                      // Espaciado entre el logo y el nombre/teléfono
                      SizedBox(width: 20),
                      // Columna con nombre y teléfono
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'El Carnal',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '+123 456 789', // Reemplaza con el número de teléfono real
                              style: TextStyle(
                                  fontSize: 14), // Ajusta el tamaño del texto
                            ),
                          ],
                        ),
                      ),
                      // Columna con likes y estrellas
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                '3',
                                style: TextStyle(
                                    fontSize: 14), // Ajusta el tamaño del texto
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.favorite,
                                color: Colors.red,
                                size: 16, // Ajusta el tamaño del icono
                              ),
                            ],
                          ),
                          SizedBox(height: 5), // Ajusta según tus preferencias
                          // Utilizando el widget RatingBar
                          RatingStars(
                              rating: 4.5,
                              iconSize: 16), // Ajusta el tamaño del icono
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
  }
}