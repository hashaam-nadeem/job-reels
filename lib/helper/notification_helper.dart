import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:glow_solar/controller/auth_controller.dart';
import 'package:glow_solar/controller/notification_controller.dart';
import 'package:glow_solar/enums/notification_type.dart';
import 'package:glow_solar/helper/route_helper.dart';
import 'package:glow_solar/view/base/custom_toast.dart';

class NotificationHelper{
  static Future<void> initializeFirebaseConfiguration()async{
    if(Platform.isIOS){
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true,
      ).then((value) {
        print('User granted permission: ${value.authorizationStatus}');
      });
    }
        final RemoteMessage ?message = await FirebaseMessaging.instance.getInitialMessage();
        if (message != null) {
          debugPrint("onAppOpened: ${message.notification?.title}\t${message.notification?.body}\t${message.data}");
          Get.offAllNamed(RouteHelper.getMainScreenRoute());
          int ?notificationId = getChargerNotificationId(messageData: message.data['additional_info']);
          if(notificationId!=null){
            Get.toNamed(RouteHelper.getNotificationRoute(isFromNotificationClick: true, notificationClickId: notificationId));
          }
        }
        FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          debugPrint("onMessageOpenedApp: ${message.notification?.title}\t${message.notification?.body}\t${message.data}");
          int ?notificationId = getChargerNotificationId(messageData: message.data['additional_info']);
          if(notificationId!=null){
            Get.find<NotificationController>().updateCounter();
            Get.toNamed(RouteHelper.getNotificationRoute(isFromNotificationClick: true, notificationClickId: notificationId));
          }
        });
        FirebaseMessaging.onMessage.listen((message) {
          // debugPrint("onMessage: ${message.notification?.title}\t${message.notification?.body}\t${message.data}");
          debugPrint("message.data['additional_info']:-> ${message.data['additional_info']}");
          int ?notificationId = getChargerNotificationId(messageData: message.data['additional_info']);
          if(message.notification!=null&&message.notification!.title!=null&&notificationId!=null){
            Get.find<NotificationController>().updateCounter();
            showCustomToast(
              message.notification!.body!,
              onTap: (){
                Get.toNamed(RouteHelper.getNotificationRoute(isFromNotificationClick: true, notificationClickId: notificationId));
              }
            );
          }
        });
    updateFcmToken();

  }

  static int? getChargerNotificationId({required String messageData}){
    int ?notificationId;
    Map<String,dynamic> message = jsonDecode(messageData);
    notificationId = jsonDecode(message['notification']['additional_data'])['id'];
    return notificationId;
  }
  static updateFcmToken()async{

    if(Platform.isIOS){
      await FirebaseMessaging.instance.getAPNSToken().then((fcmToken) {
        debugPrint("device APNS TOKEN:-> $fcmToken");
      });
    }
    FirebaseMessaging.instance.getToken().then((fcmToken) {
        debugPrint("device FCM TOKEN:-> $fcmToken");
        if(fcmToken!=null){
          Get.find<AuthController>().updateFcmToken(fcmToken: fcmToken);
        }
    });
  }

  static notificationAction({required NotificationType notificationType, required RemoteMessage message}){
    
    switch(notificationType){
      case NotificationType.ChargingRequestRejected:
      // TODO: Handle this case.
        break;
      case NotificationType.ChargingRequest:
      // TODO: Handle this case.
        break;
      case NotificationType.ChargingRequestPaymentSuccess:
      // TODO: Handle this case.
        break;
      case NotificationType.ChargingRequestFree:
      // TODO: Handle this case.
        break;
    }
    }
}
Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint("onBackground: ${message.notification?.title}\t${message.notification?.body}\t${message.data}");
}

// class NotificationHelper {
//
//   static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
//     var androidInitialize = new AndroidInitializationSettings('notification_icon');
//     var iOSInitialize = new IOSInitializationSettings();
//     var initializationsSettings = new InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
//     flutterLocalNotificationsPlugin.initialize(initializationsSettings, onSelectNotification: (String payload) async {
//       try{
//         if(payload != null && payload.isNotEmpty) {
//           Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(payload)));
//         }else {
//           Get.toNamed(RouteHelper.getNotificationRoute());
//         }
//       }catch (e) {}
//       return;
//     });
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       print("onMessage: ${message.notification.title}/${message.notification.body}/${message.notification.titleLocKey}");
//       NotificationHelper.showNotification(message, flutterLocalNotificationsPlugin, false);
//       if(Get.find<AuthController>().isLoggedIn()) {
//         Get.find<OrderController>().getRunningOrders(1);
//         Get.find<OrderController>().getHistoryOrders(1);
//         Get.find<NotificationController>().getNotificationList(true);
//       }
//     });
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print("onOpenApp: ${message.notification.title}/${message.notification.body}/${message.notification.titleLocKey}");
//       try{
//         if(message.notification.titleLocKey != null && message.notification.titleLocKey.isNotEmpty) {
//           Get.toNamed(RouteHelper.getOrderDetailsRoute(int.parse(message.notification.titleLocKey)));
//         }else {
//           Get.toNamed(RouteHelper.getNotificationRoute());
//         }
//       }catch (e) {}
//     });
//   }
//
//   static Future<void> showNotification(RemoteMessage message, FlutterLocalNotificationsPlugin fln, bool data) async {
//     if(!GetPlatform.isIOS) {
//       String _title;
//       String _body;
//       String _orderID;
//       String _image;
//       if(data) {
//         _title = message.data['title'];
//         _body = message.data['body'];
//         _orderID = message.data['order_id'];
//         _image = (message.data['image'] != null && message.data['image'].isNotEmpty)
//             ? message.data['image'].startsWith('http') ? message.data['image']
//             : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.data['image']}' : null;
//       }else {
//         _title = message.notification.title;
//         _body = message.notification.body;
//         _orderID = message.notification.titleLocKey;
//         if(GetPlatform.isAndroid) {
//           _image = (message.notification.android.imageUrl != null && message.notification.android.imageUrl.isNotEmpty)
//               ? message.notification.android.imageUrl.startsWith('http') ? message.notification.android.imageUrl
//               : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.notification.android.imageUrl}' : null;
//         }else if(GetPlatform.isIOS) {
//           _image = (message.notification.apple.imageUrl != null && message.notification.apple.imageUrl.isNotEmpty)
//               ? message.notification.apple.imageUrl.startsWith('http') ? message.notification.apple.imageUrl
//               : '${AppConstants.BASE_URL}/storage/app/public/notification/${message.notification.apple.imageUrl}' : null;
//         }
//       }
//
//       if(_image != null && _image.isNotEmpty) {
//         try{
//           await showBigPictureNotificationHiddenLargeIcon(_title, _body, _orderID, _image, fln);
//         }catch(e) {
//           await showBigTextNotification(_title, _body, _orderID, fln);
//         }
//       }else {
//         await showBigTextNotification(_title, _body, _orderID, fln);
//       }
//     }
//   }
//
//   static Future<void> showTextNotification(String title, String body, String orderID, FlutterLocalNotificationsPlugin fln) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'LofuFood', 'LofuFood', playSound: true,
//       importance: Importance.max, priority: Priority.max, sound: RawResourceAndroidNotificationSound('notification'),
//     );
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
//   }
//
//   static Future<void> showBigTextNotification(String title, String body, String orderID, FlutterLocalNotificationsPlugin fln) async {
//     BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
//       body, htmlFormatBigText: true,
//       contentTitle: title, htmlFormatContentTitle: true,
//     );
//     AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'LofuFood', 'LofuFood', importance: Importance.max,
//       styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: true,
//       sound: RawResourceAndroidNotificationSound('notification'),
//     );
//     NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
//   }
//
//   static Future<void> showBigPictureNotificationHiddenLargeIcon(String title, String body, String orderID, String image, FlutterLocalNotificationsPlugin fln) async {
//     final String largeIconPath = await _downloadAndSaveFile(image, 'largeIcon');
//     final String bigPicturePath = await _downloadAndSaveFile(image, 'bigPicture');
//     final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
//       FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
//       contentTitle: title, htmlFormatContentTitle: true,
//       summaryText: body, htmlFormatSummaryText: true,
//     );
//     final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'LofuFood', 'LofuFood',
//       largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.max, playSound: true,
//       styleInformation: bigPictureStyleInformation, importance: Importance.max,
//       sound: RawResourceAndroidNotificationSound('notification'),
//     );
//     final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
//     await fln.show(0, title, body, platformChannelSpecifics, payload: orderID);
//   }
//
//   static Future<String> _downloadAndSaveFile(String url, String fileName) async {
//     final Directory directory = await getApplicationDocumentsDirectory();
//     final String filePath = '${directory.path}/$fileName';
//     final http.Response response = await http.get(Uri.parse(url));
//     final File file = File(filePath);
//     await file.writeAsBytes(response.bodyBytes);
//     return filePath;
//   }
//
// }
//