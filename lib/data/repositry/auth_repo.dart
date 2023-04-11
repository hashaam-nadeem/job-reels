import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workerapp/utils/app_constants.dart';
import 'package:dio/dio.dart' as ApiClient;
import '../../controller/auth_controller.dart';
import '../api/Api_Handler/api_call_Structure.dart';
import '../api/Api_Handler/api_constants.dart';
import '../model/response/userInfo_model.dart';

class AuthRepo{
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.sharedPreferences});

  String? getAuthToken() {
    UserInfoModel ?userInfo = getLoginUserData();
    //print("userInfo?.tokenType.......................${userInfo?.tokenType} ${userInfo?.accessToken}");
    return userInfo?.accessToken;
  }
  String? getAuthTokenType() {
    UserInfoModel ?userInfo = getLoginUserData();
    return userInfo?.tokenType;

  }

  void saveLoginUserData({required UserInfoModel user}){
    sharedPreferences.setString(AppConstant.LOGIN_USER, json.encode(user.toJson()));
  }

  void setSharedPreferenceFcmToken({required String fcmToken}){
    sharedPreferences.setString(AppConstant.FCM_TOKEN, fcmToken);
  }

  String? getFcmToken(){
    return sharedPreferences.getString(AppConstant.FCM_TOKEN);
  }

  UserInfoModel ?getLoginUserData(){
    String ?userData =  sharedPreferences.getString(AppConstant.LOGIN_USER,);
    return userData!=null? UserInfoModel.fromJson(json.decode(userData)): null;
  }

  bool isLoggedIn() {
    return getLoginUserData()!=null;
  }



  bool clearSharedData() {
    sharedPreferences.remove(AppConstant.LOGIN_USER);
    sharedPreferences.clear();
    return true;
  }

  Future<void> saveUserMailAndPassword(String email, String password,) async {
    try {
      await sharedPreferences.setString(AppConstant.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstant.USER_MAIL, email);
    } catch (e) {
      throw e;
    }
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstant.USER_PASSWORD) ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstant.USER_PASSWORD);
    return await sharedPreferences.remove(AppConstant.USER_MAIL);
  }

  Future<Map<String, dynamic>> fetchProfile() async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstant.FETCH_PROFILE,
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> login({required String email,required String password}) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstant.LOGIN,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
      body: ApiClient.FormData.fromMap({
        "email": email,
        "password": password,
      }),
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> updateProfile({required String name,required String phone, required String address,String? password}) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstant.UPDATE_PROFILE,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
      body: ApiClient.FormData.fromMap({
        "name": name,
        "phone": phone,
        "address": address,
        "password":password??getUserPassword(),
      }),
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> logout() async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstant.LOGOUT,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }
}