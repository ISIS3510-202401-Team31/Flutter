import 'package:flutter/material.dart';
import 'package:unifood/view/auth/views/landing.dart';
import 'package:unifood/view/auth/views/login.dart';
import 'package:unifood/view/auth/views/signup.dart';
import 'package:unifood/view/profile/dashboard/views/profile.dart';
import 'package:unifood/view/restaurant/detail/views/restaurant_detail.dart';
import 'package:unifood/view/restaurant/dashboard/views/restaurants.dart';
import 'package:unifood/view/restaurant/favorites/views/favorites.dart';
import 'package:unifood/view/restaurant/liked/views/likedRestaurants.dart';
import 'package:unifood/view/restaurant/plateDetail/view/plate_detail.dart';
import 'package:unifood/view/restaurant/search/views/search_view.dart';
import 'package:unifood/view/profile/preferences/views/preferences.dart';
import 'package:unifood/view/profile/points/views/points.dart';
import 'package:unifood/view/restaurant/offers/views/offers.dart';
import 'package:unifood/view/restaurant/filtermenu/views/filter_menu.dart';
import 'package:unifood/view/reviews/create/view/create_review.dart';
import 'package:unifood/view/reviews/dashboard/view/myreviews.dart';
import 'package:unifood/repository/reservation_repository.dart';
import 'package:unifood/view/restaurant/reservation/views/restaurant_reservation.dart'; // Import the new view
import 'package:unifood/controller/reservation_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
        return MaterialPageRoute(
            builder: (_) => const RestaurantDetail(
                  restaurantId: "",
                ));
      case '/plate_detail':
        return MaterialPageRoute(
            builder: (_) => const PlateDetail(
                  restaurantId: "",
                  plateId: "",
                ));
      case '/restaurant_search': // Define la ruta para el detalle de un restaurante
        return MaterialPageRoute(builder: (_) => const SearchView());
      case '/preferences': // Define la ruta para las preferencias del usuario
        return MaterialPageRoute(builder: (_) => const Preferences());
      case '/restaurants': // Define la ruta para los restaurantes
        return MaterialPageRoute(builder: (_) => const Restaurants());
      case '/points': // Define la ruta para los puntos
        return MaterialPageRoute(builder: (_) => const PointsView());
      case '/offers': // Define la ruta para las ofertas
        return MaterialPageRoute(
            builder: (_) => const Offers(
                  restaurantId: "",
                ));
      case '/filtermenu': // Define la ruta para filtrar el menu
        return MaterialPageRoute(builder: (_) => const FilterMenu());
      case '/favorites': // Define la ruta dirijirse a favoritos
        return MaterialPageRoute(builder: (_) => const Favorites());
      case '/liked': // Define la ruta dirijirse a favoritos
        return MaterialPageRoute(builder: (_) => const LikedRestaurants());
      case "/create_review":
        return MaterialPageRoute(builder: (_) => const RestaurantReviewPage());
      case "/my_reviews":
        return MaterialPageRoute(builder: (_) => MyReviews());
      case '/restaurant_reservation': // Add the route for the new reservation view
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (_) => RestaurantReservation(
                  reservationController: ReservationController(
                      ReservationRepository(FirebaseFirestore.instance)),
                  restaurantsFuture: args['restaurantsFuture'],
                  userId: args['userId'],
                ));
      default:
        return MaterialPageRoute(builder: (_) => const Landing());
    }
  }
}
