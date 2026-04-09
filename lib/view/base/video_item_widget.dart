import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/controller/post_controller.dart';
import 'package:jobreels/data/model/body/post_upload.dart';
import 'package:jobreels/data/model/helpers.dart';
import 'package:jobreels/data/model/response/post.dart';
import 'package:jobreels/enums/report_type.dart';
import 'package:jobreels/helper/helper.dart';
import 'package:jobreels/helper/route_helper.dart';
import 'package:jobreels/util/dimensions.dart';
import 'package:jobreels/util/images.dart';
import 'package:jobreels/util/styles.dart';
import 'package:jobreels/view/base/custom_image.dart';
import 'package:jobreels/view/base/loading_widget.dart';
import 'package:jobreels/view/base/popup_alert.dart';
import 'package:jobreels/view/screens/report/report_user_or_post.dart';
import 'package:jobreels/view/screens/Post/upload_post.dart';
import 'package:jobreels/view/screens/home/widgets/view_more_information.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../custom_packages/custom_flutter_linkify.dart';
import '../../util/app_constants.dart';
import '../../util/app_strings.dart';
import '../screens/profile/ProfileScreen.dart';
import 'ImageView.dart';
import 'custom_button.dart';
import 'custom_loader.dart';

class VideoItem extends StatefulWidget {
  final Post post;
  var myuserId;
  final bool isFirstVideo;
  final bool showVisitProfileButton;
  final PageController? pageController;
  VideoItem(
      {super.key,
      required this.myuserId,
      required this.post,
      this.isFirstVideo = false,
      this.pageController,
      this.showVisitProfileButton = true});

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> with WidgetsBindingObserver {
  VideoPlayerController? controller;
  late Post post;
  bool seeMore = false;
  bool showSeeMore = false;
  bool isUpdatingPostSaveStatus = false;
  File? videoFile;
  bool isVideoPlaying = true;

  @override
  void initState() {
    post = widget.post;
    showSeeMore = post.description.length > 60;
    post.videoFuture.then((file) {
      videoFile = file;
      _initializeController();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (AuthController authController) {
      // print("my user is ph: ${post.user!}");
      return VisibilityDetector(
        key: Key(post.video),
        onVisibilityChanged: (VisibilityInfo visibilityInfo) {
          double visiblePercentage = visibilityInfo.visibleFraction * 100;
          try {
            if (controller?.hasListeners ?? false) {
              if (visiblePercentage == 100) {
                controller!.setLooping(true);
                controller!.play();
                debugPrint("Visibility Detector Play");
              } else {
                debugPrint("Visibility Detector Pause");
                controller!.pause();
              }
            }
          } catch (e) {
            debugPrint("Exception on videoItem Page Scrolling:-> $e");
          }
          if (mounted) {
            setState(() {});
          }
        },
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            controller?.value.isBuffering ?? true
                ? CustomImage(
                    image: post.thumbnail,
                    isProfileImage: false,
                    height: context.height,
                    width: context.width,
                    fit: BoxFit.cover,
                  )
                : SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: controller?.value.size.width ?? context.width,
                        height: controller?.value.size.height ?? context.height,
                        child: controller?.value.isInitialized ?? false
                            ? GestureDetector(
                                onTap: () {
                                  if (controller!.value.isPlaying) {
                                    debugPrint("Gesture Detector Pause");
                                    controller!.pause();
                                    isVideoPlaying = false;
                                  } else {
                                    controller!.play();
                                    isVideoPlaying = true;
                                  }
                                  setState(() {});
                                },
                                child: VideoPlayer(controller!),
                              )
                            : CustomImage(
                                image: post.thumbnail,
                                isProfileImage: false,
                                height: context.height,
                                width: context.width,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),

            /// View More Information
            // if(!(authController.getLoginUserData()?.isFreelancer??false) || (authController.getLoginUserData()?.id == post.user?.id)|| (widget.myuserId.toString() == post.user?.id.toString()))
            post.user?.id.toString() == widget.myuserId.toString()
                ? Container(
                    height: 0,
                    width: 0,
                  )
                : Positioned(
                    bottom: 20,
                    child: CustomButton(
                      onPressed: () async {
                        if (widget.myuserId == post.user?.id) {
                          Get.to(() => ProfileScreen(
                                userId: post.userId,
                                user: post.user,
                                isMyProfile: false,
                                showAppbarLeading: true,
                              ));
                        } else {
                          Get.to(() => ViewMoreInformation(
                              post: post,
                              showVisitProfileButton:
                                  widget.showVisitProfileButton));
                        }
                      },
                      height: 30,
                      width: 180,
                      buttonText: AppString.moreInformation,
                    ),
                  ),
            if (widget.isFirstVideo && widget.pageController != null)
              Positioned(
                bottom: 20,
                right: 10,
                child: InkWell(
                  onTap: () {
                    widget.pageController?.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.bounceIn);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: RotatedBox(
                      quarterTurns: 4,
                      child: Image.asset(
                        Images.scrollUpToDown,
                        height: 25,
                        width: 25,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ),
                ),
              ),

            Positioned(
              bottom: 50,
              child: Container(
                width: context.width,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /// User first Name and post descriptions
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () {
                                Get.find<AuthController>()
                                    .visitProfile(post.userId!, post.user);
                              },
                              child: Text(
                                '@${getUserName(user: post.user!)}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16),
                              )),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            constraints: BoxConstraints(
                                maxHeight: context.height * 0.35),
                            child: SingleChildScrollView(
                              child: Linkify(
                                onOpen: (link) {
                                  openUrlInExternalApp(link.url);
                                },
                                text: showSeeMore && !seeMore
                                    ? post.description.substring(0, 60)
                                    : post.description,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColorLight),
                                linkStyle:
                                    const TextStyle(color: Color(0xFF1967d2)),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          if (showSeeMore)
                            InkWell(
                              onTap: () {
                                setState(() {
                                  seeMore = !seeMore;
                                });
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, bottom: 5),
                                child: Text(
                                  seeMore ? 'See less' : 'See More',
                                  style: montserratRegular.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          const SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        /// User Profile Picture
                        InkWell(
                          onTap: () {
                            Get.find<AuthController>()
                                .visitProfile(post.userId!, post.user);
                          },
                          radius: 50,
                          borderRadius: BorderRadius.circular(50),
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: const BoxDecoration(
                                color: Color(0xFF9B9696),
                                shape: BoxShape.circle),
                            clipBehavior: Clip.antiAlias,
                            child: post.userId == 165
                                ? Image.asset(Images.logo)
                                : CustomImage(
                                    image: post.user!.profilePicture!,
                                    isProfileImage: true),
                          ),
                        ),
                        const SizedBox(
                          height: Dimensions.PADDING_SIZE_SMALL,
                        ),

                        /// User Profile share
                        InkWell(
                          onTap: () async {
                            // ApiLoader.show();
                            String? link = await getFirebaseDynamicLink(post);
                            // ApiLoader.hide();
                            if (link != null) {
                              await sharePostLinkToExternalApp(
                                  text:
                                      "Check out the video cover letter of one of my favorite job seekers on the JobReels app.\r\n$link",
                                  context: context);
                            }
                          },
                          child: SizedBox(
                            height: 60,
                            width: 60,
                            child: Center(
                              child: Icon(
                                Fontisto.share_a,
                                size: 25,
                                color: Theme.of(context).primaryColorLight,
                              ),
                            ),
                          ),
                        ),
                        if (!(authController.getLoginUserData()?.isFreelancer ??
                            true))
                          InkWell(
                            onTap: isUpdatingPostSaveStatus
                                ? null
                                : () async {
                                    isUpdatingPostSaveStatus = true;
                                    setState(() {});
                                    bool newStatus = !post.userSaved;
                                    await Get.find<PostsController>()
                                        .toggleSavePost(post.id!, newStatus);
                                    isUpdatingPostSaveStatus = false;
                                    if (mounted) {
                                      post.userSaved = newStatus;
                                      setState(() {});
                                    }
                                  },
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Center(
                                child: Icon(
                                  Ionicons.md_bookmark,
                                  size: 25,
                                  color: isUpdatingPostSaveStatus
                                      ? Colors.grey
                                      : post.userSaved
                                          ? Theme.of(context)
                                              .secondaryHeaderColor
                                          : Theme.of(context).primaryColorLight,
                                ),
                              ),
                            ),
                          ),
                        if (post.userId!.toString() !=
                            widget.myuserId.toString())
                          InkWell(
                            onTap: () async {
                              if (authController.authRepo.isLoggedIn()) {
                                Get.to(() => ReportVideo(
                                      id: post.id!,
                                      reportType: Report.Post,
                                    ));
                              } else {
                                showPopUpAlert(
                                  popupObject: PopupObject(
                                    title: 'Login Required',
                                    body: 'Please login to Report.',
                                    buttonText: "Login Now",
                                    onYesPressed: () {
                                      Get.back();
                                      Get.toNamed(RouteHelper.getSignInRoute());
                                    },
                                    hideTopRightCancelButton: true,
                                  ),
                                );
                              }
                            },
                            child: SizedBox(
                              height: 50,
                              width: 50,
                              child: Center(
                                child: Icon(
                                  Ionicons.md_flag,
                                  size: 25,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: Dimensions.PADDING_SIZE_DEFAULT,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            if (videoFile == null)
              const Align(
                alignment: Alignment.center,
                child: CustomLoader(),
              ),

            if (!isVideoPlaying)
              Align(
                alignment: Alignment.center,
                child: IgnorePointer(
                    ignoring: true,
                    child: Icon(
                      Ionicons.play,
                      size: 60,
                      color: Theme.of(context).primaryColorLight,
                    )),
              ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    controller?.removeListener(_videoDurationListener);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initializeController();
    } else {
      controller?.dispose();
    }
  }

  _initializeController() async {
    await Future.delayed(const Duration(milliseconds: 200));
    controller = VideoPlayerController.file(videoFile!)
      ..initialize().then((_) {
        controller!.addListener(_videoDurationListener);
        try {
          if (controller?.hasListeners ?? false) {
            controller!.setLooping(true);
            if (post.videoPlayDuration.inMicroseconds > 0) {
              controller!.seekTo(post.videoPlayDuration);
            }
            if (ModalRoute.of(context)?.isCurrent ?? false) {
              controller!.play();
              isVideoPlaying = true;
            }
          }
        } catch (e) {
          debugPrint("Exception on videoItem Page:-> $e");
        }
        if (mounted) {
          setState(() {});
        }
      }).catchError((error) {
        debugPrint("Error in video player:-> $error");
      });
    if (mounted) {
      setState(() {});
    }
  }

  _videoDurationListener() {
    post.videoPlayDuration = controller!.value.position;
  }
}
