
import 'package:jobreels/util/app_constants.dart';
import 'package:dio/dio.dart' as ApiClient;
import '../api/Api_Handler/api_call_Structure.dart';
import '../api/Api_Handler/api_constants.dart';

class StripeRepo{

  Future<Map<String, dynamic>> paymentCharger({required String paymentToken,required int requestId,required String amount,}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.PAYMENT_CHARGER,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: true,
      body: ApiClient.FormData.fromMap({
        "stripe_token":paymentToken,
        "charging_request_id": requestId,
        "amount": amount,
        "description":"Charging Request Test Payment 2"
      }),
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: true);
  }

  Future<Map<String, dynamic>> fetchStripeToken({required int cardNo, required int cvvNo,required String expiryMonth,required String expiryYear}) async {

    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: AppConstants.STRIPE,
      apiRequestMethod: API_REQUEST_METHOD.POST,
      isWantSuccessMessage: false,
      body: {
        "card[number]":cardNo,
        "card[exp_month]":expiryMonth,
        "card[exp_year]":expiryYear,
        "card[cvc]":cvvNo,

      },
    );
    return await apiObject.requestStripeApi(isShowLoading: false,);
  }
}