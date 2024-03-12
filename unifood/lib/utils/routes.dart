import 'package:flutter/material.dart';
import 'package:unifood/view/auth/views/landing.dart';
import 'package:unifood/view/auth/views/login.dart';
import 'package:unifood/view/auth/views/signup.dart';
import 'package:unifood/view/profile/dashboard/views/profile.dart';
import 'package:unifood/view/restaurant/detail/views/restaurant_detail.dart';
import 'package:unifood/view/restaurant/dashboard/views/restaurants.dart';
import 'package:unifood/view/restaurant/search/views/search_view.dart';
import 'package:unifood/view/profile/preferences/views/preferences.dart';
import 'package:unifood/view/profile/points/views/points.dart';
import 'package:unifood/view/restaurant/offers/views/offers.dart';


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
        return MaterialPageRoute(builder: (_) => const SearchView());
      case '/preferences': // Define la ruta para las preferencias del usuario
        return MaterialPageRoute(builder: (_) => const Preferences());
      case '/restaurants': // Define la ruta para los restaurantes
        return MaterialPageRoute(builder: (_) => const Restaurants());
      case '/points': // Define la ruta para los puntos
        return MaterialPageRoute(builder: (_) => const Points());
      case '/offers': // Define la ruta para las ofertas
        return MaterialPageRoute(builder: (_) => const OffersPage());

      default:
        return MaterialPageRoute(builder: (_) => const Landing());
    }
  }
}
