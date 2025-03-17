import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.white,
  canvasColor: Colors.white,
  cardColor: Colors.grey[50],
  dividerColor: Colors.black,

  textTheme: TextTheme(
    displayLarge: TextStyle(color: Colors.black, fontFamily: 'Monospace'),
    displayMedium: TextStyle(color: Colors.black, fontFamily: 'Monospace'),
    displaySmall: TextStyle(color: Colors.black, fontFamily: 'Monospace'),
    headlineLarge: TextStyle(color: Colors.black, fontFamily: 'Monospace'),
    headlineMedium: TextStyle(color: Colors.black, fontFamily: 'Monospace'),
    headlineSmall: TextStyle(color: Colors.black, fontFamily: 'Monospace'),
    titleLarge: TextStyle(color: Colors.black, fontFamily: 'Monospace'),
    titleMedium: TextStyle(color: Colors.black, fontFamily: 'Monospace'),
    titleSmall: TextStyle(color: Colors.black, fontFamily: 'Monospace'),
    bodyLarge: TextStyle(color: Colors.black, fontFamily: 'Monospace'),
    bodyMedium: TextStyle(color: Colors.black, fontFamily: 'Monospace'),
    bodySmall: TextStyle(color: Colors.black, fontFamily: 'Monospace'),
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