import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/pages/HomePage.dart';
import 'package:weather_app/pages/WeatherPage.dart';

class RouteGenerator {
  static Route<dynamic>? _gidilecekrota(Widget gidilecekWidget) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageRoute(builder: (context) => gidilecekWidget);
    } else {
      return MaterialPageRoute(builder: (context) => gidilecekWidget);
    }
  }

  static Route<dynamic>? rotaOlustur(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _gidilecekrota(const HomePage());
      case '/weatherPage':
        return _gidilecekrota(const WeatherPage());
      default:
        return _gidilecekrota(const HomePage());
    }
  }
}
