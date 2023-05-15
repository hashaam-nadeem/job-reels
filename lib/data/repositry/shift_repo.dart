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

  Future<Map<String, dynamic>> clockIn({required String code,required String lat,required String lng}) async {
    Map<String,dynamic> body={
      "code": code,
      "lat_in":lat,
      "long_in":lng,
    };
    print("body.........>$body");
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstant.CLOCK_IN,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
      body: ApiClient.FormData.fromMap({
        "code": code,
        "lat_in":lat,
        "long_in":lng,
      }),
    );
    return await apiObject.requestAPI(isShowLoading: true,  isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> clockOut({required String code,}) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstant.CLOCK_OUT,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
      body: ApiClient.FormData.fromMap({
        "code": code,
      }),
    );
    return await apiObject.requestAPI(isShowLoading: true,  isCheckAuthorization: true);
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

  Future<Map<String, dynamic>> addAvailability({required int availability,required String startDate,required String endDate}) async {
    Map<String, dynamic> body = {
      "start_date":startDate,
      "end_date":endDate,
      "availability":availability,
    };
    print("body:-> $body");
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstant.AVAILABILITY,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
      body: ApiClient.FormData.fromMap(body),
    );
    return await apiObject.requestAPI(isShowLoading: true,  isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> fetchAvailability({required int page}) async {
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstant.FETCH_AVAILABILITY}?page=$page",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
      body: ApiClient.FormData.fromMap({
        "page":page,
      }),
    );
    return await apiObject.requestAPI(isShowLoading: false,  isCheckAuthorization: true);
  }

}