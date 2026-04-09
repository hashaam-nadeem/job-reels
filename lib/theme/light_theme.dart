import 'package:flutter/material.dart';

// primary : "#7a0fc1" ,
// secondary : "#ffdd55"

ThemeData light({Color color = const Color(0xFF7a0fc1)}) => ThemeData(
      fontFamily: 'Montserrat',
      primaryColor: color,
      primaryColorLight: Colors.white,
      primaryColorDark: Colors.black,
      secondaryHeaderColor: const Color(0xFFFFdd55),
      disabledColor: const Color(0x20000000),
      backgroundColor: const Color(0x09000000),
      errorColor: const Color(0xFFe60909),
      brightness: Brightness.light,
      hintColor:  const Color(0xFF666666),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      cardColor: Colors.white,
      colorScheme: ColorScheme.light(primary: color, secondary: const Color(0xFFFFBD3A)),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(primary: color)),
      textSelectionTheme: TextSelectionThemeData(selectionColor: color),
    );
