import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:jobreels/controller/notification_chat_controller.dart';
import 'package:jobreels/data/api/Api_Handler/api_error_response.dart';
import 'package:jobreels/data/model/helpers.dart';
import 'package:jobreels/data/model/response/user.dart';
import 'package:jobreels/enums/report_type.dart';
import 'package:jobreels/helper/myRoutes.dart';
import 'package:jobreels/helper/route_helper.dart';
import 'package:get/get.dart';
import 'package:jobreels/main.dart';
import 'package:jobreels/view/base/popup_alert.dart';
import 'package:jobreels/view/screens/main/adminMain.dart';
import 'package:jobreels/view/screens/profile/ProfileScreen.dart';
import '../data/repository/auth_repo.dart';
import '../enums/validation_type.dart';
import 'package:dio/dio.dart' as ApiClient;
import '../util/app_strings.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo}) {
    // _notification = authRepo.isNotificationActive();
  }

  int? forgotUserId;
  String? forgotUserPhoneNo;
  final bool _notification = true;
  final bool _acceptTerms = true;
  bool get notification => _notification;
  bool get acceptTerms => _acceptTerms;
  String? _userPhoneNo;
  String? _userCountryCode;
  String? get userPhoneNo => _userPhoneNo;
  String? get userCountryCode => _userCountryCode;

  User? getLoginUserData() {
    return authRepo.getLoginUserData();
  }

  bool get isLoginUserSubscribed =>
      authRepo.getSubscribedUsers.contains(getLoginUserData()?.id ?? -1);

  String? getFcmToken() {
    return authRepo.getFcmToken();
  }

  void setLoginUserSubscription() {
    User? user = authRepo.getLoginUserData();
    if (user != null) {
      if (authRepo.getSubscribedUsers.contains(user.id ?? -1)) {
        user.isSubscribed = true;
        authRepo.saveLoginUserData(user: user);
      }
    }
    update();
  }

  void cancelUserSubscription() {
    User? user = authRepo.getLoginUserData();
    if (user != null) {
      authRepo.cancelUserSubscription(user.id ?? -1);
    }
    setLoginUserSubscription();
    update();
  }

  void subscribeUser() {
    User? user = authRepo.getLoginUserData();
    if (user != null) {
      authRepo.subscribeUser(user.id ?? -1);
    }
    setLoginUserSubscription();
    update();
  }

  void updateLoginUserData({required User user}) {
    authRepo.saveLoginUserData(user: user);
  }

  bool isLoginUser({required int userId}) {
    return getLoginUserData()?.id == userId;
  }

  bool clearSharedData() {
    authRepo.clearSharedData();
    return true;
  }

  Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    Map<String, dynamic> response = await authRepo.login(
      email: email,
      password: password,
    );
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      Map<String, dynamic> result = response[API_RESPONSE.SUCCESS];
      authRepo.saveAuthToken(result['token']);
      User user = User.fromJson(result['data']);
      authRepo.saveLoginUserData(user: user);
      if (user.isVerified) {
        User? userInfoModel = getLoginUserData();
        userInfoModel?.email = email;
        if (userInfoModel != null) {
          updateLoginUserData(user: userInfoModel);
        }
        // MyAppRoutes.makeFirst(context, page)
        // if (user.type.toString() == "admin") {
        //   Get.to(AdminMainScreen());
        // } else {
        Get.offNamed(RouteHelper.getMainScreenRoute());
        // }
      } else {
        Get.toNamed(RouteHelper.otpVerification);
      }
    }
    return response;
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    Map<String, dynamic> response = await authRepo.getUserProfile();
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      Map<String, dynamic> result = response[API_RESPONSE.SUCCESS];
      debugPrint("api resule current user:-> $result");
    }
    return response;
  }

  Future<Map<String, dynamic>> getOtherUserProfile(int id) async {
    Map<String, dynamic> response = await authRepo.getOtherUserProfile(id);
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      Map<String, dynamic> result = response[API_RESPONSE.SUCCESS];
      debugPrint("api resule:-> $result");
    }
    return response;
  }

  Future<Map<String, dynamic>> updateFcmToken(
      {required String fcmToken}) async {
    // debugPrint("updateFcmToken:->$fcmToken");
    Map<String, dynamic> response =
        await authRepo.updateFcmToken(fcmToken: fcmToken);
    authRepo.setSharedPreferenceFcmToken(fcmToken: fcmToken);
    return response;
  }

  Future<Map<String, dynamic>> registerFreeLancer(
      ApiClient.FormData formData) async {
    Map<String, dynamic> response = await authRepo.registerFreeLancer(
      formData: formData,
    );
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      showPopUpAlert(
          popupObject: PopupObject(
            title: "Success",
            body: AppString.freeLancerRegisterWelcomeMessage,
            hideTopRightCancelButton: true,
            buttonText: "Ok",
            onYesPressed: () {
              Get.offAllNamed(RouteHelper.getMainScreenRoute());
            },
          ),
          barrierDismissible: false);
    }
    return response;
  }

  Future<Map<String, dynamic>> registerHirer(
      ApiClient.FormData formData) async {
    Map<String, dynamic> response = await authRepo.registerHirer(
      formData: formData,
    );
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      showPopUpAlert(
          popupObject: PopupObject(
            title: "Success",
            body: AppString.hirerRegisterWelcomeMessage,
            hideTopRightCancelButton: true,
            buttonText: "Ok",
            onYesPressed: () {
              Get.offAllNamed(RouteHelper.getMainScreenRoute());
            },
          ),
          barrierDismissible: false);
    }
    return response;
  }

  Future<Map<String, dynamic>> resetPassword(String password) async {
    Map<String, dynamic> response = await authRepo.resetPassword(
        email: forgotUserPhoneNo ?? "", password: password);
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      Get.offAllNamed(RouteHelper.getSignInRoute());
    }
    return response;
  }

  Future<Map<String, dynamic>> changePassword(
    String oldPassword,
    String password,
  ) async {
    Map<String, dynamic> response = await authRepo.changePassword(
        password: password, oldPassword: oldPassword);
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      Get.offAllNamed(RouteHelper.getMainScreenRoute());
    }
    return response;
  }

  Future<Map<String, dynamic>> checkEmailOrPhoneValidation(
    ValidationType type,
    String value,
  ) async {
    Map<String, dynamic> response =
        await authRepo.checkEmailOrPhoneValidation(type: type, value: value);
    return response;
  }

  Future<Map<String, dynamic>> sendFreelancerRegisterOtp(
    ApiClient.FormData formData,
  ) async {
    Map<String, dynamic> response =
        await authRepo.sendFreelancerRegisterOtp(formData);
    return response;
  }

  Future<Map<String, dynamic>> sendForgotPasswordOtp(
    ApiClient.FormData formData,
  ) async {
    Map<String, dynamic> response =
        await authRepo.sendForgotPasswordOtp(formData);
    return response;
  }

  Future<Map<String, dynamic>> resetForgetPassword(
    ApiClient.FormData formData,
  ) async {
    Map<String, dynamic> response =
        await authRepo.resetForgetPassword(formData);
    return response;
  }

  Future<Map<String, dynamic>> sendHirerRegisterOtp(
    ApiClient.FormData formData,
  ) async {
    Map<String, dynamic> response =
        await authRepo.sendHirerRegisterOtp(formData);
    return response;
  }

  Future<Map<String, dynamic>> updateFreelancerProfile(
      ApiClient.FormData formData) async {
    Map<String, dynamic> response =
        await authRepo.updateFreeLancerProfile(formData);
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      User user = User.fromJson(response[API_RESPONSE.SUCCESS]["data"]);
      Get.find<AuthController>().updateLoginUserData(user: user);
      Get.back();
      // Get.offAllNamed(RouteHelper.getMainScreenRoute(bottomNavBarIndex: 3));
    }

    return response;
  }

  Future<Map<String, dynamic>> updateHirerProfile(
      ApiClient.FormData formData) async {
    Map<String, dynamic> response = await authRepo.updateHirerProfile(formData);
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      User user = User.fromJson(response[API_RESPONSE.SUCCESS]["data"]);
      Get.find<AuthController>().updateLoginUserData(user: user);
      Get.back();
      // Get.offAllNamed(RouteHelper.getMainScreenRoute(bottomNavBarIndex: 3));
    }

    return response;
  }

  Future<Map<String, dynamic>> updateFreelancerProfileImage(
      ApiClient.FormData formData) async {
    Map<String, dynamic> response =
        await authRepo.updateFreelancerProfileImage(formData);

    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      User user = User.fromJson(response[API_RESPONSE.SUCCESS]["data"]);
      Get.find<AuthController>().updateLoginUserData(user: user);

      showPopUpAlert(
        popupObject: PopupObject(
          title: "Success",
          body: "Picture updated successfully.",
          buttonText: "Ok",
          onYesPressed: () {
            Get.back();
            Get.back();
          },
          hideTopRightCancelButton: true,
        ),
        barrierDismissible: false,
      );
    }
    return response;
  }

  Future<Map<String, dynamic>> logout() async {
    Map<String, dynamic> response = await authRepo.logout();
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      clearControllersDataOnLogout();
      List<int> subscribedUsersList = [];
      subscribedUsersList.addAll(authRepo.getSubscribedUsers);
      authRepo.clearSharedData();
      for (int userId in subscribedUsersList) {
        authRepo.subscribeUser(userId);
      }
      jobReelSocket.disconnect();
      Get.offAllNamed(RouteHelper.getMainScreenRoute());
    }
    return response;
  }

  void clearControllersDataOnLogout() {
    Get.find<ChatNotificationController>().clearData();
    Get.find<ChatNotificationController>().chatThreadList.clear();
    Get.find<ChatNotificationController>().chatMessageList.clear();
  }

  Future<Map<String, dynamic>> deleteAccount(
      ApiClient.FormData formData) async {
    Map<String, dynamic> response = await authRepo.deleteAccount(formData);
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      if (response.containsKey(API_RESPONSE.SUCCESS)) {
        showPopUpAlert(
            popupObject: PopupObject(
              title: "Success",
              body: AppString.accountDeleteSuccessfully,
              hideTopRightCancelButton: true,
              buttonText: "Back to Home",
              onYesPressed: () {
                authRepo.clearSharedData();
                Get.offAllNamed(RouteHelper.getMainScreenRoute());
              },
            ),
            barrierDismissible: false);
      }
    }
    return response;
  }

  Future<Map<String, dynamic>> deleteAccountOtpSend(
      ApiClient.FormData formData) async {
    Map<String, dynamic> response =
        await authRepo.deleteAccountOtpSend(formData);
    return response;
  }

  void visitProfile(int userId, User? user) {
    User? loginUser = getLoginUserData();
    if (loginUser != null) {
      if (loginUser.isFreelancer &&
          loginUser.id.toString() == userId.toString()) {
        // Get.to(() => ProfileScreen(
        //       showAppbarLeading: true,
        //       isMyProfile: true,
        //       userId: userId,
        //     ));

        Get.to(() => ProfileScreen(
            showAppbarLeading: true, user: user, isMyProfile: true));
      } else if (!loginUser.isFreelancer) {
        print("hello::");
        Get.to(() => ProfileScreen(
              showAppbarLeading: true,
              isMyProfile: false,
              user: user,
              userId: userId,
            ));
      } else {
        //i have to comment it later
        Get.to(() => ProfileScreen(
              showAppbarLeading: true,
              isMyProfile: false,
              user: user,
              userId: userId,
            ));
      }
    } else {
      Get.to(() => ProfileScreen(
            showAppbarLeading: true,
            user: user,
            isMyProfile: false,
            userId: userId,
          ));
    }
  }
}
