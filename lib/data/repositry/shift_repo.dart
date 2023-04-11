import '../../Utils/app_constants.dart';
import '../api/Api_Handler/api_call_Structure.dart';
import '../api/Api_Handler/api_constants.dart';
import 'package:dio/dio.dart' as ApiClient;
class ShiftRepo{

  Future<Map<String, dynamic>> fetchShiftsByDate({required String date}) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstant.FETCH_SHIFT_BY_DATE}$date",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,  isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> fetchShifts() async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstant.FETCH_SHIFT,
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,  isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> fetchShiftDetails({required String code}) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstant.FETCH_SHIFT_DETAIL}$code",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,  isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> downloadImage({required int id}) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstant.DOWNLOAD_IMAGES}$id",
      apiRequestMethod: API_REQUEST_METHOD.DOWNLOAD,
      isWantSuccessMessage: false,
    );
    return await apiObject.downloadApiRequest(isShowLoading: false,  isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> updateStatus({required String code,required String status}) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstant.UPDATE_STATUS,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
      body: ApiClient.FormData.fromMap({
        "code": code,
        "status": status,
      }),
    );
    return await apiObject.requestAPI(isShowLoading: false,  isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> updateShiftStatus({required String code,required String status,required String odometerStart,required String odometerEnd,required int vehicleUse, required String path}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstant.UPDATE_STATUS,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
      body: ApiClient.FormData.fromMap({
        "code": code,
        "status": status,
        "travel":{
          "start":odometerStart,
          "end":odometerEnd,
          "used_own_vehicle":vehicleUse,
        },
        "client_signature":path,
      }),
    );
    return await apiObject.requestAPI(isShowLoading: false,  isCheckAuthorization: true);
  }

}