import 'dart:convert';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/data/api/Api_Handler/api_call_Structure.dart';
import 'package:jobreels/data/api/Api_Handler/api_constants.dart';
import 'package:jobreels/data/model/response/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as ApiClient;
import '../../enums/report_type.dart';
import '../../enums/validation_type.dart';
import '../../util/app_constants.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.sharedPreferences});

  String? getAuthToken() {
    return sharedPreferences.getString(AppConstants.AUTH_TOKEN_USER,);
  }
  void saveAuthToken(String authToken) async{
    sharedPreferences.setString(AppConstants.AUTH_TOKEN_USER,authToken);
  }

  // Future<Response> registration(SignUpBody signUpBody) async {
  //   return await apiClient.postData(AppConstants.REGISTER_URI, signUpBody.toJson());
  // }
  //

  void saveLoginUserData({required User user}){
    sharedPreferences.setString(AppConstants.LOGIN_USER, json.encode(user.toJson()));
  }

  void setSharedPreferenceFcmToken({required String fcmToken}){
    sharedPreferences.setString(AppConstants.FCM_TOKEN, fcmToken);
  }
  String? getFcmToken(){
    return sharedPreferences.getString(AppConstants.FCM_TOKEN);
  }

  Future<Map<String,dynamic>> updateFcmToken({required String fcmToken})async{
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.UPDATE_FCM_TOKEN,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
      body: ApiClient.FormData.fromMap({
        "fcm_token": fcmToken,
      }),
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: true);
  }

  void subscribeUser(int userId){
    List<int>subscribedUsersList =  getSubscribedUsers;
    debugPrint("before subscribe subscribedUsersList:->> ${subscribedUsersList.length}");
    if(!subscribedUsersList.contains(userId)){
      subscribedUsersList.add(userId);
    }
    debugPrint("after subscribe subscribedUsersList:->> ${subscribedUsersList.length}");
    sharedPreferences.setStringList(AppConstants.SUBSCRIBED_USERS, subscribedUsersList.map((e) => e.toString()).toList());
  }

  void cancelUserSubscription(int userId){
    List<int>subscribedUsersList =  getSubscribedUsers;
    subscribedUsersList.remove(userId);
    User ?user = getLoginUserData();
    if(user!=null){
      user.isSubscribed = false;
      saveLoginUserData(user: user);
    }
    sharedPreferences.setStringList(AppConstants.SUBSCRIBED_USERS, subscribedUsersList.map((e) => e.toString()).toList());
  }

   List<int> get getSubscribedUsers => sharedPreferences.getStringList(AppConstants.SUBSCRIBED_USERS)?.map((e) => int.parse(e)).toList()??[];

  User ?getLoginUserData(){
    String ?userData =  sharedPreferences.getString(AppConstants.LOGIN_USER,);
    return userData!=null? User.fromJson(json.decode(userData)): null;
  }


  Future<Map<String, dynamic>> login({required String email,required String password,}) async {
    String ?fcmToken;
    if(Platform.isAndroid){
      fcmToken = await FirebaseMessaging.instance.getToken();
    }else if(Platform.isIOS){
      await FirebaseMessaging.instance.getAPNSToken();
      fcmToken =  await FirebaseMessaging.instance.getToken();
    }
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.login,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
      body: ApiClient.FormData.fromMap({
        "email": email,
        "password": password,
        'FCMToken': fcmToken,
      }),
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    print("get user profile url: ${AppConstants.getUserProfile}");
    print("base url : ${AppConstants.baseUrl}");
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.getUserProfile,
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> getOtherUserProfile(int userId) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstants.getOtherUserProfile}$userId",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> registerFreeLancer({required ApiClient.FormData formData}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.registerFreelancer,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
      body: formData,
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }
  Future<Map<String, dynamic>> registerHirer({required ApiClient.FormData formData}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.registerHirer,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
      body: formData,
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> changePassword({required String oldPassword,required String password}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.CHANGE_PASSWORD,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
      body: ApiClient.FormData.fromMap({
        "old_password":oldPassword,
        "new_password": password,
      }),
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> checkEmailOrPhoneValidation({required ValidationType type,required String value}) async {

    Map<String, dynamic>body = {
      "type":type.name,
      type.name: value,
    };
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.validatePhoneNumberOrEmail,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
      body: ApiClient.FormData.fromMap(body),
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> forgetPassword( {required String phoneNo,required String countryCode}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.FORGET,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
      body: ApiClient.FormData.fromMap({
        "contact_no": phoneNo,
        "country_code": countryCode,
      }),
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> resetPassword( {required String email, required String password,}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.RESET,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
      body: ApiClient.FormData.fromMap({
        "email": email,
        'password': password
      }),
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> logout() async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.logout,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
      // body: ApiClient.FormData.fromMap({
      //   "token_value": Get.find<AuthController>().getFcmToken(),
      // }),
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> deleteAccountOtpSend(ApiClient.FormData formData) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
        apiUrl: AppConstants.sendDeleteAccountOtp,
        apiRequestMethod: API_REQUEST_METHOD.POST,
        isWantSuccessMessage: false,
        body: formData
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> deleteAccount(ApiClient.FormData formData) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.deleteAccount,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
      body: formData
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> sendFreelancerRegisterOtp(ApiClient.FormData formData) async {
    print("hello: ${AppConstants.sendFreelancerOtp}");
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.sendFreelancerOtp,
      body: formData,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> sendForgotPasswordOtp(ApiClient.FormData formData) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.sendForgotPasswordOtp,
      body: formData,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> resetForgetPassword(ApiClient.FormData formData) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.resetPassword,
      body: formData,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> sendHirerRegisterOtp(ApiClient.FormData formData) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.registerHirerOtp,
      body: formData,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> updateFreeLancerProfile(ApiClient.FormData formData) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.updateFreelancer,
      body: formData,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> updateHirerProfile(ApiClient.FormData formData) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.updateHirer,
      body: formData,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }
  Future<Map<String, dynamic>> updateFreelancerProfileImage(ApiClient.FormData formData) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.updateFreelancerProfileImage,
      body: formData,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: false);
  }

  bool isLoggedIn() {
    return getLoginUserData()!=null;
  }
  bool isLoggedOut() {
    return getLoginUserData()==null;
  }

  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.LOGIN_USER);
    sharedPreferences.clear();
    return true;
  }

  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_NUMBER, number);
      await sharedPreferences.setString(AppConstants.USER_COUNTRY_CODE, countryCode);
    } catch (e) {
      throw e;
    }
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.NOTIFICATION) ?? true;
  }

  // void setNotificationActive(bool isActive) {
  //   // if(isActive) {
  //   //   updateToken();
  //   // }else {
  //     if(!GetPlatform.isWeb) {
  //       FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
  //       if(isLoggedIn()) {
  //         FirebaseMessaging.instance.unsubscribeFromTopic('zone_${Get.find<LocationController>().getUserAddress().zoneId}_customer');
  //       }
  //     }
  //   }
  //   sharedPreferences.setBool(AppConstants.NOTIFICATION, isActive);

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    await sharedPreferences.remove(AppConstants.USER_COUNTRY_CODE);
    return await sharedPreferences.remove(AppConstants.USER_NUMBER);
  }
}
