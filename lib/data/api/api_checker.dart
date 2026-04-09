import 'package:glow_solar/controller/auth_controller.dart';
import 'package:glow_solar/helper/route_helper.dart';
import 'package:glow_solar/view/base/custom_snackbar.dart';
import 'package:dio/dio.dart' as ApiClient;
import 'package:get/get.dart';

class ApiChecker {
  static void checkUnAuthorization(ApiClient.Response response) {
    if(response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getSplashRoute());
    }
  }
}
