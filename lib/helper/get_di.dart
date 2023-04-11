import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerapp/controller/bottom_bar_controller.dart';
import 'package:workerapp/controller/client_controller.dart';
import 'package:workerapp/controller/shift_controller.dart';
import 'package:workerapp/data/repositry/shift_repo.dart';
import '../controller/auth_controller.dart';
import '../controller/splash_controller.dart';
import '../controller/theme_controller.dart';
import '../data/repositry/auth_repo.dart';
import '../data/repositry/client_repo.dart';

Future init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => AuthRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => ShiftRepo());
  Get.lazyPut(() => ClientRepo());
  // Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  // Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => SplashController());
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => ShiftController(shiftRepo: Get.find()));
  Get.lazyPut(() => ClientController(clientRepo: Get.find()));
  Get.lazyPut(() => BottomBarController());
}
