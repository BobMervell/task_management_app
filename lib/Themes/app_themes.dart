import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: const Color(0xFFF1EBE4),
  canvasColor: const Color(0xFFF1EBE4),
  cardColor: const Color(0xFFF1EBE4),
  dividerColor: const Color(0xFF4F4739),

  textTheme: TextTheme(
    displayLarge: TextStyle(color: const Color(0xFF4F4739), fontFamily: 'Monospace'),
    displayMedium: TextStyle(color: const Color(0xFF4F4739), fontFamily: 'Monospace'),
    displaySmall: TextStyle(color: const Color(0xFF4F4739), fontFamily: 'Monospace'),
    headlineLarge: TextStyle(color: const Color(0xFF4F4739), fontFamily: 'Monospace'),
    headlineMedium: TextStyle(color: const Color(0xFF4F4739), fontFamily: 'Monospace'),
    headlineSmall: TextStyle(color: const Color(0xFF4F4739), fontFamily: 'Monospace'),
    titleLarge: TextStyle(color: const Color(0xFF4F4739), fontFamily: 'Monospace'),
    titleMedium: TextStyle(color: const Color(0xFF4F4739), fontFamily: 'Monospace'),
    titleSmall: TextStyle(color: const Color(0xFF4F4739), fontFamily: 'Monospace'),
    bodyLarge: TextStyle(color: const Color(0xFF4F4739), fontFamily: 'Monospace'),
    bodyMedium: TextStyle(color: const Color(0xFF4F4739), fontFamily: 'Monospace'),
    bodySmall: TextStyle(color: const Color(0xFF4F4739), fontFamily: 'Monospace'),
  ),

  iconTheme: IconThemeData(color: Colors.black),
  primaryIconTheme: IconThemeData(color: Colors.black),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontFamily: 'Monospace'),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.grey,
  ),
);


// Thème sombre avec effet encre numérique
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.grey,
  primaryColor: Colors.white,
  scaffoldBackgroundColor: Colors.black,
  canvasColor: Colors.black,
  cardColor: Colors.grey[800],
  dividerColor: Colors.white,
  textTheme: TextTheme(
    displayLarge: TextStyle(color: Colors.white, fontFamily: 'Monospace'),
    displayMedium: TextStyle(color: Colors.white, fontFamily: 'Monospace'),
    displaySmall: TextStyle(color: Colors.white, fontFamily: 'Monospace'),
    headlineLarge: TextStyle(color: Colors.white, fontFamily: 'Monospace'),
    headlineMedium: TextStyle(color: Colors.white, fontFamily: 'Monospace'),
    headlineSmall: TextStyle(color: Colors.white, fontFamily: 'Monospace'),
    titleLarge: TextStyle(color: Colors.white, fontFamily: 'Monospace'),
    titleMedium: TextStyle(color: Colors.white, fontFamily: 'Monospace'),
    titleSmall: TextStyle(color: Colors.white, fontFamily: 'Monospace'),
    bodyLarge: TextStyle(color: Colors.white, fontFamily: 'Monospace'),
    bodyMedium: TextStyle(color: Colors.white, fontFamily: 'Monospace'),
    bodySmall: TextStyle(color: Colors.white, fontFamily: 'Monospace'),
  ),
  iconTheme: IconThemeData(color: Colors.white),
  primaryIconTheme: IconThemeData(color: Colors.white),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontFamily: 'Monospace'),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
  ),
);