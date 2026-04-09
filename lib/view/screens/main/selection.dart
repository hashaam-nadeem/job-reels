import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jobreels/helper/myRoutes.dart';
import 'package:jobreels/view/screens/VideoCreater/record_video.dart';
import 'package:jobreels/view/screens/chat/singletonclass.dart';

import '../VideoCreater/recorded_video_preview.dart';

class VideoSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _VideoSelection();
  }
}

class _VideoSelection extends State<VideoSelection> {
  var width, height;
  final picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      UserSingleton.instance.videoFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            MyAppRoutes.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      UserSingleton.instance.videoFile = null;
                    });
                    _pickVideo();
                  },
                  child: Container(
                    width: width * .6,
                    height: height * .08,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width * .03),
                        color: Theme.of(context).primaryColor),
                    child: Center(
                      child: Text(
                        "Gallery",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * .04,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    MyAppRoutes.push(context, RecordVideo());
                  },
                  child: Container(
                    width: width * .6,
                    height: height * .08,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width * .03),
                        color: Theme.of(context).primaryColor),
                    child: Center(
                      child: Text(
                        "Camera",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _pickVideo() async {
    PickedFile? pickedFile =
        await picker.getVideo(source: ImageSource.gallery).then((value) {
      if (value != null) {
        File? _video = File(value.path);
        XFile file = new XFile(_video.path);
        print("i picker that video: ${_video}");
        Get.to(
            () => RecordedVideoPreview(videoFile: file, isFrontCamera: false));
        setState(() {
          UserSingleton.instance.videoFile = _video;
        });
      }
    });

    // _videoPlayerController = VideoPlayerController.file(_video)..initialize().then((_) {
    setState(() {});
    // _videoPlayerController.play();
    // });
  }
}
