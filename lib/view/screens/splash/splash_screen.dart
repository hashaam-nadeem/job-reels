import 'dart:async';
import 'package:glow_solar/controller/auth_controller.dart';
import 'package:glow_solar/data/model/response/userinfo_model.dart';
import 'package:glow_solar/data/repository/auth_repo.dart';
import 'package:glow_solar/enums/otp_verify_type.dart';
import 'package:glow_solar/util/app_strings.dart';
import 'package:glow_solar/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../controller/splash_controller.dart';
import '../../../helper/route_helper.dart';
import '../../base/no_internet_screen.dart';


class SplashScreen extends StatefulWidget {
  final String ?orderID;
  const SplashScreen({Key? key, this.orderID}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;
   AuthRepo? authRepo;

  @override
  void initState() {
    super.initState();
    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? const SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 1),
          content: Text(
            isNotConnected ? AppString.noConnection .tr : AppString.connected.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });
    // Get.find<CartController>().getCartData();
    _route();
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  void _route() async {
    UserInfoModel ?user = Get.find<AuthController>().getLoginUserData();
    if(user!= null){
      await Future.delayed(const Duration(seconds: 1));
      if(user.isVerified){
        Get.offNamed(RouteHelper.getMainScreenRoute());
      }else{
        Get.offNamed(RouteHelper.getSignInRoute());
        Get.toNamed(RouteHelper.getOtpVerificationRoute(verificationType: OtpVerifyType.RegisterVerify));
      }
    }else{
      await Future.delayed(const Duration(seconds: 1)).then((value){
        Get.offNamed(RouteHelper.getSignInRoute());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get.find<SplashController>().initSharedData();
    return Scaffold(
      key: _globalKey,
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Center(
          child: splashController.hasConnection ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(Images.logo, width: 200),
              /*SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
              Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: 25)),*/
            ],
          ) : NoInternetScreen(child: SplashScreen(orderID: widget.orderID)),
        );
      }),
    );
  }
}
