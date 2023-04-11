import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workerapp/controller/bottom_bar_controller.dart';
import 'package:workerapp/data/model/response/shift_model.dart';
import 'package:workerapp/view/screens/clientDetail/client_detail.dart';
import 'package:workerapp/view/screens/shift/shift_details_screen.dart';
import 'package:workerapp/view/screens/shift/shift_note_completed_screen.dart';
import 'package:workerapp/view/screens/shift/shift_notes_screen.dart';
import '../../../controller/auth_controller.dart';
import '../../../utils/color_constants.dart';
import '../notification/notification_screen.dart';

class ShiftScreensIndexWise extends StatefulWidget {
  const ShiftScreensIndexWise({Key? key}) : super(key: key);

  @override
  State<ShiftScreensIndexWise> createState() => _ShiftScreensIndexWiseState();
}

class _ShiftScreensIndexWiseState extends State<ShiftScreensIndexWise> {
 int shiftScreensCurrentIndex=Get.find<BottomBarController>().shiftScreensCurrentIndex;
  List<Widget> shiftScreenPages =  [
    const ShiftDetailsScreen(),
     const ShiftNotesScreen( ),
    const ShiftNoteCompletedScreen(),
    const ClientDetails(),
  ];
  @override
  Widget build(BuildContext context) {
    print("Get.find<BottomBarController>().shiftModel...............${Get.find<BottomBarController>().shiftModel}");
    return SafeArea(
        child: Container(
          width:context.width,
          height: context.height,
          color: AppColor.scaffoldBackGroundColor,
          child: Column(
            children: [
              Expanded(
                child: GetBuilder<BottomBarController>(builder: (bottomBarController) {
                  return shiftScreenPages[bottomBarController.shiftScreensCurrentIndex];
                }),
              ),
            ],
          ),
        ));
  }
}
