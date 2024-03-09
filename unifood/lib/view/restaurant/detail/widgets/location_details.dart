import 'package:flutter/material.dart';

class LocationDetails extends StatelessWidget {
  const LocationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 20, left: 30, right: 30),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'CityU, Local 213', // Reemplaza con el número de teléfono real
                  style: TextStyle(fontSize: 14), // Ajusta el tamaño del texto
                ),
                Text(
                  'Cra 13 #1-98', // Reemplaza con el número de teléfono real
                  style: TextStyle(fontSize: 14), // Ajusta el tamaño del texto
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
                    '3km away',
                    style:
                        TextStyle(fontSize: 14), // Ajusta el tamaño del texto
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.location_on,
                    color: Color.fromARGB(255, 129, 128, 128),
                    size: 16, // Ajusta el tamaño del icono
                  ),
                ],
              ),
              SizedBox(height: 5),
            ],
          ),
        ],
      ),
    );
  }
}
