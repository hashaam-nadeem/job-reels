import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/controller/notification_chat_controller.dart';
import 'package:jobreels/data/model/body/post_upload.dart';
import 'package:jobreels/data/model/response/freelancer.dart';
import 'package:jobreels/data/model/response/notification_model.dart';
import 'package:jobreels/data/model/response/post.dart';
import 'package:jobreels/helper/route_helper.dart';
import 'package:jobreels/view/base/loading_widget.dart';
import 'package:jobreels/view/screens/chat/singletonclass.dart';
import 'package:jobreels/view/screens/main/adminMain.dart';
import '../data/api/Api_Handler/api_error_response.dart';
import '../data/model/response/report_flag_model.dart';
import '../data/model/response/user.dart';
import '../data/repository/notification_repo.dart';
import '../data/repository/post_repo.dart';
import '../enums/report_type.dart';

class PostsController extends GetxController implements GetxService {
  final PostRepo postRepo;
  PostsController({required this.postRepo});

  final List<Post> _postList = [];
  final List<ReportFlag> _reportPostFlagList = [];
  final List<ReportFlag> _reportUserFlagList = [];
  List<ReportFlag> reportFlagList(Report reportType) =>
      reportType == Report.Post ? _reportPostFlagList : _reportUserFlagList;

  List<Post> get postList => _postList;
  bool _isFetchingData = true;
  bool get isDataFetching => _isFetchingData;
  bool isFetchingReport = false;
  int totalPosts = 0;
  bool isApiCalledAtLeastOneTime = false;
  bool isDeepLinkingInitialized = false;

  Future getPosts() async {
    Map<String, dynamic> result = await postRepo.getPostList();
    isApiCalledAtLeastOneTime = true;
    if (result.containsKey(API_RESPONSE.SUCCESS)) {
      print(
          "i got these counter: ${result[API_RESPONSE.SUCCESS]['message_counter']}");
      List<dynamic> listPost = result[API_RESPONSE.SUCCESS]['data'];
      var increment = int.parse(
              "${result[API_RESPONSE.SUCCESS]['message_counter']}") +
          int.parse("${result[API_RESPONSE.SUCCESS]['notification_counter']}");
      UserSingleton.instance.counter =
          int.parse("${result[API_RESPONSE.SUCCESS]['notification_counter']}");
      print("my notificaiton counter is:$increment");
      Get.find<ChatNotificationController>().setNotiMessageCounter(
          notiCounter: result[API_RESPONSE.SUCCESS]['notification_counter'],
          msgCounter: result[API_RESPONSE.SUCCESS]['message_counter']);
      Get.find<ChatNotificationController>().setNotiMessageCounter(
          notiCounter: result[API_RESPONSE.SUCCESS]['notification_counter'],
          msgCounter: result[API_RESPONSE.SUCCESS]['message_counter']);
      _postList.clear();
      for (var data in listPost) {
        Post post = Post.fromJson(data);
        _postList.add(post);
      }
    }
    totalPosts = _postList.length;
    _isFetchingData = false;
    update();
  }

  Future<bool> toggleSavePost(int postId, bool isSave) async {
    Map<String, dynamic> result = await postRepo.bookmarkPost(postId);
    if (result.containsKey(API_RESPONSE.SUCCESS)) {
      for (Post post in _postList) {
        if (post.id == postId) {
          post.userSaved = isSave;
          update();
          break;
        }
      }
      return true;
    } else {
      return false;
    }
  }

  Future<List<Post>> getSearchFilteredResult(String skill, String availability,
      String experience, String searchText) async {
    print("search text: ${searchText}");
    List<Post> searchedResult = [];
    debugPrint(
        "skill:->> $skill\availability:->> $availability\texperience:->> $experience\tsearchText:->> $searchText");
    if (skill.isEmpty &&
        availability.isEmpty &&
        experience.isEmpty &&
        searchText.isEmpty &&
        _postList.isNotEmpty) {
      searchedResult.addAll(_postList);
      debugPrint("searchedResult:->> ${searchedResult.length}");
    } else {
      // if(totalPosts>0){
      //   for (Post post in postList) {
      //     User user = post.user!;
      //     Freelancer freelancer = user.freelancer!;
      //     if(searchText.isNotEmpty){
      //       if(user.description.toUpperCase().contains(searchText.toUpperCase())){
      //         if(freelancer.yearsExperience.contains(experience) && freelancer.skillsAssessment.contains(skill) && freelancer.fullTime.contains(availability) ){
      //
      //         }
      //       }
      //     }else{
      //       /// Without Any Text
      //     }
      //   }
      // }
      Map<String, dynamic> result = await postRepo.getSearchedPostList(
          skill, availability, experience, searchText);
      if (result.containsKey(API_RESPONSE.SUCCESS)) {
        List<dynamic> listPost = result[API_RESPONSE.SUCCESS]['data'];
        for (var data in listPost) {
          Post post = Post.fromJson(data);
          dynamic postInList = postList.isEmpty
              ? -1
              : postList.firstWhere((element) => element.id == post.id);
          if (postInList != -1) {
            searchedResult.add(postInList);
          } else {
            searchedResult.add(post);
          }
        }
      }
    }
    searchedResult.removeWhere((post) => post.userId == 165);

    return searchedResult;
  }

  Future<bool> uploadVideo(PostForm postForm,
      {bool isUpdateVideo = false}) async {
    ApiLoader.show();
    Map<String, dynamic> result =
        await postRepo.uploadVideo(postForm, isUpdate: isUpdateVideo);
    ApiLoader.hide();
    if (result.containsKey(API_RESPONSE.SUCCESS)) {
      Post uploadedPost = Post.fromJson(result[API_RESPONSE.SUCCESS]['data']);
      if (uploadedPost.isActive &&
          uploadedPost.isApprovedByAdmin &&
          uploadedPost.status?.toLowerCase() == 'published') {
        if (isUpdateVideo) {
          for (Post data in _postList) {
            if (data.id == postForm.postId) {
              data = uploadedPost;
              break;
            }
          }
        } else {
          _postList.insert(1, uploadedPost);
        }
        var user = Get.find<AuthController>().getLoginUserData();
        print("my user type is: ${user!.type.toString()}");
        // if (user!.type.toString() == "admin") {
        //   print("i got there for navigation ");
        //   Get.to(() => AdminMainScreen());
        // } else {
        Get.offAllNamed(RouteHelper.getMainScreenRoute());
        // }
      }
    }
    return result.containsKey(API_RESPONSE.SUCCESS);
  }

  Future<bool> deleteVideo(int postId) async {
    Map<String, dynamic> result = await postRepo.deleteVideo(postId);
    if (result.containsKey(API_RESPONSE.SUCCESS)) {
      _postList.removeWhere((post) => post.id == postId);
      update();
    }
    return result.containsKey(API_RESPONSE.SUCCESS);
  }

  Future<Map<String, dynamic>> reportVideo(
      int postId, int reportFlagId, String description,
      {required Report reportType}) async {
    Map<String, dynamic> result = await postRepo
        .reportVideo(postId, reportFlagId, description, reportType: reportType);
    return result;
  }

  Future getReportFlags(Report type) async {
    if (type == Report.Post) {
      if (_reportPostFlagList.isEmpty) {
        isFetchingReport = true;
        try {
          update();
        } catch (e) {}
      }
    } else {
      if (_reportUserFlagList.isEmpty) {
        isFetchingReport = true;
        try {
          update();
        } catch (e) {}
      }
    }
    Map<String, dynamic> result = await postRepo.getReportFlagList(type);
    if (result.containsKey(API_RESPONSE.SUCCESS)) {
      List<dynamic> listReportFlags = result[API_RESPONSE.SUCCESS]['data'];
      if (type == Report.Post) {
        _reportPostFlagList.clear();
      } else {
        _reportUserFlagList.clear();
      }
      for (var data in listReportFlags) {
        ReportFlag reportFlag = ReportFlag.fromJson(data);
        if (type == Report.Post) {
          _reportPostFlagList.add(reportFlag);
        } else {
          _reportUserFlagList.add(reportFlag);
        }
      }
    }
    isFetchingReport = false;
    update();
  }
}
