import 'package:flutter/material.dart';


ThemeData light({Color color = const Color(0xFFFFCF32)}) => ThemeData(
      fontFamily: 'Montserrat',
      primaryColor: color,
      primaryColorLight: Colors.white,
      primaryColorDark: Colors.black,
      secondaryHeaderColor: const Color(0xFFFFBD3A),
      disabledColor: const Color(0x20000000),
      backgroundColor: const Color(0x09000000),
      errorColor: const Color(0xFFE84D4F),
      brightness: Brightness.light,
      hintColor:  Colors.black26,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      cardColor: Colors.white,
      colorScheme: ColorScheme.light(primary: color, secondary: const Color(0xFFFFBD3A)),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: color)),
      textSelectionTheme: TextSelectionThemeData(selectionColor: color),
    );
