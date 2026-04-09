import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/controller/notification_chat_controller.dart';
import 'package:jobreels/data/model/response/chat_model.dart';
import 'package:jobreels/data/model/response/user.dart';
import 'package:jobreels/helper/helper.dart';
import 'package:jobreels/util/app_constants.dart';
import 'package:jobreels/view/screens/chat/chat_screen.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../view/base/custom_toast.dart';

class SendMessageFormat {
  final String message;
  final String type;
  final int toUserId;
  final int threadId;
  final String messageNumber;

  SendMessageFormat({
    required this.type,
    required this.message,
    required this.threadId,
    required this.toUserId,
    required this.messageNumber,
  });
}

class Sockets {
  late Socket socket;
  Sockets() {
    socket = io(AppConstants.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
  }

  Future<bool> sendMessageToUser(
      {required SendMessageFormat msg,
      required Function onEmitAck,
      BuildContext? buildContext}) async {
    User? user = Get.find<AuthController>().getLoginUserData();
    if (socket.connected && user?.id != msg.toUserId) {
      DateFormat format = DateFormat("yyyy-MM-dd HH:mm");
      DateTime messageSendingTime = format.parse(DateTime.now().toString());
      User loginUser = user!;
      Map data = {
        "type": "message",
        "userId": msg.toUserId,
        "data": {
          "message": msg.message,
          "type": msg.type,
          "from_user_id": loginUser.id,
          "from_user_role_id": '2',
          "from_user_name": getUserName(user: loginUser),
          "profile_image": loginUser.profilePicture,
          "thread_id": msg.threadId,
          "date": DateFormat.yMd().add_jm().format(
              messageSendingTime), //gahhakDateTimeFormatter(dateToBeFormatted:messageSendingTime),
          "message_number": msg.messageNumber,
        },
      };
      String event = "sendMessage";
      debugPrint("Sending Message--->>>$data");
      socket.emitWithAck(event, [data], ack: (ack) {
        debugPrint("MessageSent callback---->>>$ack");
        if (ack != null) {
          onEmitAck(ack);
        }
      });
    } else {
      return false;
    }
    return true;
  }

  // markMessageReadThroughSocket(String threadId){
  //   Map data = {
  //     "userId": User_In_UserModel.userData.userResult?.userInfo.id,
  //     "data":{
  //       "thread_id": threadId,
  //     },
  //   };
  //   String event = "markMessageRead";
  //   socket.emit(event,[data],);
  // }

  /// provide threadId && context  to fetch a thread's messages
  void socketsConfiguration() {
    debugPrint("socketsConfiguration is called");
    User? user = Get.find<AuthController>().getLoginUserData();
    if (user != null && socket.disconnected) {
      socket.on('message', messageListener);
      socket.connect();
      socket.onError((data) {});
      socket.onDisconnect((data) => socket.clearListeners());
      socket.onConnectError((data) {
        debugPrint("Exception on SocketConnection: $data");
      });
      socket.onConnect((data) {
        debugPrint("Socket Connected with onConnect");
        socket.emit(
          "addUser",
          [
            {
              "userId": "${user.id}",
            }
          ],
        );
      });
    }
  }

  void messageListener(dynamic data) {
    ChatNotificationController chatController =
        Get.find<ChatNotificationController>();
    Map<String, dynamic> jsonData = data['data'];
    ChatMessage message = ChatMessage(
      isRead: 0,
      message: jsonData['message'],
      dateTime: DateTime.now(),
      isMyMessage: false,
      threadId: jsonData['thread_id'],
    );
    if (chatController.currentOpenedThread?.id != message.threadId) {
      Get.find<ChatNotificationController>().updateMsgCounter();
      showCustomToast(
        "${jsonData['from_user_name']} sent you a message",
        onTap: () {
          if (chatController.currentOpenedThread != null) {
            Get.back();
          }
          Get.to(() => ChatScreen(
              userId: int.parse("${jsonData['from_user_id']}"),
              threadId: message.threadId,
              userName: jsonData['from_user_name']));
        },
      );
    }
    chatController.appendMessageAtEnd(message);
  }

  void disconnect() {
    if (socket.connected) {
      socket.disconnect();
    }
  }
}
