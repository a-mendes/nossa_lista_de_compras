import 'package:flutter/material.dart';

enum CustomColor {
  pastelBlue,
  pastelGreen,
  pastelPink,
  pastelPurple,
  pastelYellow,
  white,
}

class CustomColorUtils {
  static const Color pastelBlue = Color(0xFFB5EAEA);
  static const Color pastelGreen = Color(0xFFC8F8C8);
  static const Color pastelPink = Color(0xFFF7C5F0);
  static const Color pastelPurple = Color(0xFFD7B0FF);
  static const Color pastelYellow = Color(0xFFFFF5C3);
  static const Color white = Colors.white70;

  static CustomColor getCustomColor(dynamic color) {
    switch (color) {
      case 'CustomColor.pastelBlue':
        return CustomColor.pastelBlue;
      case 'CustomColor.pastelGreen':
        return CustomColor.pastelGreen;
      case 'CustomColor.pastelPink':
        return CustomColor.pastelPink;
      case 'CustomColor.pastelPurple':
        return CustomColor.pastelPurple;
      case 'CustomColor.pastelYellow':
        return CustomColor.pastelYellow;
      case 'CustomColor.white':
        return CustomColor.white;
      default:
        throw ArgumentError("Unknown CustomColor value: $color");
    }
  }
  static Color getColor(dynamic color) {
    String strColor = (color is String) ? color : (color is CustomColor) ? color.toString() : '';

    switch (strColor) {
      case 'CustomColor.pastelBlue':
        return pastelBlue;
      case 'CustomColor.pastelGreen':
        return pastelGreen;
      case 'CustomColor.pastelPink':
        return pastelPink;
      case 'CustomColor.pastelPurple':
        return pastelPurple;
      case 'CustomColor.pastelYellow':
        return pastelYellow;
      case 'CustomColor.white':
        return white;
      default:
        throw ArgumentError("Unknown CustomColor value: $color");
    }
  }
}

