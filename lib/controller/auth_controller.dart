
import 'package:get/get.dart';

class AuthController extends GetxController implements GetxService {
  // final AuthRepo authRepo;
  // AuthController({required this.authRepo}) {
  // }

  bool _isLoading = false;
  bool _notification = true;
  bool _acceptTerms = true;

  bool get isLoading => _isLoading;
  bool get notification => _notification;
  bool get acceptTerms => _acceptTerms;
}