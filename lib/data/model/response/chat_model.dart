import 'package:get/get.dart';

import '../../../controller/auth_controller.dart';

class ChatMessage {
  final String message;
  final int threadId;
  var isRead = 0;
  final DateTime dateTime;
  var unreadCount = 0;
  final bool isMyMessage;

  ChatMessage(
      {required this.message,
      required this.isRead,
      required this.dateTime,
      required this.isMyMessage,
      required this.threadId});

  factory ChatMessage.formJson(Map<String, dynamic> json) {
    bool myMessage = json['from_user_id'] ==
        Get.find<AuthController>().getLoginUserData()?.id;
    return ChatMessage(
      message: json['message'],
      threadId: json['thread_id'],
      isRead: json['is_read'] ?? 1,
      dateTime: DateTime.parse(json['created_at'] + 'z').toLocal(),
      isMyMessage: myMessage,
    );
  }
}
