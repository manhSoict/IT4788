import 'package:flutter/material.dart';
import '../views/login_view.dart';
import '../views/home_view.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const LoginView(),
      '/home': (context) => const HomeView(),
    };
  }
}
