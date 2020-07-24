import 'package:atasayaregitim/Screens/HomeScreen.dart';
import 'package:atasayaregitim/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => LoginScreen());
      default:
        return _errorRoute(settings.name);
    }
  }
  static Route<dynamic> _errorRoute(String r) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Bulunamayan :' + r),
        ),
      );
    });
  }
}
