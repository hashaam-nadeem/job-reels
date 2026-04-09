import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:jobreels/data/model/response/notification_model.dart';
import '../data/api/Api_Handler/api_error_response.dart';
import '../data/repository/notification_repo.dart';

class ChatNotificationController extends GetxController implements GetxService{
  final NotificationRepo notificationRepo;
  ChatNotificationController( {required this.notificationRepo});

  final List<NotificationModel> _notificationList = [];
  List<NotificationModel> get notificationList => _notificationList;
  bool _isFetchingData = true;
  bool get isDataFetching => _isFetchingData;
  int notificationCount=0;
  int messageCount=0;

  void clearData(){
    _notificationList.clear();
  }

  void updateCounter(){
    notificationCount++;
    update();
  }

  Future<void> fetchNotification() async {
    _isFetchingData = true;
    update();
    Map<String,dynamic> response = await notificationRepo.fetchNotification();
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      _notificationList.clear();
      List<dynamic> listNotification = response[API_RESPONSE.SUCCESS]['data'];
      for(var data in listNotification){
        _notificationList.insert(0, NotificationModel.fromLocalJson(data));
      }
      notificationCount=0;
    }
    _isFetchingData = false;
    update();
  }

  Future<void> fetchNotificationCount() async {
    Map<String,dynamic> response = await notificationRepo.fetchNotificationCount();
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      notificationCount = response[API_RESPONSE.SUCCESS]['result'];
      update();
    }
  }

  NotificationModel? getNotificationWithId({required int id}){
    return _notificationList.isNotEmpty?_notificationList.firstWhere((notification) => notification.id==id):null;
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


  Future<Map<String,dynamic>> deleteSolar({required int id}) async {
    Map<String,dynamic> response = await notificationRepo.deleteSolar(id:id);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      _notificationList.removeWhere((element) => element.id==id);
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

  NotificationModel? notificationPaymentStatus({required int zeroOne,required int id}){
    NotificationModel ?notifications;
    for(NotificationModel notificationObj in _notificationList){
      if(notificationObj.id==id){
        notifications = notificationObj;
        update();
        break;
      }
    }
    return notifications;
  }

}