import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobreels/controller/auth_controller.dart';

import '../../util/app_constants.dart';
import '../api/Api_Handler/api_call_Structure.dart';
import '../api/Api_Handler/api_constants.dart';
import 'package:dio/dio.dart' as ApiClient;

class NotificationRepo{


  Future<Map<String, dynamic>> fetchNotification() async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.fetchNotificationList,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> fetchThreadList() async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.fetchThreadList,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> fetchThreadMessages(int threadId) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstants.fetchThreadMessages}$threadId",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> fetchNotificationCount() async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.FETCH_NOTIFICATION_COUNT,
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> fetchThreadId(int userId) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.fetchThreadId,
      body: ApiClient.FormData.fromMap({
        "from_user_id": Get.find<AuthController>().getLoginUserData()?.id,
        "to_user_id": userId
      }),
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: true, isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> deleteSolar({required int id}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstants.DELETE_NOTIFICATIONS}$id",
      apiRequestMethod: API_REQUEST_METHOD.DELETE,
      isWantSuccessMessage: true,
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: true);
  }

}