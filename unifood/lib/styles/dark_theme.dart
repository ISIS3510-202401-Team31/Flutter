// Estilos para el modo oscuro
import 'package:flutter/material.dart';

ThemeData darkTheme() {
  return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Color(0xFF965E4E), // Color de la marca
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      secondaryHeaderColor: Colors.white,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.grey),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Color(0xFFE2D2B4)),
        ),
      ));
}
