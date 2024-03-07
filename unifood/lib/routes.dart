import 'package:flutter/material.dart';
import 'package:unifood/features/auth/views/landing.dart';
import 'package:unifood/features/auth/views/login.dart';
import 'package:unifood/features/auth/views/signup.dart';
import 'package:unifood/features/profile/views/profile.dart';
import 'package:unifood/features/restaurant_detail/views/restaurant_detail.dart';
import 'package:unifood/features/restaurants_filtered/views/search_view.dart';
import 'package:unifood/features/preferences/views/preferences.dart';
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
      case '/restaurant_detail': // Define la ruta para el detalle de un restaurante
        return MaterialPageRoute(builder: (_) => const RestaurantDetail());
      case '/restaurant_search': // Define la ruta para el detalle de un restaurante
        return MaterialPageRoute(builder: (_) =>  const SearchView());
      case '/preferences': // Define la ruta para las preferencias del usuario
        return MaterialPageRoute(builder: (_) =>  const Preferences());
      default:
        return MaterialPageRoute(builder: (_) => const Landing());
    }
  }
}
