import 'package:get/get.dart';
import '../data/api/Api_Handler/api_error_response.dart';
import '../data/repository/stripe_repo.dart';
import '../view/base/custom_snackbar.dart';
import '../view/base/loading_widget.dart';
import 'notification_chat_controller.dart';

class StripeController extends GetxController implements GetxService {
  final StripeRepo stripeRepo;
  StripeController({required this.stripeRepo});

  Future<Map<String,dynamic>> paymentCharger(String expiryYear, String expiryMonth, int cvvNo, int cardNo, int requestId, String amount,int notificationsId ) async {
    ApiLoader.show();
    Map<String,dynamic> stripeEdgeResponse = await fetchStripeToken(expiryMonth: expiryMonth, cvvNo: cvvNo, cardNo: cardNo, expiryYear: expiryYear);
    Map<String,dynamic>? response;
    if(stripeEdgeResponse.containsKey(API_RESPONSE.SUCCESS)){
      Map<String,dynamic>result = stripeEdgeResponse[API_RESPONSE.SUCCESS];
      String paymentToken = result['id'];
      response = await stripeRepo.paymentCharger(requestId: requestId, paymentToken: paymentToken, amount: amount, );
      if(response.containsKey(API_RESPONSE.SUCCESS)){
        Get.find<ChatNotificationController>().notificationPaymentStatus(id:notificationsId, zeroOne: 1 );
        showCustomSnackBar(
          "Amount paid",
          isError: false,
        );
         Get.back();
      }
    }
    ApiLoader.hide();
    return response ?? stripeEdgeResponse;
  }

  Future<Map<String,dynamic>> fetchStripeToken({required int cvvNo, required int cardNo,required String expiryYear, required String expiryMonth}) async {
    Map<String,dynamic> response = await stripeRepo.fetchStripeToken(cvvNo: cvvNo, cardNo: cardNo, expiryYear: expiryYear, expiryMonth: expiryMonth);
    update();
    return response;
  }
}