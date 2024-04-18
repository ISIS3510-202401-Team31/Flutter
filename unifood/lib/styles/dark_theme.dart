// Estilos para el modo oscuro
import 'package:flutter/material.dart';

ThemeData darkTheme() {
  return ThemeData(
      brightness: Brightness.dark,
      primaryColor: const Color(0xFF965E4E), // Color de la marca
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      secondaryHeaderColor: Colors.white,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.grey),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFFE2D2B4)),
        ),
      ));
}
