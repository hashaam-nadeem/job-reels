import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workerapp/controller/bottom_bar_controller.dart';
import 'package:workerapp/utils/app_images.dart';
import 'package:workerapp/utils/color_constants.dart';
import 'package:workerapp/view/screens/clientDetail/client_detail.dart';
import 'package:workerapp/view/screens/incidents/incident_reports_screen.dart';
import 'package:workerapp/view/screens/main/widgets/bottom_nav_widget.dart';
import 'package:workerapp/view/screens/myShifts/my_shifts_screen.dart';
import 'package:workerapp/view/screens/notification/notification_screen.dart';
import '../../../controller/auth_controller.dart';
import '../../../utils/app_strings.dart';
import '../profile/my_account.dart';
import '../shift/shift_screens_index_wise.dart';

class MainScreen extends StatefulWidget {

  const MainScreen({Key? key,}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   currentIndex= widget.currentIndexs!;
  //     setState((){});
  // }

   int currentIndex=Get.find<BottomBarController>().tabIndex ;
  List<Widget> mainScreenPages = const [
    MyShiftsScreen(),
    SizedBox(),
    IncidentReportsScreen(),
    ShiftScreensIndexWise(),
    MyAccountScreen(),
    NotificationScreen(),
  ];


  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomBarController>(builder: (bottomBarController){
      return Scaffold(
        backgroundColor: AppColor.scaffoldBackGroundColor,
        body: SafeArea(
            child: Container(
              width:context.width,
              height: context.height,
              color: AppColor.scaffoldBackGroundColor,
              child: Column(
                children: [
                  Expanded(
                    child:  mainScreenPages[bottomBarController.tabIndex],
                  ),
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.primaryColor.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: InkWell(
                                onTap: (){
                                  bottomBarController.changeMainScreenBottomNavIndex(0);
                                  // setState((){
                                  //   currentIndex = 0;
                                  // });
                                },
                                child: BottomNavItemWidget(title: AppString.myShifts, assetImagePath: Images.myShift,isSelected: (bottomBarController.tabIndex==0)&&(bottomBarController.isShowSelected)))),
                         Expanded(
                            child: InkWell(
                                onTap: (){
                                  bottomBarController.changeMainScreenBottomNavIndex(1);
                                  // setState((){
                                  //   currentIndex = 1;
                                  // });
                                },
                                child: BottomNavItemWidget(title: AppString.policy, assetImagePath: Images.policy,isSelected: (bottomBarController.tabIndex==1)&&(bottomBarController.isShowSelected)))),
                        Expanded(
                            child: InkWell(
                                onTap: (){
                                  bottomBarController.changeMainScreenBottomNavIndex(2);

                                  // setState((){
                                  //   currentIndex = 2;
                                  // });
                                },
                                child: BottomNavItemWidget(title: AppString.incidents, assetImagePath: Images.incidents,isSelected: (bottomBarController.tabIndex==2)&&(bottomBarController.isShowSelected)))),
                        Expanded(
                            child: InkWell(
                                onTap: (){
                                  bottomBarController.changeMainScreenBottomNavIndex(3);
                                  bottomBarController.changeTabIndex(0);
                                  // setState((){
                                  //   currentIndex = 3;
                                  // });
                                },
                                child: BottomNavItemWidget(title: AppString.schedule, assetImagePath: Images.schedule,isSelected: (bottomBarController.tabIndex==3)&&(bottomBarController.isShowSelected)))),
                        Expanded(
                            child: InkWell(
                                onTap: (){
                                  bottomBarController.changeMainScreenBottomNavIndex(4);
                                  // setState((){
                                  //   currentIndex = 4;
                                  // });
                                },
                                child: BottomNavItemWidget(title: AppString.myAccount, assetImagePath: Images.myAccount,isSelected: (bottomBarController.tabIndex==4)&&(bottomBarController.isShowSelected)))),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );
    });

  }

}