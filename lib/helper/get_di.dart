import 'dart:convert';
import 'package:glow_solar/controller/invoice_controller.dart';
import 'package:glow_solar/controller/stripe_controller.dart';
import 'package:glow_solar/controller/weather_controller.dart';
import 'package:glow_solar/controller/solar_controller.dart';
import 'package:glow_solar/data/repository/auth_repo.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:glow_solar/data/repository/invoice_repo.dart';
import 'package:glow_solar/data/repository/notification_repo.dart';
import 'package:glow_solar/data/repository/stripe_repo.dart';
import 'package:glow_solar/data/repository/weather_repo.dart';
import 'package:glow_solar/data/repository/solar_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/auth_controller.dart';
import '../controller/car_controller.dart';
import '../controller/charger_controller.dart';
import '../controller/notification_controller.dart';
import '../controller/request_controller.dart';
import '../controller/splash_controller.dart';
import '../controller/theme_controller.dart';
import '../data/model/response/language_model.dart';
import '../data/repository/car_repo.dart';
import '../data/repository/charger_repo.dart';
import '../data/repository/request_repo.dart';
import '../util/app_constants.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => AuthRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => WeatherRepo());
  Get.lazyPut(() => SolarRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => ChargerRepo());
  Get.lazyPut(() => CarRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => RequestRepo());
  Get.lazyPut(() => NotificationRepo());
  Get.lazyPut(() => StripeRepo());
  Get.lazyPut(() => InvoiceRepo());

  // Repository
  // Get.lazyPut(() => SplashRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  // Get.lazyPut(() => LanguageRepo());


  // Controller

  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  // Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => SplashController());
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => WeatherController(weatherRepo: Get.find()));
  Get.lazyPut(() => SolarController(solarRepo: Get.find()));
  Get.lazyPut(() => ChargerController(chargerRepo: Get.find()));
  Get.lazyPut(() => CarController(carRepo: Get.find()));
  Get.lazyPut(() => RequestController(requestRepo: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepo: Get.find()));
  Get.lazyPut(() => StripeController(stripeRepo: Get.find()));
  Get.lazyPut(() => InvoiceController(invoiceRepo: Get.find()));

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> jsonMap = {};
    mappedJson.forEach((key, value) {
      jsonMap[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = jsonMap;
  }
  return languages;
}
