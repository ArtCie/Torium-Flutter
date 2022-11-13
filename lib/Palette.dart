import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor kToDark = MaterialColor(
    0xFF1976D2, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Color(0xFFE3F2FD ),//10%
      100: Color(0xFFBBDEFB),//20%
      200: Color(0xFF90CAF9),//30%
      300: Color(0xFF64B5F5),//40%
      400: Color(0xFF42A5F5),//50%
      500: Color(0xFF2196F3),//60%
      600: Color(0xFF1E88E5),//70%
      700: Color(0xFF1976D2),//80%
      800: Color(0xFF1565C0),//90%
      900: Color(0xFF0D47A1),//100%
    },
  );
}