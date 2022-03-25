import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:fun_ideas/utilities/app_themes.dart';

import 'utilities/constants.dart';
import 'utilities/route_generator.dart';
import 'models/app_state.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AppState(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: lightTheme(),
      onGenerateRoute: (routeSettings) => generateRoute(routeSettings),
    );
  }
}