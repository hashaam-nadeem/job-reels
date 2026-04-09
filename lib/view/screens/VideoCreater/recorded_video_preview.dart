import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:jobreels/data/model/body/post_upload.dart';
import 'package:jobreels/data/model/response/social_media_links.dart';
import 'package:jobreels/util/app_strings.dart';
import 'package:jobreels/view/base/custom_button.dart';
import 'package:jobreels/view/base/custom_loader.dart';
import 'package:jobreels/view/screens/chat/singletonclass.dart';
import 'package:video_player/video_player.dart';
import 'dart:math' as math;
import '../Post/upload_post.dart';

class RecordedVideoPreview extends StatefulWidget {
  final XFile videoFile;
  var isFrontCamera = false;
  RecordedVideoPreview({
    Key? key,
    required this.isFrontCamera,
    required this.videoFile,
  }) : super(key: key);

  @override
  State<RecordedVideoPreview> createState() => _RecordedVideoPreviewState();
}

class _RecordedVideoPreviewState extends State<RecordedVideoPreview> {
  VideoPlayerController? controller;

  @override
  void initState() {
    _initializeController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        controller?.value.isInitialized ?? false
            ? widget.isFrontCamera == true
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: AspectRatio(
                      aspectRatio: context.width /
                          (context.height - kBottomNavigationBarHeight),
                      // width: context.width,
                      // height: context.height - kBottomNavigationBarHeight,
                      child: GestureDetector(
                        onTap: () {
                          if (controller!.value.isPlaying) {
                            controller!.pause();
                          } else {
                            controller!.play();
                          }
                          setState(() {});
                        },
                        child: VideoPlayer(controller!),
                      ),
                    ),
                  )
                : AspectRatio(
                    aspectRatio: context.width /
                        (context.height - kBottomNavigationBarHeight),
                    // width: context.width,
                    // height: context.height - kBottomNavigationBarHeight,
                    child: GestureDetector(
                      onTap: () {
                        if (controller!.value.isPlaying) {
                          controller!.pause();
                        } else {
                          controller!.play();
                        }
                        setState(() {});
                      },
                      child: VideoPlayer(controller!),
                    ),
                  )
            : const CustomLoader(),
        if ((controller?.value.isInitialized ?? false) &&
            !(controller?.value.isPlaying ?? true))
          Align(
            alignment: Alignment.center,
            child: Material(
              elevation: 0,
              color: Colors.transparent,
              child: IconButton(
                  onPressed: () {
                    if (controller!.value.isPlaying) {
                      controller!.pause();
                    } else {
                      controller!.play();
                    }
                    setState(() {});
                  },
                  icon: Icon(
                    Ionicons.play,
                    size: 60,
                    color: Theme.of(context).primaryColorLight,
                  )),
            ),
          ),
        Positioned(
          bottom: 13,
          child: Container(
            width: context.width,
            padding: EdgeInsets.symmetric(horizontal: context.width * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Video Remake Button
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Get.back();
                    },
                    height: 40,
                    buttonText: UserSingleton.instance.videoFile!.path
                            .toString()
                            .isEmpty
                        ? AppString.remake
                        : "Cancel",
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textColor: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),

                /// Next Button
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      controller?.pause();
                      setState(() {});
                      Get.to(() => UploadPost(
                            isUpdateVideo: false,
                            postForm: PostForm(
                              title: '',
                              description: '',
                              listSkills: [],
                              socialLinks: SocialLinks.defaultObject(),
                              videoFilePath: widget.videoFile.path,
                            ),
                          ));
                    },
                    height: 40,
                    buttonText: AppString.next,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textColor: Theme.of(context).primaryColorLight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _initializeController() async {
    controller = VideoPlayerController.file(File(widget.videoFile.path))
      ..initialize().then((_) {
        try {
          if (mounted) {
            setState(() {});
          }
          controller!.setLooping(true);
          controller!.play();
        } catch (e) {
          debugPrint("Exception on videoItem Page:-> $e");
        }
      }).catchError((error) {
        debugPrint("Error in video player:-> $error");
      });
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
