import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/helper/helper.dart';
import 'package:jobreels/util/dimensions.dart';
import 'package:jobreels/view/base/popup_alert.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controller/auth_controller.dart';
import '../../data/model/helpers.dart';
import '../../helper/route_helper.dart';
import '../../util/styles.dart';
import 'custom_linkable.dart';

class LinkifyWidgetIconWidgetInRow extends StatelessWidget {
  final IconData? icon;
  final Widget? leadingIcon;
  final String description;
  final int userId;
  const LinkifyWidgetIconWidgetInRow(
      {Key? key,
      this.icon,
      this.leadingIcon,
      required this.description,
      required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(builder: (AuthController authController) {
      String? errorDescription;
      if (authController.getLoginUserData()?.id != userId) {
        if (authController.authRepo.isLoggedOut()) {
          errorDescription = "Login to view this data";
        } else if (!authController.isLoginUserSubscribed &&
                !authController.getLoginUserData()!.isFreelancer ??
            true) {
          errorDescription = 'Subscribe to view this data (free for now)';
        }
      }
      return Container(
        width: context.width - 10,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 10,
            ),
            leadingIcon ??
                Icon(
                  icon,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: InkWell(
                onTap: authController.getLoginUserData()?.id.toString() ==
                        userId.toString()
                    ? () {
                        print("helo");
                        _launch(description.toString());
                      }
                    : authController.authRepo.isLoggedIn() &&
                            !authController.isLoginUserSubscribed
                        ? () {
                            if (Get.find<AuthController>()
                                    .getLoginUserData()!
                                    .type
                                    .toString() ==
                                "admin") {
                            } else {
                              showSubscriptionBuyMessage();
                            }
                            debugPrint(
                                "authController.getLoginUserData()?.id== userId:->> ${authController.getLoginUserData()?.id == userId}");
                            // showSubscriptionBuyMessage();
                          }
                        : authController.authRepo.isLoggedOut()
                            ? () {
                                Get.toNamed(RouteHelper.getSignInRoute());
                              }
                            : () {},
                child: CustomLinkable(
                  text: errorDescription ?? description,
                  style: montserratRegular.copyWith(
                    fontSize: 16,
                  ),
                  textColor: errorDescription != null &&
                          authController.authRepo.isLoggedIn()
                      ? Theme.of(context).errorColor
                      : authController.authRepo.isLoggedOut()
                          ? Colors.red
                          : Colors.blue,
                  linkColor: errorDescription != null &&
                          authController.authRepo.isLoggedIn()
                      ? Theme.of(context).errorColor
                      : Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      );
    });
  }

  _launch(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      BotToast.showSimpleNotification(
        title: "Invalid URL",
        subTitle: null,
        onTap: () {
          // if(onTap!=null){
          //   onTap();
          //   BotToast.cleanAll();
          // }
        },
        enableSlideOff: true,
        hideCloseButton: true,
        dismissDirections: const [DismissDirection.up],
        borderRadius: Dimensions.RADIUS_SMALL,
        align: Alignment.topCenter,
        backgroundColor: const Color(0xFFF5F5F5),
        // titleStyle: montserratMedium.copyWith(color: isErrorToast && Get.context!=null ? Theme.of(Get.context!).primaryColorLight: Get.find<ThemeController>().isDarkMode ? Colors.white: Colors.black),
        subTitleStyle: montserratRegular.copyWith(color: Colors.white),
        onlyOne: true,
        crossPage: true,
        animationDuration: const Duration(milliseconds: 200),
        animationReverseDuration: const Duration(milliseconds: 200),
        duration: const Duration(seconds: 3),
      );

      throw 'Could not launch $url';
    }
  }
}
