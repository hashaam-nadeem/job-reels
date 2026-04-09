import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/controller/theme_controller.dart';
import 'package:jobreels/util/dimensions.dart';
import 'package:jobreels/util/styles.dart';

void showCustomToast(String message, {void Function()? onTap, bool isErrorToast = false}) {
  if(message.isNotEmpty) {
    BotToast.showSimpleNotification(
      title: message,
      subTitle: null,
      onTap: (){
        if(onTap!=null){
          onTap();
          BotToast.cleanAll();
        }
      },
      enableSlideOff: true,
      hideCloseButton: true,
      dismissDirections: const [DismissDirection.up],
      borderRadius: Dimensions.RADIUS_SMALL,
      align: Alignment.topCenter,
      backgroundColor: isErrorToast && Get.context!=null ? Theme.of(Get.context!).errorColor : Get.find<ThemeController>().isDarkMode ? const Color(0xFF3C3F41) : const Color(0xFFF5F5F5),
      titleStyle: montserratMedium.copyWith(color: isErrorToast && Get.context!=null ? Theme.of(Get.context!).primaryColorLight: Get.find<ThemeController>().isDarkMode ? Colors.white: Colors.black),
      subTitleStyle: montserratRegular.copyWith(color: Colors.white),
      onlyOne: true,
      crossPage: true,
      animationDuration: const Duration(milliseconds: 200),
      animationReverseDuration: const Duration(milliseconds: 200),
      duration: const Duration(seconds: 3),
    );


    // ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
    //   dismissDirection: DismissDirection.horizontal,
    //   margin: EdgeInsets.only(
    //     right: ResponsiveHelper.isDesktop(Get.context) ? Get.context!.width*0.7 : Dimensions.PADDING_SIZE_SMALL,
    //     top: Dimensions.PADDING_SIZE_SMALL, bottom: Dimensions.PADDING_SIZE_SMALL, left: Dimensions.PADDING_SIZE_SMALL,
    //   ),
    //   duration: const Duration(seconds: 3),
    //   backgroundColor: isError ? Colors.red : Colors.green,
    //   behavior: SnackBarBehavior.floating,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
    //   content: Text(message, style: ralewayMedium.copyWith(color: Colors.white)),
    // ));
  }
}