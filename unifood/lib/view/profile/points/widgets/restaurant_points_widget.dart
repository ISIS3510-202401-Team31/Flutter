import 'package:flutter/material.dart';
import 'package:unifood/view/profile/points/widgets/build_header_points.dart';

class RestaurantPoints {
  final String imagePath;
  final int earnedPoints;
  final int redeemedPoints;
  final int availablePoints;

  RestaurantPoints({
    required this.imagePath,
    required this.earnedPoints,
    required this.redeemedPoints,
    required this.availablePoints,
  });
}

class RestaurantPointsWidget extends StatefulWidget {
  final List<RestaurantPoints> restaurantPointsList;

  const RestaurantPointsWidget({Key? key, required this.restaurantPointsList}) : super(key: key);

  @override
  _RestaurantPointsWidgetState createState() => _RestaurantPointsWidgetState();
}

class _RestaurantPointsWidgetState extends State<RestaurantPointsWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Usar MediaQuery para ajustar dinámicamente el tamaño y el espacio
    final screenWidth = MediaQuery.of(context).size.width;
    final imageSize = screenWidth * 0.1; // Ajusta el tamaño de la imagen basado en el ancho de pantalla
    final fontSize = screenWidth * 0.04; // Ajusta el tamaño del texto basado en el ancho de pantalla
    final iconSize = screenWidth * 0.08; // Ajusta el tamaño del ícono basado en el ancho de pantalla

    final pointsToShow = _isExpanded ? widget.restaurantPointsList : widget.restaurantPointsList.take(3).toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(width: imageSize), // Usa imageSize para ajustar el espacio para la imagen
              CustomHeaderWidget (text: 'Earned', fontSize: MediaQuery.of(context).size.width * 0.04,),
              CustomHeaderWidget (text: 'Redeemed', fontSize: MediaQuery.of(context).size.width * 0.04,),
              CustomHeaderWidget (text: 'Available', fontSize: MediaQuery.of(context).size.width * 0.04,),
            ],
          ),
          SizedBox(height: screenWidth * 0.03), // Ajusta el espacio vertical basado en el ancho de pantalla
          ...pointsToShow.map((point) => Padding(
            padding: EdgeInsets.only(bottom: screenWidth * 0.05), // Ajusta el espacio entre filas basado en el ancho de pantalla
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: imageSize, // Usa imageSize para el tamaño de la imagen
                  height: imageSize, // Usa imageSize para el tamaño de la imagen
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(point.imagePath),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                _buildPoints(point.earnedPoints, fontSize),
                _buildPoints(point.redeemedPoints, fontSize),
                _buildPoints(point.availablePoints, fontSize),
              ],
            ),
          )).toList(),
          if (widget.restaurantPointsList.length > 3) // Solo muestra el botón si hay más de 3 puntos
            IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, size: iconSize, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
        ],
      ),
    );
  }



  Widget _buildPoints(int points, double fontSize) {
    return Expanded(
      flex: 2,
      child: Text(
        '$points',
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
      ),
    );
  }
}
