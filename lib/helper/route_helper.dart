import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/view/base/CustomImagePicker/camera.dart';
import 'package:jobreels/view/screens/auth/sign_in_screen.dart';
import 'package:jobreels/view/screens/auth/sign_up_screen.dart';
import 'package:jobreels/view/screens/forget/create_or_change_pass_screen.dart';
import 'package:jobreels/view/screens/forget/forget_pass_screen.dart';
import 'package:jobreels/view/screens/main/main_screen.dart';
import 'package:jobreels/view/screens/splash/splash_screen.dart';
import '../view/screens/update/update_and_maintainence_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String otpVerification = '/verification';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/reset-password';
  static const String privacyPolicy = '/privacyPolicy';
  static const String search = '/search';
  static const String notification = '/notification';
  static const String support = '/help-and-support';
  static const String rateReview = '/rate-and-review';
  static const String update = '/update';
  static const String payment = '/payment';
  static const String updateAndMaintenance = '/updateAndMaintenance';
  static const String aboutUs = '/aboutUs';
  static const String customImagePicker = '/pickImage';

  static String getInitialRoute() => initial;
  static String getSplashRoute({int? orderID}) => '$splash${orderID != null ? "?id=$orderID" : ""}';
  static String getSignInRoute() => signIn;
  static String getChangePasswordRoute({required bool isChangePassword}) => "$changePassword?isChangePassword=${isChangePassword ? 1 : 0}";
  static String getSignUpRoute() => signUp;
  static String getPrivacyPolicyRoute() => privacyPolicy;
  static String getPaymentRoute({required int notificationId}) => "$payment?notificationId=$notificationId";
  static String getNotificationRoute({bool isFromNotificationClick=false, int ?notificationClickId}) => "$notification?isFromNotificationClick=${isFromNotificationClick?1:0}${notificationClickId!=null?'&notificationClickId=$notificationClickId':''}";
  static String getMainScreenRoute({int bottomNavBarIndex = 0, int homeInitialPage=0}){
    homePageCurrentIndex = homeInitialPage;
    return "$main?bottomNaveIndex=$bottomNavBarIndex";
  }
  static String getForgetPasswordRoute() => forgotPassword;
  static String getAboutUsScreen() => aboutUs;
  static String getCustomImagePickerRoute() => customImagePicker;
  static String getUpdateAndMaintenance({required bool isUpdate}) =>  "$updateAndMaintenance?isUpdate=${isUpdate ? 1 : 0}";

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen(orderID: Get.parameters['id'])),
    GetPage(name: signIn, page: () => const SignInScreen()),
    GetPage(name: signUp, page: () => const SignUpScreen()),
    GetPage(name: main, page: () => MainScreen(bottomNavBarIndex: int.parse(Get.parameters['bottomNaveIndex']??"0"),)),
    GetPage(name: customImagePicker, page: () => const CustomImagePickerScreen()),
    GetPage(name: updateAndMaintenance, page: () { return UpdateAndMaintenanceScreen(isUpdate: Get.parameters['isUpdate'] == '1',);}),
    GetPage(name: changePassword, page: () => CreateOrChangePasswordScreen(isChangePassword: Get.parameters['isChangePassword'] == '1',)),
    GetPage(name: forgotPassword, page: () => const ForgetPassScreen()),
  ];

  static getRoute(Widget navigateTo) {
    int minimumVersion = 0;
    if (GetPlatform.isAndroid) {
      minimumVersion = 1;
      //Get.find<SplashController>().configModel.appMinimumVersionAndroid;
    } else if (GetPlatform.isIOS) {
      minimumVersion = 1;
      //Get.find<SplashController>().configModel.appMinimumVersionIos;
    }
    return
        // AppConstants.APP_VERSION < _minimumVersion
        //   ? UpdateScreen(isUpdate: true)
        //   : Get.find<SplashController>().configModel.maintenanceMode ? UpdateScreen(isUpdate: false)
        //   : Get.find<LocationController>().getUserAddress() == null
        //   ? AccessLocationScreen(fromSignUp: false, fromHome: false, route: Get.currentRoute)
        //   :
        navigateTo;
  }
}
