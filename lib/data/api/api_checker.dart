import 'package:dio/dio.dart' as ApiClient;
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../helper/route_helper.dart';
import '../../view/base/custom_snackbar.dart';

class ApiChecker {
  static void checkUnAuthorization(ApiClient.Response response) {
    if(response.statusCode == 401) {
      // Get.find<AuthController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getLogInRoute());
    }
  }
}
