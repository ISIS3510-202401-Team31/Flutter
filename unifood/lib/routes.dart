import 'package:flutter/material.dart';
import 'package:unifood/features/auth/views/landing.dart';
import 'package:unifood/features/auth/views/login.dart';
import 'package:unifood/features/auth/views/signup.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Landing());
      case '/login': // Define la ruta para la vista de login
        return MaterialPageRoute(builder: (_) => Login());
      case '/signup': // Define la ruta para la vista de signup
        return MaterialPageRoute(builder: (_) => Signup());
      default:
        return MaterialPageRoute(builder: (_) => Landing());
    }
  }
}
