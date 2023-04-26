import '../../Utils/app_constants.dart';
import '../api/Api_Handler/api_call_Structure.dart';
import '../api/Api_Handler/api_constants.dart';
import 'package:dio/dio.dart' as ApiClient;
class ClientRepo{

  Future<Map<String, dynamic>> fetchNotes({required int clientId,required int page}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstant.CLIENT_DETAILS}$clientId${AppConstant.FETCH_NOTES}",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
      body: ApiClient.FormData.fromMap({
        "page": page,
      }),
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> fetchDocument({required clientId,required page}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstant.CLIENT_DETAILS}$clientId${AppConstant.FETCH_DOCUMENT}",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
      body: ApiClient.FormData.fromMap({
        "page": page,
      }),
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> fetchClientDetail({required int clientId}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstant.CLIENT_DETAILS}$clientId",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: true);
  }
}