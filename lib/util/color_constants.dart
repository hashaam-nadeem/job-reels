import 'package:flutter/material.dart';

class AppColor{
  static Color primaryGradiantStart = const Color(0xFFFFCF32);
  static Color primaryGradiantEnd = const Color(0xFFFFBD3C);
  static Color primaryGradiantNightStart = const Color(0xFF242D6A);
  static Color primaryGradiantNightEnd = const Color(0xFF8B5D9E);
  static Color whiteColor = Colors.white;
  static Color blackColor = Colors.black;
  static Color greyColor = const Color(0x50F3F3F3);
  static Color textGreyColor = const Color(0x30000000);
  static Color primaryColorShade = const Color(0x11FFC700);
  static Color labelColor = Colors.red.withOpacity(0.8);
  static Color weatherWidgetColor = const Color(0xff4BBEED);
  static Color borderColor = const Color(0xffE4AA38);
  static List<Color> weatherWidgetGradient = [
    const Color(0xFF19C2FD),
    const Color(0xFF4AA2D3),
    const Color(0xFF137AF4),
  ];
  static List<Color> weatherNightGradient = [
    const Color(0xFF242D6A),
    const Color(0xFF8B5D9E),
  ];
}
