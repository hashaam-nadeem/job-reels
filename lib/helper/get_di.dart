import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/auth_controller.dart';
import '../controller/splash_controller.dart';
import '../controller/theme_controller.dart';

Future init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  // Get.lazyPut(() => AuthRepo(sharedPreferences: Get.find()));
  // Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  // Controller
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  // Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => SplashController());
  Get.lazyPut(() => AuthController());
}
