import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:glow_solar/data/api/Api_Handler/api_error_response.dart';
import 'package:glow_solar/data/model/response/userinfo_model.dart';
import 'package:glow_solar/enums/otp_verify_type.dart';
import 'package:glow_solar/helper/route_helper.dart';
import 'package:get/get.dart';
import '../data/repository/auth_repo.dart';

class AuthController extends GetxController implements GetxService {

  final AuthRepo authRepo;
  AuthController({required this.authRepo}) {
    // _notification = authRepo.isNotificationActive();
  }

  int ?forgotUserId;
  String ?forgotUserPhoneNo;
  bool _notification = true;
  bool _acceptTerms = true;
  bool get notification => _notification;
  bool get acceptTerms => _acceptTerms;
  String ? _userPhoneNo;
  String ? _userCountryCode;
  String? get userPhoneNo => _userPhoneNo;
  String? get userCountryCode => _userCountryCode;

  UserInfoModel ?getLoginUserData(){
    return authRepo.getLoginUserData();
  }

  String ?getFcmToken(){
    return authRepo.getFcmToken();
  }

  void updateLoginUserData({required UserInfoModel user}){
    authRepo.saveLoginUserData(user: user);
  }

  bool isLoginUser({required int userId}){
    return getLoginUserData()?.id==userId;
  }

  bool clearSharedData() {
    authRepo.clearSharedData();
    return true;
  }

  Future<Map<String,dynamic>> login(String phoneNo, String password, String countryCode) async {
    Map<String,dynamic> response = await authRepo.login(phoneNo: phoneNo, password: password,countryCode:countryCode);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      Map<String,dynamic>result =  response[API_RESPONSE.SUCCESS];
      UserInfoModel user = UserInfoModel.fromJson(result['result']);
      authRepo.saveLoginUserData(user: user);
      if(user.isVerified){
        UserInfoModel ?userInfoModel= getLoginUserData();
        userInfoModel?.phoneNo = phoneNo;
        userInfoModel?.countryCode = countryCode;
        if(userInfoModel!=null){
          updateLoginUserData(user: userInfoModel);
        }
        Get.offNamed(RouteHelper.getMainScreenRoute());
      }else{
        Get.toNamed(RouteHelper.otpVerification);
      }
    }
    return response;
  }

  Future<Map<String,dynamic>> updateFcmToken({required String fcmToken}) async {
    debugPrint("updateFcmToken:->$fcmToken");
    Map<String,dynamic> response = await authRepo.updateFcmToken(fcmToken:fcmToken);
    authRepo.setSharedPreferenceFcmToken(fcmToken: fcmToken);
    return response;
  }

  Future<bool> verifyOtp(int otpCode,OtpVerifyType verifyType) async {
    bool isVerified = false;
    Map<String,dynamic> response = await authRepo.verifyOtp(otpCode: otpCode, verifyType: verifyType,userId: forgotUserId);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      isVerified = true;
      forgotUserId = null;
      if(verifyType==OtpVerifyType.RegisterVerify){
        UserInfoModel ?userInfoModel= getLoginUserData();
        userInfoModel?.isVerified = true;
        if(userInfoModel!=null){
          updateLoginUserData(user: userInfoModel);
        }
        Get.offAllNamed(RouteHelper.getMainScreenRoute());
      }else{
        Get.offNamed(RouteHelper.getChangePasswordRoute(isChangePassword: false));
      }
    }
    return isVerified;
  }

  Future<Map<String,dynamic>> signUp(String email, String password, String name,String phoneNo, String countryCode) async {
    Map<String,dynamic> response = await authRepo.signUp(email: email, password: password, name:name,phoneNo:phoneNo,countryCode:countryCode);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      Map<String,dynamic>result =  response[API_RESPONSE.SUCCESS];
      authRepo.saveLoginUserData(user: UserInfoModel.fromJson(result['result']));
      Get.toNamed(RouteHelper.getOtpVerificationRoute(verificationType: OtpVerifyType.RegisterVerify));
    }
    return response;
  }

  Future<Map<String,dynamic>> forgetPassword(String phoneNo,String countryCode) async {
    forgotUserPhoneNo = null;
    forgotUserId = null;
    Map<String,dynamic> response = await authRepo.forgetPassword(phoneNo: phoneNo,countryCode:countryCode);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      forgotUserPhoneNo = response[API_RESPONSE.SUCCESS]['result']['email'];
      forgotUserId = response[API_RESPONSE.SUCCESS]['result']['id'];
      Get.toNamed(RouteHelper.getOtpVerificationRoute(verificationType: OtpVerifyType.ForgetPassword));
    }
    return response;
  }

  Future<Map<String,dynamic>> resetPassword(String password) async {
    Map<String,dynamic> response = await authRepo.resetPassword(email: forgotUserPhoneNo??"",password: password);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      Get.offAllNamed(RouteHelper.getSignInRoute());
    }
    return response;
  }

  Future<Map<String,dynamic>> changePassword(String oldPassword, String password,) async {
    Map<String,dynamic> response = await authRepo.changePassword( password: password, oldPassword:oldPassword);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      Get.offAllNamed(RouteHelper.getMainScreenRoute());
    }
    return response;
  }

  Future<Map<String,dynamic>> logout() async {
    Map<String,dynamic> response = await authRepo.logout();
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      authRepo.clearSharedData();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    }
    return response;
  }

// Future<void> loginWithSocialMedia(SocialLogInBody socialLogInBody) async {
//   _isLoading = true;
//   update();
//   Response response = await authRepo.loginWithSocialMedia(socialLogInBody.email);
//   if (response.statusCode == 200) {
//     String _token = response.body['token'];
//     if(_token != null && _token.isNotEmpty) {
//       if(Get.find<SplashController>().configModel.customerVerification && response.body['is_phone_verified'] == 0) {
//         Get.toNamed(RouteHelper.getVerificationRoute(socialLogInBody.email, _token, RouteHelper.signUp, ''));
//       }else {
//         authRepo.saveUserToken(response.body['token']);
//         await authRepo.updateToken();
//         Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
//       }
//     }else {
//       Get.toNamed(RouteHelper.getForgotPassRoute(true, socialLogInBody));
//     }
//   } else {
//     showCustomSnackBar(response.statusText);
//   }
//   _isLoading = false;
//   update();
// }

// Future<void> registerWithSocialMedia(SocialLogInBody socialLogInBody) async {
//   _isLoading = true;
//   update();
//   Response response = await authRepo.registerWithSocialMedia(socialLogInBody);
//   if (response.statusCode == 200) {
//     String _token = response.body['token'];
//     if(Get.find<SplashController>().configModel.customerVerification && response.body['is_phone_verified'] == 0) {
//       Get.toNamed(RouteHelper.getVerificationRoute(socialLogInBody.phone, _token, RouteHelper.signUp, ''));
//     }else {
//       authRepo.saveUserToken(response.body['token']);
//       await authRepo.updateToken();
//       Get.toNamed(RouteHelper.getAccessLocationRoute('sign-in'));
//     }
//   } else {
//     showCustomSnackBar(response.statusText);
//   }
//   _isLoading = false;
//   update();
// }

// Future<ResponseModel> forgetPassword(String email) async {
//   _isLoading = true;
//   update();
//   Response response = await authRepo.forgetPassword(email);
//
//   ResponseModel responseModel;
//   if (response.statusCode == 200) {
//     responseModel = ResponseModel(true, response.body["message"]);
//   } else {
//     responseModel = ResponseModel(false, response.statusText);
//   }
//   _isLoading = false;
//   update();
//   return responseModel;
// }

// Future<void> updateToken() async {
//   await authRepo.updateToken();
// }

// Future<ResponseModel> verifyToken(String email) async {
//   _isLoading = true;
//   update();
//   Response response = await authRepo.verifyToken(email, _verificationCode);
//   ResponseModel responseModel;
//   if (response.statusCode == 200) {
//     responseModel = ResponseModel(true, response.body["message"]);
//   } else {
//     responseModel = ResponseModel(false, response.statusText);
//   }
//   _isLoading = false;
//   update();
//   return responseModel;
// }

// Future<ResponseModel> resetPassword(String resetToken, String number, String password, String confirmPassword) async {
//   _isLoading = true;
//   update();
//   Response response = await authRepo.resetPassword(resetToken, number, password, confirmPassword);
//   ResponseModel responseModel;
//   if (response.statusCode == 200) {
//     responseModel = ResponseModel(true, response.body["message"]);
//   } else {
//     responseModel = ResponseModel(false, response.statusText);
//   }
//   _isLoading = false;
//   update();
//   return responseModel;
// }

// Future<ResponseModel> checkEmail(String email) async {
//   _isLoading = true;
//   update();
//   Response response = await authRepo.checkEmail(email);
//   ResponseModel responseModel;
//   if (response.statusCode == 200) {
//     responseModel = ResponseModel(true, response.body["token"]);
//   } else {
//     responseModel = ResponseModel(false, response.statusText);
//   }
//   _isLoading = false;
//   update();
//   return responseModel;
// }

// Future<ResponseModel> verifyEmail(String email, String token) async {
//   _isLoading = true;
//   update();
//   Response response = await authRepo.verifyEmail(email, _verificationCode);
//   ResponseModel responseModel;
//   if (response.statusCode == 200) {
//     authRepo.saveUserToken(token);
//     await authRepo.updateToken();
//     responseModel = ResponseModel(true, response.body["message"]);
//   } else {
//     responseModel = ResponseModel(false, response.statusText);
//   }
//   _isLoading = false;
//   update();
//   return responseModel;
// }

// Future<ResponseModel> verifyPhone(String phone, String token) async {
//   _isLoading = true;
//   update();
//   Response response = await authRepo.verifyPhone(phone, _verificationCode);
//   ResponseModel responseModel;
//   if (response.statusCode == 200) {
//     authRepo.saveUserToken(token);
//     await authRepo.updateToken();
//     responseModel = ResponseModel(true, response.body["message"]);
//   } else {
//     responseModel = ResponseModel(false, response.statusText);
//   }
//   _isLoading = false;
//   update();
//   return responseModel;
// }

// Future<void> updateZone() async {
//   Response response = await authRepo.updateZone();
//   if (response.statusCode == 200) {
//     // Nothing to do
//   } else {
//     ApiChecker.checkApi(response);
//   }
// }

// String _verificationCode = '';

// String get verificationCode => _verificationCode;

// void updateVerificationCode(String query) {
//   _verificationCode = query;
//   update();
// }


// bool _isActiveRememberMe = false;

// bool get isActiveRememberMe => _isActiveRememberMe;

// void toggleTerms() {
//   _acceptTerms = !_acceptTerms;
//   update();
// }

// void toggleRememberMe() {
//   _isActiveRememberMe = !_isActiveRememberMe;
//   update();
// }

// bool isLoggedIn() {
//   return authRepo.isLoggedIn();
// }

// bool clearSharedData() {
//   Get.find<SplashController>().setModule(null);
//   return authRepo.clearSharedData();
// }

// void saveUserNumberAndPassword(String number, String password, String countryCode) {
//   authRepo.saveUserNumberAndPassword(number, password, countryCode);
// }

// String getUserNumber() {
//   return authRepo.getUserNumber() ?? "";
// }

// String getUserCountryCode() {
//   return authRepo.getUserCountryCode() ?? "";
// }

// String getUserPassword() {
//   return authRepo.getUserPassword() ?? "";
// }

// Future<bool> clearUserNumberAndPassword() async {
//   return authRepo.clearUserNumberAndPassword();
// }

// String getUserToken() {
//   return authRepo.getUserToken();
// }

// bool setNotificationActive(bool isActive) {
//   _notification = isActive;
//   authRepo.setNotificationActive(isActive);
//   update();
//   return _notification;
// }

}