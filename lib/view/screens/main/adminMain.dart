import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/data/api/Api_Handler/api_error_response.dart';
import 'package:jobreels/data/model/response/post.dart';
import 'package:jobreels/data/model/response/user.dart';
import 'package:jobreels/helper/helper.dart';
import 'package:jobreels/helper/myRoutes.dart';
import 'package:jobreels/view/base/video_thumnail_layout.dart';
import 'package:jobreels/view/screens/Post/upload_post.dart';
import 'package:jobreels/view/screens/VideoCreater/record_video.dart';
import 'package:jobreels/view/screens/VideoCreater/recorded_video_preview.dart';
import 'package:jobreels/view/screens/home/home_screen.dart';
import 'package:jobreels/view/screens/main/admincustomdrawer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AdminMainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _admin();
  }
}

class _admin extends State<AdminMainScreen> {
  var width, height;
  User? user;
  List<Post> myPostedVideosList = [];
  List<Post> otherUsersSavedPosts = [];
  bool isProfileFetching = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var myUser;
  @override
  void initState() {
    getUserProfileData();
    super.initState();
    // if (!widget.isMyProfile) {
    //   widget.userId;
    // }
  }

  RefreshController refreshController = RefreshController();
   
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      drawer: AdminCustomDrawer(),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: (){
            _scaffoldKey.currentState!.openDrawer();
          },
          child: Icon(Icons.menu,color: Colors.white,size: height*.04,
         
           ),
        ),
        centerTitle: true,
        title: Text(
          "Admin",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          myPostedVideosList.isEmpty
              ? Container(
                  height: 0,
                  width: 0,
                )
              : GestureDetector(
                  onTap: () {
                    MyAppRoutes.push(context, RecordVideo());
                  },
                  child: Icon(
                    Icons.add_box_rounded,
                    color: Colors.white,
                    size: height * .04,
                  ),
                ),
          SizedBox(
            width: width * .04,
          ),
        ],
      ),
      body: Container(
          width: width,
          height: height,
          padding: EdgeInsets.all(width * .03),
          child: SmartRefresher(
            controller: refreshController,
            onRefresh: () async {
              await getUserProfileData();
              refreshController.refreshCompleted();
            },
            child: myPostedVideosList.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          MyAppRoutes.push(context, RecordVideo());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: width * .25,
                              height: height * .06,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(width * .02),
                                color: Theme.of(context).primaryColor,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: height * .05,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : SizedBox(
                    width: context.width - 10,
                    child: GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: myPostedVideosList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio:
                            0.57, // Adjust the aspect ratio as needed
                      ),
                      itemBuilder: (context, index) {
                        Post post = myPostedVideosList[index];
                        print("my post is: ${myPostedVideosList.length}");
                        return GestureDetector(
                          onTap: () {
                            Get.to(() => HomeScreen(
                                postListToRender: myPostedVideosList,
                                initialPage: index,
                                title: getUserName(user: user!),
                                showVisitProfileButton: false));
                          },
                          child: Stack(
                            children: [
                              VideoGridSearch(post: post),
                              // if (widget
                              //     .isMyProfile)
                              //   Positioned(
                              //     left: 15,
                              //     bottom: 25,
                              //     child: InkWell(
                              //       onTap:
                              //           () async {
                              //         Get.to(
                              //           () =>
                              //               UploadPost(
                              //             postForm:
                              //                 PostForm(
                              //               postId:
                              //                   post.id,
                              //               title:
                              //                   post.title,
                              //               description:
                              //                   post.description,
                              //               portfolio:
                              //                   post.portfolio,
                              //               listSkills:
                              //                   post.skills,
                              //               socialLinks:
                              //                   post.socialLinks,
                              //             ),
                              //             isUpdateVideo:
                              //                 true,
                              //           ),
                              //         );
                              //       },
                              //       child:
                              //           Container(
                              //         height: 30,
                              //         width: 30,
                              //         decoration:
                              //             BoxDecoration(
                              //           color: Theme.of(
                              //                   context)
                              //               .primaryColorLight,
                              //           shape: BoxShape
                              //               .circle,
                              //         ),
                              //         alignment:
                              //             Alignment
                              //                 .center,
                              //         child: Icon(
                              //           FontAwesome5
                              //               .edit,
                              //           size: 15,
                              //           color: Theme.of(
                              //                   context)
                              //               .primaryColor,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // if (widget
                              //     .isMyProfile)
                              //   Positioned(
                              //     right: 15,
                              //     bottom: 25,
                              //     child: InkWell(
                              //       onTap:
                              //           () async {
                              //         showPopUpAlert(
                              //           popupObject: PopupObject(
                              //               title: "Confirm Delete",
                              //               body: "Are you sure you want to delete this post?",
                              //               buttonText: null,
                              //               onYesPressed: () {
                              //                 Get.find<PostsController>().deleteVideo(post.id!).then((bool
                              //                     isDeleted) {
                              //                   if (isDeleted) {
                              //                     Get.back();
                              //                     myPostedVideosList.removeWhere((video) => video.id == post.id);
                              //                     setState(() {});
                              //                   }
                              //                 });
                              //               }),
                              //         );
                              //       },
                              //       child:
                              //           Container(
                              //         height: 30,
                              //         width: 30,
                              //         decoration:
                              //             BoxDecoration(
                              //           color: Theme.of(
                              //                   context)
                              //               .primaryColorLight,
                              //           shape: BoxShape
                              //               .circle,
                              //         ),
                              //         alignment:
                              //             Alignment
                              //                 .center,
                              //         child: Icon(
                              //           Ionicons
                              //               .trash,
                              //           size: 15,
                              //           color: Theme.of(
                              //                   context)
                              //               .errorColor,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
          )),
    );
  }

  Future getUserProfileData() async {
    if (Get.find<AuthController>().authRepo.isLoggedOut()) {
    } else {
      setState(() {
        myUser = Get.find<AuthController>().getLoginUserData()!;
      });
    }

    Map<String, dynamic> response =
        await Get.find<AuthController>().getUserProfile();
    // (myUser.userId == null
    //     ?
    //     : Get.find<AuthController>().getOtherUserProfile(myUser.userId!));
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      Map<String, dynamic> result = response[API_RESPONSE.SUCCESS];
      print("result['data'].........>${result['data']}");
      setState(() {
        user = User.fromJson(result['data']);
      });

      // if (!myUser!.isFreelancer && myUser.isMyProfile) {
      //   // otherUsersSavedPosts =
      //   //     List<Post>.from(result['saved_posts'].map((e) => Post.fromJson(e)))
      //   //         .toList();
      // } else {

      print("hello world:");
      print("user post: ${result['posts']}");
      myPostedVideosList =
          List<Post>.from(result['posts'].map((e) => Post.fromJson(e)))
              .toList();
      // }
      // if (widget.isMyProfile) {
      //   print("my profile updated data: ${user!.isSubscribed} ");
      //   Get.find<AuthController>().authRepo.saveLoginUserData(user: user!);
      // }
    }
    if (mounted) {
      setState(() {
        isProfileFetching = false;
      });
    }
  }

}
