import '../../util/app_constants.dart';
import '../api/Api_Handler/api_call_Structure.dart';
import '../api/Api_Handler/api_constants.dart';

class NotificationRepo{


  Future<Map<String, dynamic>> fetchNotification() async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.FETCH_NOTIFICATION_LIST,
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> fetchNotificationCount() async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.FETCH_NOTIFICATION_COUNT,
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> deleteSolar({required int id}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstants.DELETE_NOTIFICATIONS}$id",
      apiRequestMethod: API_REQUEST_METHOD.DELETE,
      isWantSuccessMessage: true,
    );
    return await apiObject.requestAPI(isShowLoading: true,isCheckAuthorization: true);
  }

}