import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workerapp/view/screens/shift/widgets/profile_widget_portion.dart';
import '../../../controller/auth_controller.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/color_constants.dart';
import '../../../utils/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
class ShiftNoteCompletedScreen extends StatefulWidget {
  const ShiftNoteCompletedScreen({Key? key}) : super(key: key);

  @override
  State<ShiftNoteCompletedScreen> createState() => _ShiftNoteCompletedScreenState();
}

class _ShiftNoteCompletedScreenState extends State<ShiftNoteCompletedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackGroundColor,
      appBar: CustomAppBar(
        title: AppString.shiftNotes,
        leading: IconButton(
          onPressed: (){},
          iconSize: 20,
          icon: const Icon(Icons.menu,color: Colors.white,),
        ),
        trailing: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.more_vert,color: Colors.white,),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width:context.width,
          height: context.height,
          color: AppColor.scaffoldBackGroundColor,
          child: GetBuilder<AuthController>(builder: (authController) {
            return ListView(
                physics: const BouncingScrollPhysics(),
                children:  [
                  Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 80,),
                      Center(child: Image.asset(Images.circularThinTick,width: 95, height: 95,),),
                      const SizedBox(height: 20,),
                      Text(
                        "Thank you",
                        style: montserratRegular.copyWith(
                          // color: const Color(0xFF160042),
                          fontSize: 22,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 40,),
                      Text(
                        "Following Shift Successfully Completed.",
                        style: montserratRegular.copyWith(
                          // color: const Color(0xFF160042),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 70,),
                      const ProfileWidgetPortion( isShiftNote: true, currentIndex:0,isMyProfile: true, isAddressRequired: false,),
                      const SizedBox(height: 90,),
                      CustomButton(
                        onPressed:(){},
                        // timeComplete
                        //     ?(){Get.toNamed(RouteHelper.getShiftNotes());}
                        //     :(){},
                        icon: Image.asset(Images.forwardIcon,width: 30, height: 25,),
                        iconAtStart: false,
                        width: 220,
                        color: const Color(0xff65DACC),
                        buttonText: 'Add Incident Report',
                        radius: 25,
                      ),
                    ],
                  )
                ]);
          }),
        )
      ),
    );
  }
}
