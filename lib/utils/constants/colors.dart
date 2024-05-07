import 'package:flutter/material.dart';

class PomodoroColors {
  PomodoroColors._();

  // App Basic Colors
  static const Color primary = Color(0XFF0a5364);
  static const Color secondary = Color(0XFF3a6961);
  static const Color accent = Color(0XFF071b24);


  static const List<Color> gradientColors1 = [
    Color(0xFF1A1A64),
    Color(0xFF3A1A61),
    Color(0xFF071B24),
  ];

  static const List<Color> gradientColors2 = [
    Color(0xFF1A4A64),
    Color(0xFF3A6961),
    Color(0xFF074B24),
  ];

  static const List<Color> gradientColors3 = [
    Color(0xFFE94E77),
    Color(0xFF5FA05A),
    Color(0xFF68E682),
  ];

  static const List<Color> gradientColors4 = [
    Color(0xFF330000),
    Color(0xFF003333),
    Color(0xFF003300),
  ];

  static const List<Color> gradientColors5 = [
    Color(0xFF330033),
    Color(0xFF003333),
    Color(0xFF333300),
  ];

  static const List<Color> gradientColors6 = [
    Color(0xFF3C4F6C),
    Color(0xFF6F86A6),
    Color(0xFFB8C7D4),
  ];

  static const List<Color> gradientColors7 = [
    Color(0xFF6C3C4F),
    Color(0xFFA66F86),
    Color(0xFFD4B8C7),
  ];

  static const List<Color> gradientColors8 = [
    Color(0xFF4F6C3C),
    Color(0xFF86A66F),
    Color(0xFFC7D4B8),
  ];

  static const List<Color> gradientColors9 = [
    Color(0xFF3C6C4F),
    Color(0xFF6FA686),
    Color(0xFFB8D4C7),
  ];

  static const List<Color> gradientColors10 = [
    Color(0xFF6C3C6C),
    Color(0xFFA66FA6),
    Color(0xFFD4B8D4),
  ];




  static const Gradient linearGradient1 = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [
      Color(0XFF0a5364),
      Color(0XFF3a6961),
      Color(0XFF071b24),
    ],
  );


  // Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;

  // Background Colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);
  static const Color blackBackground = Color(0xFF000000);

  // Background Container colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = Colors.white.withOpacity(0.1);

  // Borders Colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Error and Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}
