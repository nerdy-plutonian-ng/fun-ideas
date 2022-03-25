import 'package:flutter/material.dart';

///colors
const ghostWhite = Color(0xFFFAFAFF);
const lavenderBlue = Color(0xFFE4D9FF);
const spaceCadet = Color(0xFF273469);
const spaceCadetDark = Color(0xFF1E2749);
const gunMetal = Color(0xFF30343F);

ThemeData lightTheme() {
  return ThemeData(
    scaffoldBackgroundColor: ghostWhite,
      colorScheme: lightColorScheme,);
}

ThemeData darkTheme() {
  return ThemeData();
}

final lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: spaceCadet,
    onPrimary: Colors.white,
    secondary: spaceCadetDark,
    onSecondary: Colors.white,
    error: Colors.red[50]!,
    onError: Colors.red[900]!,
    background: ghostWhite,
    onBackground: gunMetal,
    surface: ghostWhite,
    onSurface: gunMetal);