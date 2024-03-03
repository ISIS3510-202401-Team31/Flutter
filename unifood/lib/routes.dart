import 'package:flutter/material.dart';
import 'package:unifood/features/auth/views/landing.dart';
import 'package:unifood/features/auth/views/login.dart';
import 'package:unifood/features/auth/views/signup.dart';
import 'package:unifood/features/profile/views/profile.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const Landing());
      case '/login': // Define la ruta para la vista de login
        return MaterialPageRoute(builder: (_) => const Login());
      case '/signup': // Define la ruta para la vista de signup
        return MaterialPageRoute(builder: (_) => const Signup());
      case '/profile': // Define la ruta para la vista de perfil
        return MaterialPageRoute(builder: (_) => const Profile());
      default:
        return MaterialPageRoute(builder: (_) => const Landing());
    }
  }
}
