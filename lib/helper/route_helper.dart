import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workerapp/view/screens/profile/update_profile.dart';
import 'package:workerapp/view/screens/profile/widgets/staff_availability.dart';
import 'package:workerapp/view/screens/shift/shift_notes_screen.dart';
import '../view/screens/auth/login_screen.dart';
import '../view/screens/clientDetail/client_detail.dart';
import '../view/screens/main/main_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String login = '/sign-in';
  static const String main = '/main';
  static const String clientDetail = '/clientDetail';
  // static const String shiftNotes = '/shiftNotes';
  static const String staffAvailability = '/staffAvailability';
  static const String updateProfile = '/updateProfile';


  static String getInitialRoute() => initial;
  static String getLogInRoute() => login;
  static String getMainScreenRoute() => main;
  static String getClientDetailRoute() => clientDetail;
  // static String getShiftNotes() => shiftNotes;
  static String getStaffAvailability() => staffAvailability;
  static String getUpdateProfile() => updateProfile;


  static List<GetPage> routes = [

    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: main, page: () => const MainScreen()),
    GetPage(name: clientDetail, page: () => const ClientDetails()),
    // GetPage(name: shiftNotes, page: () =>  ShiftNotesScreen()),
    GetPage(name: staffAvailability, page: () => const StaffAvailability()),
    GetPage(name: updateProfile, page: () => const UpdateProfile()),
  ];

  static getRoute(Widget navigateTo) {
    return navigateTo;
  }
}