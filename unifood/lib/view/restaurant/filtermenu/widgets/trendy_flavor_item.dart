// trendy_flavor_item.dart
import 'package:flutter/material.dart';

class TrendyFlavorItem extends StatelessWidget {
  final String imagePath;

  const TrendyFlavorItem({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const double containerWidth = 300.0; // Ajusta según la necesidad de tu diseño.
    const double containerHeight = 50.0; // Ajusta según la necesidad de tu diseño.

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: SizedBox(
          width: containerWidth,
          height: containerHeight,
          child: Image.asset(
            imagePath,
            fit: BoxFit.fill, // La imagen se estirará para llenar el contenedor.
          ),
        ),
      ),
    );
  }
}
