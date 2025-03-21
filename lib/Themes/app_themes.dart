import 'package:flutter/material.dart';

// Couleurs principales
const Color darkColor = Color(0xFF4F4739);
const Color lightColor = Color(0xFFF1EBE4);
const Color accentColor = Colors.blue; // Couleur d'accentuation

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: darkColor,
  colorScheme: ColorScheme.light(
    primary: darkColor,
    secondary: accentColor,
    surface: lightColor,
    onSurface: darkColor,
  ),



 textTheme: TextTheme(
    displayLarge: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, color: darkColor, fontFamily: 'Monospace'),
    displayMedium: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold,color: darkColor, fontFamily: 'Monospace'),
    displaySmall: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold,color: darkColor, fontFamily: 'Monospace'),
    headlineLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold,color: darkColor, fontFamily: 'Monospace'),
    headlineMedium: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold,color: darkColor, fontFamily: 'Monospace'),
    headlineSmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold,color: darkColor, fontFamily: 'Monospace'),
    titleLarge: TextStyle(fontSize: 28.0,color: darkColor, fontFamily: 'Monospace'),
    titleMedium: TextStyle(fontSize: 24.0,color: darkColor, fontFamily: 'Monospace'),
    titleSmall: TextStyle(fontSize: 20.0,color: darkColor, fontFamily: 'Monospace'),
    bodyLarge: TextStyle(fontSize: 18.0,color: darkColor, fontFamily: 'Monospace'),
    bodyMedium: TextStyle(fontSize: 16.0,color: darkColor, fontFamily: 'Monospace'),
    bodySmall: TextStyle(fontSize: 14.0,color: darkColor, fontFamily: 'Monospace'),
  ),

  // AppBar Theme
  appBarTheme: AppBarTheme(
    color: lightColor,
    iconTheme: IconThemeData(color: darkColor),
    titleTextStyle: TextStyle(color: darkColor, fontSize: 20.0, fontWeight: FontWeight.bold),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: darkColor, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide(color: accentColor, width: 2.0),
    ),
    hintStyle: TextStyle(color: darkColor.withAlpha(150)),
    labelStyle: TextStyle(color: darkColor),
  ),

  // Card Theme
  cardTheme: CardTheme(
    color: lightColor,
    shadowColor: darkColor.withAlpha(50),
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    margin: EdgeInsets.all(8.0),
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: darkColor,
    selectedItemColor: lightColor,
    unselectedItemColor: lightColor.withAlpha(150),
  ),

  // Dialog Theme
  dialogTheme: DialogTheme(
    backgroundColor: lightColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
  ),

  // Divider Theme
  dividerTheme: DividerThemeData(color: darkColor.withAlpha(75), thickness: 1.0),

  // Chip Theme
  chipTheme: ChipThemeData(
    backgroundColor: lightColor,
    selectedColor: darkColor,
    labelStyle: TextStyle(color: darkColor),
    secondaryLabelStyle: TextStyle(color: lightColor),
  ),

  /* // ElevatedButton Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: darkColor, // Couleur du texte
      foregroundColor: lightColor, // Couleur du texte sur surface
      iconColor: accentColor,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      elevation: 4.0, // Ombre portée
    ),
  ), */

/*   // TextButton Theme
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      backgroundColor: darkColor, // Couleur du texte
      foregroundColor: lightColor, // Couleur du texte sur surface
      iconColor: accentColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal,color: accentColor),
    ),
  ), */

/*   // OutlinedButton Theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      backgroundColor: darkColor, // Couleur du texte
      foregroundColor: lightColor, // Couleur du texte sur surface
      iconColor: accentColor,

      side: BorderSide(color: darkColor, width: 2.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      textStyle: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal, color: darkColor),
    ),
  ), */

/*   // IconButton Theme
  iconTheme: IconThemeData(
    color: accentColor, // Couleur des icônes
  ), */

/*     // Floating Action Button Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: darkColor,
    foregroundColor: lightColor,
  ), */

  /* // Slider Theme
  sliderTheme: SliderThemeData(
    activeTrackColor: darkColor,
    inactiveTrackColor: darkColor.withAlpha(75),
    thumbColor: accentColor,
    valueIndicatorColor: accentColor,
  ), */

/*   // Switch Theme
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return accentColor;
      }
      return darkColor.withAlpha(150);
    }),
    trackColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return accentColor.withAlpha(150);
      }
      return darkColor.withAlpha(75);
    }),
  ), */

/*   // Checkbox Theme
  checkboxTheme: CheckboxThemeData(
    checkColor: WidgetStateProperty.resolveWith<Color>((states) {
      return lightColor;
    }),
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return accentColor;
      }
      return darkColor.withAlpha(75);
    }),
  ), */

/*   // Radio Theme
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return accentColor;
      }
      return darkColor.withAlpha(75);
    }),
  ), */



);
