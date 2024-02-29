import 'package:flutter/material.dart';
import 'package:unifood/features/auth/views/landing.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => Landing());

      default:
        return MaterialPageRoute(builder: (_) => Landing());
    }
  }
}
