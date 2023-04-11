import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workerapp/controller/auth_controller.dart';
import 'package:workerapp/utils/app_images.dart';
import 'package:workerapp/utils/color_constants.dart';
import 'package:workerapp/utils/dimensions.dart';
import 'package:workerapp/utils/styles.dart';
import 'dart:math' as math;

import 'package:workerapp/view/base/custom_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackGroundColor,
      appBar: CustomAppBar(
        title: "Notifications",
        leading: IconButton(
          onPressed: (){

          },
          iconSize: 20,
          icon: const Icon(Icons.menu,color: Colors.white,),
        ),
      ),
      body: SafeArea(
          child: Container(
            width:context.width,
            height: context.height,
            color: AppColor.scaffoldBackGroundColor,
            child: Column(
              children: [
                Expanded(
                  child: GetBuilder<AuthController>(builder: (authController) {
                    return ListView.builder(
                      itemCount: notificationsList.length,
                      itemBuilder: (BuildContext listContext, int index){
                        return notificationWidget(notification: notificationsList[index]);
                      },
                    );
                  }),
                ),
              ],
            ),
          )),
    );
  }

  Widget notificationWidget({required Notification notification}){
    return Container(
      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: notification.profileImage==null
                ? Container(
                  height: 40,
                  width: 40,
                  color: const Color(0xFF72A234),
                  child: Center(
                    child: Text(
                      notification.profileName.substring(0,1).toUpperCase(),
                      style: montserratRegular.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                  ),
                )
                : Image.asset(
                  Images.defaultProfile,
                  height: 40,
                  width: 40,
                ),
          ),
          const SizedBox(
            width: Dimensions.PADDING_SIZE_DEFAULT,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                notification.profileName,
                style: montserratRegular.copyWith(
                    color: const Color(0xFF000000).withOpacity(0.87),
                    fontSize: 16,
                    fontWeight: FontWeight.w400
                ),
              ),
              Flexible(
                child: Text(
                  notification.notificationDescription,
                  style: montserratRegular.copyWith(
                      color: const Color(0xFF000000).withOpacity(0.60),
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            onPressed: (){
              setState((){
                notification.isFavourite = !notification.isFavourite;
              });
            },
            icon: Icon(
               notification.isFavourite ? Icons.star : Icons.star_border,
              color: notification.isFavourite ? const Color(0xFFFBBC04) : const Color(0xFF000000).withOpacity(0.38),
            )
          )
        ],
      ),
    );
  }

  List<Notification> notificationsList = [
    Notification(
        profileImage: null,
        profileName: "Clarisse, Leroy",
        notificationDescription: "Let’s have a coffee chat today m...",
        isFavourite: false,
    ),
    Notification(
      profileImage: null,
      profileName: "Paulo Sousa",
      notificationDescription: "I wanted to confirm the dinner da...",
      isFavourite: false,
    ),
    Notification(
      profileImage: Images.defaultProfile,
      profileName: "Corgie",
      notificationDescription: "I’m still waiting for my treats!",
      isFavourite: false,
    ),
    Notification(
      profileImage: Images.defaultProfile2,
      profileName: "Amelia Earnest",
      notificationDescription: "Meeting rescheduled for Tuesday...",
      isFavourite: false,
    ),
    Notification(
      profileImage: null,
      profileName: "Tom Broody",
      notificationDescription: "Re: New webdesign opportunity",
      isFavourite: true,
    ),
    Notification(
      profileImage: Images.defaultProfile,
      profileName: "Vicky Lee-Ting",
      notificationDescription: "The pitch deck is still not ready...",
      isFavourite: false,
    ),
  ];
}

class Notification{
  final String ?profileImage;
  final String profileName;
  final String notificationDescription;
  bool isFavourite;
  Notification({
    required this.profileImage,
    required this.profileName,
    required this.notificationDescription,
    required this.isFavourite,
});
}
