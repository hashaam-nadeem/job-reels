import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/screens/auth/login_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String login = '/sign-in';
  static const String main = '/main';


  static String getInitialRoute() => initial;
  static String getLogInRoute() => login;
  static String getMainScreenRoute() => main;


  static List<GetPage> routes = [

    GetPage(name: login, page: () => const LoginScreen()),
    // GetPage(name: signIn, page: () => const SignInScreen()),
    // GetPage(name: main, page: () => const MainScreen()),
  ];

  static getRoute(Widget navigateTo) {
    return navigateTo;
  }
}