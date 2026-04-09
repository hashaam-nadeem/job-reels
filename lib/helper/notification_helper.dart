import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/controller/notification_chat_controller.dart';
import 'package:jobreels/controller/post_controller.dart';
import 'package:jobreels/helper/route_helper.dart';
import '../data/model/response/chat_model.dart';
import '../view/screens/chat/chat_screen.dart';

class NotificationHelper {
  static Future<void> initializeFirebaseConfiguration() async {
    await FirebaseMessaging.instance
        .requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    )
        .then((value) {
      debugPrint('User granted permission: ${value.authorizationStatus}');
    });
    final RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      notificationAction(message: message);
    }
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      notificationAction(message: message);
      PostsController postsController = Get.find<PostsController>();
      // if(postsController.totalPosts == 0 && !postsController.isApiCalledAtLeastOneTime){
      postsController.getPosts().then((value) {
        print("my value of sharing: ${value}");
      });
    });
    FirebaseMessaging.onMessage.listen((message) {
      PostsController postsController = Get.find<PostsController>();
      // if(postsController.totalPosts == 0 && !postsController.isApiCalledAtLeastOneTime){
      postsController.getPosts().then((value) {
        print("my value of sharing: ${value}");
      });
      if (message.data['type'] == 'message') {
        // Get.find<ChatNotificationController>().updateMsgCounter();
      } else {
        // Get.find<ChatNotificationController>().updateNotiCounter();
      }
      debugPrint("onMessage: ${message.data['type']}");
    });

    FirebaseMessaging.instance.getAPNSToken().then((value) {
      debugPrint("APNS Token:->>> $value");
    });
    FirebaseMessaging.instance.getToken().then((value) {
      debugPrint("FCM Token:->>> $value");
    });
  }

  static notificationAction({required RemoteMessage message}) {
    if (message.data['type'] == "message") {
      ChatNotificationController chatController =
          Get.find<ChatNotificationController>();
      Map<String, dynamic> jsonData = message.data;
      ChatMessage msg = ChatMessage(
        message: message.notification?.body ?? "",
        isRead: 0,
        dateTime: DateTime.now(),
        isMyMessage: false,
        threadId: int.parse("${jsonData['thread_id']}"),
      );
      if (chatController.currentOpenedThread?.id != msg.threadId) {
        Get.to(() => ChatScreen(
            userId: int.parse("${jsonData['from_user_id']}"),
            threadId: msg.threadId,
            userName: jsonData['from_user_name']));
      }
    } else {
      Get.offAllNamed(RouteHelper.getMainScreenRoute());
    }
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint(
      "onBackground: ${message.notification?.title}\t${message.notification?.body}\t${message.data}");
}
