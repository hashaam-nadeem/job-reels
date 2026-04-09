import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/data/model/response/chat_model.dart';
import 'package:jobreels/data/model/response/notification_model.dart';
import 'package:jobreels/view/base/custom_toast.dart';
import '../data/api/Api_Handler/api_error_response.dart';
import '../data/model/response/chat_thread_model.dart';
import '../data/model/response/user.dart';
import '../data/repository/notification_repo.dart';
import '../helper/helper.dart';
import '../view/screens/chat/chat_screen.dart';

class ChatNotificationController extends GetxController implements GetxService {
  final NotificationRepo notificationRepo;
  ChatNotificationController({required this.notificationRepo});
  ScrollController? scrollController;
  final List<NotificationModel> _notificationList = [];
  final List<ChatThread> chatThreadList = [];
  ChatThread? currentOpenedThread;
  final List<ChatMessage> chatMessageList = [];
  List<NotificationModel> get notificationList => _notificationList;
  bool _isFetchingData = true;
  bool _isThreadFetchingData = true;
  bool _isThreadMessageFetchingData = true;
  bool get isThreadFetchingData => _isThreadFetchingData;
  bool get isThreadMessageFetchingData => _isThreadMessageFetchingData;
  bool get isDataFetching => _isFetchingData;
  int notificationCount = 0;
  int messageCount = 0;

  void setNotiMessageCounter(
      {int? notiCounter, int? msgCounter, bool isInit = false}) {
    notificationCount = notiCounter ?? notificationCount;
    messageCount = msgCounter ?? messageCount;
    if (!isInit) {
      update();
    }
    // update();
  }

  void clearMessagesListOnShatScreenDispose() {
    chatMessageList.clear();
  }

  void clearData() {
    _notificationList.clear();
  }

  void appendMessageAtEnd(ChatMessage message) {
    if (currentOpenedThread?.id == message.threadId) {
      chatMessageList.add(message);
      scrollController?.animateTo(0,
          duration: const Duration(milliseconds: 200), curve: Curves.linear);
    }
    for (ChatThread thread in chatThreadList) {
      if (thread.id == message.threadId) {
        thread.lastMessage = message;
        break;
      }
    }
    update();
  }

  void updateLastMessage({required ChatMessage chatMessage}) {
    for (ChatThread thread in chatThreadList) {
      if (thread.id == chatMessage.threadId) {
        thread.lastMessage = chatMessage;
        update();
        break;
      }
    }
  }

  void updateNotiCounter() {
    notificationCount++;
    update();
  }

  void updateMsgCounter() {
    messageCount++;
    update();
  }

  Future<void> fetchNotification() async {
    _isFetchingData = true;
    print("fetch notificaiton called: ");
    Map<String, dynamic> response = await notificationRepo.fetchNotification();
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      _notificationList.clear();
      List<dynamic> listNotification = response[API_RESPONSE.SUCCESS]['data'];
      for (var data in listNotification) {
        _notificationList.add(NotificationModel.fromLocalJson(data));
      }
      // notificationCount = 0;
    }
    _isFetchingData = false;
    update();
  }

  Future<void> fetchThreadList() async {
    _isThreadFetchingData = true;
    try {
      update();
    } catch (e) {}
    Map<String, dynamic> response = await notificationRepo.fetchThreadList();
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      chatThreadList.clear();
      debugPrint(
          "response[API_RESPONSE.SUCCESS]:->>> ${response[API_RESPONSE.SUCCESS]}");
      List<dynamic> listThread =
          response[API_RESPONSE.SUCCESS]['result']['threads'];
      // print(
      //     "my threads: ${response[API_RESPONSE.SUCCESS]['result']['threads'][0]}");
      for (var data in listThread) {
        chatThreadList.add(ChatThread.formJson(data));
      }
    }
    _isThreadFetchingData = false;
    update();
  }

  Future<void> fetchThreadMessages(int threadId) async {
    _isThreadMessageFetchingData = true;
    User? user = Get.find<AuthController>().getLoginUserData();
    // if(user?.isSubscribed??false){
    Map<String, dynamic> response =
        await notificationRepo.fetchThreadMessages(threadId);
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      chatMessageList.clear();
      List<dynamic> listMessage =
          response[API_RESPONSE.SUCCESS]['result']['messages'];
      for (var data in listMessage) {
        chatMessageList.add(ChatMessage.formJson(data));
      }
    }
    // }
    // else if(user==null){
    //   await  Future.delayed(const Duration(milliseconds: 100)).then((value){
    //     showLoginMessagePopup();
    //   });
    // }
    _isThreadMessageFetchingData = false;
    update();
  }

  Future<ChatThread?> fetchThreadAndGoToChatScreen(int userId) async {
    Map<String, dynamic> response =
        await notificationRepo.fetchThreadId(userId);
    debugPrint("response:->>>> $response");
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      Map<String, dynamic> jsonResult =
          response[API_RESPONSE.SUCCESS]['result'];
      ChatThread thread = ChatThread.formJson(jsonResult);
      chatMessageList.clear();
      List<dynamic> listMessage = jsonResult['message'];
      for (var data in listMessage) {
        chatMessageList.add(ChatMessage.formJson(data));
      }
      _isThreadMessageFetchingData = false;
      print("my thread is: ${thread.userId}");
      Get.to(() => ChatScreen(
          userId: thread.userId,
          userName: thread.userName,
          threadId: thread.id,
          isCallApiOnInitState: false));
      return thread;
    } else {
      return null;
    }
  }

  NotificationModel? getNotificationWithId({required int id}) {
    return _notificationList.isNotEmpty
        ? _notificationList.firstWhere((notification) => notification.id == id)
        : null;
  }

  // NotificationModel? getNotificationReadStatus({required bool status,required int id}){
  //   NotificationModel ?notifications;
  //   for(NotificationModel notificationObj in _notificationList){
  //     if(notificationObj.id==id){
  //       notificationObj.isRead = status ;
  //       notifications = notificationObj;
  //       update();
  //       break;
  //     }
  //   }
  //   return notifications;
  // }

  Future<Map<String, dynamic>> deleteSolar({required int id}) async {
    Map<String, dynamic> response = await notificationRepo.deleteSolar(id: id);
    if (response.containsKey(API_RESPONSE.SUCCESS)) {
      _notificationList.removeWhere((element) => element.id == id);
      update();
    }
    return response;
  }
  // void removeNotification({required int id}){
  //   for(Notifications notificationObj in _notificationList){
  //     if(notificationObj.id==id){
  //       _notificationList.removeWhere((item) => item.id == id);
  //       update();
  //       break;
  //     }
  //   }
  // }

  NotificationModel? notificationPaymentStatus(
      {required int zeroOne, required int id}) {
    NotificationModel? notifications;
    for (NotificationModel notificationObj in _notificationList) {
      if (notificationObj.id == id) {
        notifications = notificationObj;
        update();
        break;
      }
    }
    return notifications;
  }
}
