import 'package:flutter/material.dart';

ThemeData dark({Color color = const Color(0xFFFFCF32)}) => ThemeData(
      fontFamily: 'Montserrat',
      primaryColor: color,
      primaryColorLight: Colors.black,
      primaryColorDark: Colors.white,
      secondaryHeaderColor: const Color(0xFFFFBD3A),
      disabledColor: const Color(0xffa2a7ad),
      backgroundColor: const Color(0xFF343636),
      errorColor: const Color(0xFFdd3135),
      brightness: Brightness.dark,
      hintColor: const Color(0xFFbebebe),
      scaffoldBackgroundColor: const Color(0xFF3C3F41),
      cardColor: color,//Colors.black,
      colorScheme: ColorScheme.dark(primary: color, secondary: color),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: color)),
      dialogBackgroundColor:Colors.transparent,
      textSelectionTheme: const TextSelectionThemeData(selectionColor: Color(0xFFFFBD3A)),

    );
