import 'dart:async';
import 'package:flutter/services.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/controller/post_controller.dart';
import 'package:jobreels/data/model/response/user.dart';
import 'package:jobreels/data/repository/auth_repo.dart';
import 'package:jobreels/enums/country.dart';
import 'package:jobreels/enums/report_type.dart';
import 'package:jobreels/helper/socket_helper.dart';
import 'package:jobreels/util/app_strings.dart';
import 'package:jobreels/util/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:jobreels/view/screens/main/adminMain.dart';
import '../../../controller/splash_controller.dart';
import '../../../controller/state_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../main.dart';
import '../../base/no_internet_screen.dart';

class SplashScreen extends StatefulWidget {
  final String? orderID;
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
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? const SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 1),
          content: Text(
            isNotConnected ? AppString.noConnection.tr : AppString.connected.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });
    _route();
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  void _route() async {
    User? user = Get.find<AuthController>().getLoginUserData();
    if (user != null) {
      Get.find<StateController>()
          .getStateList(user.isFreelancer ? Country.Philippines : Country.USA);
      Get.find<PostsController>().getReportFlags(Report.Post);
      Get.find<PostsController>().getReportFlags(Report.User);
      // if(user.isVerified){
      //   Get.find<PostsController>().getPosts();
      await Future.delayed(const Duration(seconds: 2)).then((value) {
        // if (user.type.toString() == "admin") {
        // Get.to(AdminMainScreen());
        // } else {
        Get.offAllNamed(RouteHelper.getMainScreenRoute());
        // }
      });
      // }else{
      //   Get.offAllNamed(RouteHelper.getSignInRoute());
      //   Get.toNamed(RouteHelper.getOtpVerificationRoute(verificationType: OtpVerifyType.RegisterVerify));
      // }
    } else {
      // Get.find<PostsController>().getPosts();
      await Future.delayed(const Duration(seconds: 2)).then((value) {
        Get.offAllNamed(RouteHelper.getMainScreenRoute());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get.find<SplashController>().initSharedData();
    return Scaffold(
      key: _globalKey,
      backgroundColor: const Color(0xFF5D17EB),
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Center(
          child: splashController.hasConnection
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      Images.splashScreen,
                      width: context.width,
                      height: context.height,
                    ),
                  ],
                )
              : NoInternetScreen(child: SplashScreen(orderID: widget.orderID)),
        );
      }),
    );
  }
}
