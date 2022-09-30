import 'package:get/get.dart';

class SplashController extends GetxController implements GetxService {
  // final SplashController splashRepo;
  // SplashController({required this.splashRepo});
  // ConfigModel _configModel;
  bool _hasConnection = true;

  bool get hasConnection => _hasConnection;
}