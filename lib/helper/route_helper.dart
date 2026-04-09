import 'dart:convert';
import 'package:glow_solar/data/model/response/car_model.dart';
import 'package:glow_solar/data/model/response/solar_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glow_solar/view/base/CustomImagePicker/camera.dart';
import 'package:glow_solar/view/screens/about%20us/about_us_screen.dart';
import 'package:glow_solar/view/screens/auth/sign_in_screen.dart';
import 'package:glow_solar/view/screens/auth/sign_up_screen.dart';
import 'package:glow_solar/view/screens/car%20controller/car_controller_screen.dart';
import 'package:glow_solar/view/screens/car%20controller/widgets/add_and_update_car_screen.dart';
import 'package:glow_solar/view/screens/car%20controller/widgets/car_detail_screen.dart';
import 'package:glow_solar/view/screens/car%20controller/widgets/smartCars_screen.dart';
import 'package:glow_solar/view/screens/car%20controller/widgets/webView_screen.dart';
import 'package:glow_solar/view/screens/charger%20controller/widgets/add_and_updatecharger_screen.dart';
import 'package:glow_solar/view/screens/charger%20controller/widgets/charger_detail_screen.dart';
import 'package:glow_solar/view/screens/find%20charger/widgets/charger_request.dart';
import 'package:glow_solar/view/screens/find%20charger/widgets/payment_screen.dart';
import 'package:glow_solar/view/screens/forget/create_or_change_pass_screen.dart';
import 'package:glow_solar/view/screens/forget/forget_pass_screen.dart';
import 'package:glow_solar/view/screens/forget/verification_screen.dart';
import 'package:glow_solar/view/screens/home/main_screen.dart';
import 'package:glow_solar/view/screens/invoice/invoice_screen.dart';
import 'package:glow_solar/view/screens/notification/notification_screen.dart';
import 'package:glow_solar/view/screens/privacy%20policy/privacy_policy_screen.dart';
import 'package:glow_solar/view/screens/solar/add_or_update_solar_screen.dart';
import 'package:glow_solar/view/screens/solar/solar_controller_screen.dart';
import 'package:glow_solar/view/screens/splash/splash_screen.dart';
import '../data/model/response/charger_model.dart';
import '../data/model/response/request_model.dart';
import '../enums/otp_verify_type.dart';
import '../view/screens/charger controller/charger_controller_screen.dart';
import '../view/screens/charger controller/widgets/request_charger.dart';
import '../view/screens/find charger/widgets/charger_detail.dart';
import '../view/screens/find charger/find_charger.dart';
import '../view/screens/solar/solar_details_screen.dart';
import '../view/screens/update/update_and_maintainence_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String findCharger = '/find-charger';
  static const String otpVerification = '/verification';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String changePassword = '/reset-password';
  static const String privacyPolicy = '/privacyPolicy';
  static const String solarController = '/solarController';
  static const String chargerController = '/chargerController';
  static const String solarDetails = '/solarDetails';
  static const String chargerDetails = '/chargerDetails';
  static const String addSolar = '/addSolar';
  static const String chargerControllerDetail = '/chargerControllerDetail';
  static const String search = '/search';
  static const String addCharger = '/addCharger';
  static const String requestCharger = '/requestCharger';
  static const String store = '/store';
  static const String notification = '/notification';
  static const String support = '/help-and-support';
  static const String rateReview = '/rate-and-review';
  static const String chargerRequest = '/chargerRequest';
  static const String carController = '/carController';
  static const String update = '/update';
  static const String payment = '/payment';
  static const String carDetail = '/carDetail';
  static const String addVehicle = '/addVehicle';
  // static const String itemImages = '/item-images';
  static const String customImagePicker = '/pickImage';
  static const String invoice = '/invoice';
  static const String updateAndMaintenance = '/updateAndMaintenance';
  static const String webViewScreen = '/webViewScreen';
  static const String smartCarScreen = '/smartCarScreen';
  static const String aboutUs = '/aboutUs';

  static String getInitialRoute() => initial;
  static String getSplashRoute({int? orderID}) => '$splash${orderID != null ? "?id=$orderID" : ""}';
  static String getSignInRoute() => signIn;
  static String getChangePasswordRoute({required bool isChangePassword}) => "$changePassword?isChangePassword=${isChangePassword ? 1 : 0}";
  static String getSolarDetailsRoute({required Solar solar}) => "$solarDetails?solar=${json.encode(solar.toJson())}";
  static String getChargerDetailsRoute({required Charger charger}) => "$chargerDetails?charger=${json.encode(charger.toJson())}";
  static String getSignUpRoute() => signUp;
  static String getFindCharger() => findCharger;
  static String getPrivacyPolicyRoute() => privacyPolicy;
  static String getRequestChargerRoute({required int id}) => "$requestCharger?id=$id";
  static String getWebViewScreen() => webViewScreen;
  static String getSolarControllerRoute() => solarController;
  static String getChargerControllerRoute() => chargerController;
  static String getInvoiceRoute() => invoice;
  static String getCarDetailRoute({required int id}) => "$carDetail?id=$id";
  static String getCarControllerRoute() => carController;
  static String getPaymentRoute({required int notificationId}) => "$payment?notificationId=$notificationId";
  static String getNotificationRoute({bool isFromNotificationClick=false, int ?notificationClickId}) => "$notification?isFromNotificationClick=${isFromNotificationClick?1:0}${notificationClickId!=null?'&notificationClickId=$notificationClickId':''}";
  static String getChargerControllerDetailRoute({required int id}) => "$chargerControllerDetail?id=$id";
  static String getChargerRequestRoute({required Charger charger}) => "$chargerRequest?charger=${json.encode(charger.toJson())}";
  static String getAddOrUpdateVehicleRoute({Car? car, String? code}) => "$addVehicle${car!=null?'?car=${json.encode(car.toJson())}':'?code=$code'}";
  static String getSmartCarScreen({required String code, String? make}) => "$smartCarScreen?code=$code&make=$make";
  static String getAddOrUpdateChargerRoute({Charger ?charger}) => "$addCharger${charger!=null?'?charger=${json.encode(charger.toJson())}':''}";
  static String getAddOrUpdateSolarRoute({Solar ?solar}) => "$addSolar${solar!=null?'?solar=${json.encode(solar.toJson())}':''}";
  static String getMainScreenRoute() => main;
  static String getForgetPasswordRoute() => forgotPassword;
  static String getCustomImagePickerRoute() => customImagePicker;
  static String getAboutUsScreen() => aboutUs;
  static String getUpdateAndMaintenance({required bool isUpdate}) =>  "$updateAndMaintenance?isUpdate=${isUpdate ? 1 : 0}";
  static String getOtpVerificationRoute({required OtpVerifyType verificationType}) => "$otpVerification?verificationType=${verificationType.name}";

  static List<GetPage> routes = [
    GetPage(name: splash, page: () => SplashScreen(orderID: Get.parameters['id'])),
    GetPage(name: signIn, page: () => const SignInScreen()),
    GetPage(name: signUp, page: () => const SignUpScreen()),
    GetPage(name: customImagePicker, page: () => const CustomImagePickerScreen()),
    GetPage(name: notification, page: () => NotificationScreen(isFromNotificationClick: int.tryParse(Get.parameters['isFromNotificationClick']!)??0, notificationClickId: Get.parameters['notificationClickId']!=null? int.tryParse(Get.parameters['notificationClickId']!):null,)),
    GetPage(name: privacyPolicy, page: () => const PrivacyPolicyScreen()),
    GetPage(name: solarController, page: () => const SolarControllerScreen()),
    GetPage(name: chargerController, page: () => const ChargerControllerScreen()),
    GetPage(name: invoice, page: () => const InvoiceScreen()),
    GetPage(name: updateAndMaintenance, page: () { return UpdateAndMaintenanceScreen(isUpdate: Get.parameters['isUpdate'] == '1',);}),
    GetPage(name: addCharger, page: () {return AddAndUpdateChargerScreen(charger: Get.parameters['charger']!=null? Charger.fromLocalJson(json.decode(Get.parameters['charger']!)):null,);}),
    GetPage(name: chargerRequest, page: () {return ChargerRequestScreen(charger: Charger.fromLocalJson(json.decode(Get.parameters['charger'] ?? '',)));}),
    GetPage(name: carDetail,  page: (){ return CarDetailScreen(carId: int.parse(Get.parameters['id']!),);}),
    GetPage(name: addVehicle, page: () {return AddNewVehicle(car: Get.parameters['car']!=null? Car.fromLocalJson(json.decode(Get.parameters['car']!)):null, code:Get.parameters['code']!=null? Get.parameters['code']!:null);}),
    GetPage(name: smartCarScreen, page: () {return SmartCarListsScreen(code:Get.parameters['code']!,make:Get.parameters['make'] != null?Get.parameters['make']!:"" ,);}),
    GetPage(name: payment, page: () { return PaymentScreen( notificationsId: int.parse(Get.parameters['notificationId']!),);}),
    GetPage(name: carController, page: () => const CarControllerScreen()),
    GetPage(name: requestCharger, page: () {return  RequestsChargerScreen(chargerId: int.parse(Get.parameters['id']!),);}),
    GetPage(name: webViewScreen, page: () {return  const WebViewContainer();}),
    GetPage(name: aboutUs, page: () {return  const AboutUsScreen();}),
    GetPage(name: chargerControllerDetail, page: (){ return ChargerControllerDetailScreen(chargerId: int.parse(Get.parameters['id']!),);}),
    GetPage(name: solarController, page: () => const SolarControllerScreen()),
    GetPage(name: chargerDetails, page: () { return ChargerDetailScreen(charger: Charger.fromLocalJson(json.decode(Get.parameters['charger'] ?? '')),);}),
    GetPage(name: solarDetails, page: () {return SolarDetailsScreenScreen(solar: Solar.fromLocalJson(json.decode(Get.parameters['solar'] ?? '')),);}),
    GetPage(name: addSolar, page: () {return AddOrUpdateSolarScreen(solar: Get.parameters['solar']!=null? Solar.fromLocalJson(json.decode(Get.parameters['solar']!)):null,);}),
    GetPage(name: changePassword, page: () => CreateOrChangePasswordScreen(isChangePassword: Get.parameters['isChangePassword'] == '1',)),
    GetPage(name: main, page: () => const MainScreen()),
    GetPage(name: findCharger, page: () => const FindChargerScreen()),
    GetPage(name: forgotPassword, page: () => const ForgetPassScreen()),
    GetPage(
        name: otpVerification,
        page: ()
        {
          OtpVerifyType verifyType = OtpVerifyType.RegisterVerify;
          if(Get.parameters['verificationType']==OtpVerifyType.ForgetPassword.name){
            verifyType = OtpVerifyType.ForgetPassword;
          }else if(Get.parameters['verificationType']==OtpVerifyType.ChangePassword.name){
            verifyType = OtpVerifyType.ChangePassword;
          }else{
            verifyType = OtpVerifyType.RegisterVerify;
          }
              return OtpVerificationScreen(
                verifyType: verifyType,
              );
            }),

    // GetPage(name: verification, page: () {
    //   List<int> _decode = base64Decode(Get.parameters['pass'].replaceAll(' ', '+'));
    //   String _data = utf8.decode(_decode);
    //   return VerificationScreen(
    //     number: Get.parameters['number'], fromSignUp: Get.parameters['page'] == signUp, token: Get.parameters['token'],
    //     password: _data,
    //   );
    // }),

    // GetPage(name: orderSuccess, page: () => getRoute(OrderSuccessfulScreen(
    //   orderID: Get.parameters['id'], success: Get.parameters['status'].contains('success'),
    //   parcel: Get.parameters['type'] == 'parcel',
    // ))),
  ];

  static getRoute(Widget navigateTo) {
    int _minimumVersion = 0;
    if (GetPlatform.isAndroid) {
      _minimumVersion = 1;
      //Get.find<SplashController>().configModel.appMinimumVersionAndroid;
    } else if (GetPlatform.isIOS) {
      _minimumVersion = 1;
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
