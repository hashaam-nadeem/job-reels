import 'dart:convert';
import 'package:jobreels/controller/post_controller.dart';
import 'package:jobreels/controller/state_controller.dart';
import 'package:jobreels/controller/stripe_controller.dart';
import 'package:jobreels/data/repository/auth_repo.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobreels/data/repository/notification_repo.dart';
import 'package:jobreels/data/repository/post_repo.dart';
import 'package:jobreels/data/repository/state_repo.dart';
import 'package:jobreels/data/repository/stripe_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/auth_controller.dart';
import '../controller/notification_chat_controller.dart';
import '../controller/splash_controller.dart';
import '../controller/theme_controller.dart';
import '../data/model/response/language_model.dart';
import '../util/app_constants.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => AuthRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => PostRepo());
  Get.lazyPut(() => StateRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => PostRepo());
  Get.lazyPut(() => NotificationRepo());
  Get.lazyPut(() => StripeRepo());

  // Controller

  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  // Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => SplashController());
  Get.lazyPut(() => StateController(stateRepo: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => PostsController(postRepo: Get.find()));
  Get.lazyPut(() => ChatNotificationController(notificationRepo: Get.find()));

  Get.lazyPut(() => StripeController(stripeRepo: Get.find()));


  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  // for(LanguageModel languageModel in AppConstants.languages) {
  //   String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
  //   Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
  //   Map<String, String> jsonMap = {};
  //   mappedJson.forEach((key, value) {
  //     jsonMap[key] = value.toString();
  //   });
  //   languages['${languageModel.languageCode}_${languageModel.countryCode}'] = jsonMap;
  // }
  return languages;
}
