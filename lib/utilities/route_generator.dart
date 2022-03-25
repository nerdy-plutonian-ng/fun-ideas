import 'package:flutter/material.dart';

import '../routes/home_page.dart';
import '../routes/landing_page.dart';
import '../routes/setup_page.dart';

MaterialPageRoute generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const LandingPage());
    case '/setUpPage':
      return MaterialPageRoute(builder: (_) => const SetupPage());
    case '/homePage':
      return MaterialPageRoute(builder: (_) => const HomePage());
    default:
      return MaterialPageRoute(builder: (_) => const LandingPage());
  }
}