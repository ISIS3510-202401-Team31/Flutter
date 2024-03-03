import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double iconSize;

  const RatingStars({Key? key, required this.rating, this.iconSize = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (index) {
        return Icon(
          index < rating.floor() ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: iconSize, // Ajusta el tamaño del icono
        );
      }),
    );
  }
}