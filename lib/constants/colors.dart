import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Colors.white;
  // static const Color primaryColor = Color(0xFF000000);
  static const Color primaryColor = Color.fromARGB(255, 159, 24, 0);
  static const Color primaryColorText = Color(0xFF0F1020);
  static const Color secondaryColor = Color(0xFF1D263B);
  static const Color error = Color(0xFFCC2936);
  static const Color success = Color(0xFF8FF7A7);
  static const Color green = Color(0xFF009900);
  static const Color warning = Color(0xFFF44708);
  static const Color gray = Color(0xFFA0AAB2);
  static const Color deliveryBlue = Color.fromARGB(100, 255, 213, 171);
  final Gradient circularGradient = RadialGradient(
    center: Alignment.center,
    radius: 0.8,
    colors: [Colors.pink, Colors.lightBlue, Colors.green],
  );
}
