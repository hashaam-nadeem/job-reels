import 'package:get/get.dart';
import 'package:jobreels/controller/auth_controller.dart';

import 'chat_model.dart';

class ChatThread {
  final int id;
  final int userId;
  final String userName;
  var unreadCount = 0;
  final String userProfileUrl;
  ChatMessage? lastMessage;
  ChatThread({
    required this.id,
    required this.unreadCount,
    required this.userId,
    required this.userName,
    required this.userProfileUrl,
    this.lastMessage,
  });

  factory ChatThread.formJson(Map<String, dynamic> json) {
    print("my message is: ${json['message']}");
    Map<String, dynamic> userJson = json['from_user_id'] ==
            Get.find<AuthController>().getLoginUserData()?.id
        ? json['to_user']
        : json['from_user'];
    return ChatThread(
      id: json['id'],
      unreadCount: json['undreadCount'] ?? 1,
      userId: userJson['id'],
      userName: userJson['first_name'] +
          (userJson['id'] == 165 ? "" : " ${userJson['last_name']}"),
      userProfileUrl: userJson['profile_picture_url'],
      lastMessage: json['message'].runtimeType != (List<dynamic>) &&
              json['message'] != null &&
              json['message'].toString() != "null"
          ? ChatMessage.formJson(json['message'])
          : null,
    );
  }
}
