import 'package:get/get.dart';
import '../data/api/Api_Handler/api_error_response.dart';
import '../data/model/response/userInfo_model.dart';
import '../data/repositry/auth_repo.dart';
import '../helper/route_helper.dart';
import 'bottom_bar_controller.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({required this.authRepo}) {
    // _notification = authRepo.isNotificationActive();
  }
  final bool _isLoading = false;
  final bool _notification = true;
  final bool _acceptTerms = true;
  //UserInfoModel user;
  bool get isLoading => _isLoading;
  bool get notification => _notification;
  bool get acceptTerms => _acceptTerms;

  UserInfoModel? _userInfoModel;
  UserInfoModel? get userInfoModel=>_userInfoModel;

  UserInfoModel ?getLoginUserData(){
    return authRepo.getLoginUserData();
  }


  void updateLoginUserData({required UserInfoModel user}){
    authRepo.saveLoginUserData(user: user);
  }

  bool isLoginUser({required String email}){
    return getLoginUserData()?.email==email;
  }
  String ?getFcmToken(){
    return authRepo.getFcmToken();
  }
  bool clearSharedData() {
    authRepo.clearSharedData();
    return true;
  }

  Future<Map<String,dynamic>> login(String email, String password) async {
    Map<String,dynamic> response = await authRepo.login(email: email, password: password,);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      Map<String,dynamic>result =  response[API_RESPONSE.SUCCESS];
      UserInfoModel user = UserInfoModel.fromJson(result['data']);
      authRepo.saveLoginUserData(user: user);
      authRepo.saveUserMailAndPassword(email,password);
      if(result['data']['name']!=null){
        Get.offNamed(RouteHelper.getMainScreenRoute());
      }else{
        Get.offNamed(RouteHelper.getUpdateProfile());
      }

    }
    return response;
  }

  Future<Map<String,dynamic>> updateProfile(String name, String phone, String address,String? password) async {
    Map<String,dynamic> response = await authRepo.updateProfile(name: name, phone: phone,address:address,password:password);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      Map<String,dynamic>result =  response[API_RESPONSE.SUCCESS];
      _userInfoModel = UserInfoModel.fromJson(result['data']);
      if(password != ''){
        Get.offNamed(RouteHelper.getMainScreenRoute());
        Get.find<BottomBarController>().changeMainScreenBottomNavIndex(4,isShowsSelected: true);
      }else{
        Get.offNamed(RouteHelper.getMainScreenRoute());
      }
    }
    update();
    return response;
  }

  Future<Map<String,dynamic>> logout() async {
    Map<String,dynamic> response = await authRepo.logout();
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      authRepo.clearSharedData();
      Get.offAllNamed(RouteHelper.getLogInRoute());
    }
    return response;
  }

  Future<void> fetchProfile() async {
    Map<String,dynamic> response = await authRepo.fetchProfile();
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      Map<String,dynamic>result =  response[API_RESPONSE.SUCCESS];
      _userInfoModel = UserInfoModel.fromJson(result['data']);
    }
    update();
  }
}