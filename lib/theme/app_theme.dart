import 'package:flutter/material.dart';

class AppTheme {
  static bool isDarkMode = true;
  static final ValueNotifier<ThemeData> themeNotifier =
      ValueNotifier(_darkTheme);

  static void toggleTheme() {
    isDarkMode = !isDarkMode;
    themeNotifier.value = isDarkMode ? _darkTheme : _lightTheme;
    theme_icon = isDarkMode ? dark_icon : light_icon;
    img = isDarkMode ? img_light : img_dark;
  }

  static IconData theme_icon = dark_icon ;
  static String img = img_light;

  static IconData light_icon = Icons.wb_sunny ;

  static IconData dark_icon = Icons.nightlight_round ;

  static String img_light = 'images/zitounLogoPNG.png';
  static String img_dark = 'images/zitounLogoPNG_b.png';
  // ------------------ DARK THEME ------------------
  static final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      background: Color(0xFF1C1C1C),
      onBackground: Colors.white,
      surface: Color(0xFF2A2A2A),
      primary: Colors.white,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontSize: 25, fontWeight:FontWeight.w400),
      bodyLarge: TextStyle(fontSize: 18),
      bodyMedium: TextStyle(fontSize: 16),
    ),
  
  );

  // ------------------ LIGHT THEME ------------------
  static final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      background: Color(0xFFF2F2F2),
      onBackground: Color(0xFF000000),
      surface: Colors.white,
      primary: Colors.black,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontSize: 25, fontWeight:  FontWeight.w400),
      bodyLarge: TextStyle(fontSize: 18),
      bodyMedium: TextStyle(fontSize: 16),
      
    ),
  );
}