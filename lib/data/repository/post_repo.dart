import 'dart:convert';
import 'package:get/get.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/data/api/Api_Handler/api_call_Structure.dart';
import 'package:jobreels/data/api/Api_Handler/api_constants.dart';
import 'package:jobreels/data/model/body/post_upload.dart';
import 'package:jobreels/data/model/response/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as ApiClient;
import '../../enums/report_type.dart';
import '../../util/app_constants.dart';

class PostRepo {
  Future<Map<String, dynamic>> getPostList() async {
    var userId = "0";
    ;
    if (Get.find<AuthController>().authRepo.isLoggedIn()) {
      // Get.find<AuthController>().authRepo.getUserProfile();
      User? user = Get.find<AuthController>().getLoginUserData();
      if (user != null) {
        userId = user.id.toString();
      } else {}
    }
    print("now my url is: ${"${AppConstants.getPostList}?user_id=$userId"}");
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstants.getPostList}?user_id=$userId",
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(
        isShowLoading: false, isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> getReportFlagList(Report type) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: type == Report.Post
          ? AppConstants.reportPostFlags
          : AppConstants.reportUserFlags,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(
      isShowLoading: false,
      isCheckAuthorization: false,
    );
  }

  Future<Map<String, dynamic>> getSearchedPostList(String skill,
      String availability, String experience, String searchText) async {
    Map<String, dynamic> bodyParameters = {
      'search': searchText,
      'years_experience': experience,
      'skills': skill,
      'availablity': availability,
    };
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.getSearchedPostList,
      body: bodyParameters,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(
        isShowLoading: false, isCheckAuthorization: false);
  }

  Future<Map<String, dynamic>> uploadVideo(PostForm postForm,
      {bool isUpdate = false}) async {
    ApiClient.FormData bodyParameters = await postForm.toApiBody();
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: isUpdate
          ? "${AppConstants.updatePost}${postForm.postId}"
          : AppConstants.uploadPost,
      body: bodyParameters,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
    );
    return await apiObject.requestAPI(
        isShowLoading: false, isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> deleteVideo(int postId) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstants.deletePost}$postId",
      apiRequestMethod: API_REQUEST_METHOD.DELETE,
      isWantSuccessMessage: true,
    );
    return await apiObject.requestAPI(
        isShowLoading: true, isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> reportVideo(
      int id, int reportFlagId, String description,
      {required Report reportType}) async {
    Map<String, dynamic> body = {
      "flag_id": reportFlagId,
      "description": description,
    };
    if (reportType == Report.Post) {
      body.addAll({
        "post_id": id,
      });
    } else {
      body.addAll({
        "reported_user_id": id,
      });
    }

    ApiClient.FormData formData = ApiClient.FormData.fromMap(body);
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: reportType == Report.Post
          ? AppConstants.reportPost
          : AppConstants.reportUser,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      body: formData,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(
        isShowLoading: true, isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> bookmarkPost(int postId) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstants.bookmarkPost}$postId",
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(
        isShowLoading: false, isCheckAuthorization: true);
  }
}
