import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glow_solar/controller/theme_controller.dart';
import 'package:glow_solar/util/dimensions.dart';
import 'package:glow_solar/util/styles.dart';

void showCustomToast(String message, {void Function()? onTap}) {
  if(message.isNotEmpty) {
    BotToast.showSimpleNotification(
      title: message,
      subTitle: null,
      onTap: onTap,
      enableSlideOff: true,
      hideCloseButton: true,
      dismissDirections: const [DismissDirection.up],
      borderRadius: Dimensions.RADIUS_SMALL,
      align: Alignment.topCenter,
      backgroundColor: Get.find<ThemeController>().isDarkMode ? const Color(0xFF3C3F41) : const Color(0xFFF5F5F5),
      titleStyle: montserratMedium.copyWith(color: Get.find<ThemeController>().isDarkMode ? Colors.white: Colors.black),
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