import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workerapp/Utils/app_constants.dart';
import 'helper/route_helper.dart';
import 'helper/get_di.dart' as di;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConstant.AppName,
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key,
      // theme: ,
      initialRoute: RouteHelper.getLogInRoute(),
      getPages: RouteHelper.routes,
      defaultTransition: Transition.zoom,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}