import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workerapp/helper/route_helper.dart';
import 'package:workerapp/utils/app_images.dart';
import 'package:workerapp/utils/dimensions.dart';
import 'package:workerapp/utils/styles.dart';
import 'package:workerapp/view/screens/notification/notification_screen.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/bottom_bar_controller.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: context.width,
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                    width: context.width,
                    child: Center(
                      child: Text(
                        'Main Menu',
                        style: montserratRegular.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF000000).withOpacity(0.87)
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Text(
                    "General",
                    style: montserratRegular.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF000000).withOpacity(0.60)
                    ),
                  ),
                  drawerItem(
                      leadingImage: Images.clockImage,
                      title: "Notifications",
                      onPressed: (){
                        // Get.to(const NotificationScreen());
                        Get.find<BottomBarController>().changeMainScreenBottomNavIndex(5,isShowsSelected: false);
                      },
                  ),
                  ListTile(
                    contentPadding: const EdgeInsets.only(right: 5),
                    leading: Text(
                      'Allow Notifications',
                      style: montserratRegular.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF000000).withOpacity(0.87)
                      ),
                    ),
                    trailing: Switch(
                      onChanged: (bool value) {

                      },
                      activeColor: const Color(0xFF1554F6),
                      value: true,

                    ),
                  ),
                  drawerItem(
                    leadingImage: Images.fingerprint,
                    title: "Privacy and security",
                    onPressed: (){

                    },
                  ),
                  drawerItem(
                    leadingImage: Images.settings,
                    title: "Settings",
                    onPressed: (){

                    },
                  ),

                  const Divider(),

                  Text(
                    "About",
                    style: montserratRegular.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF000000).withOpacity(0.60)
                    ),
                  ),
                  drawerItem(
                    leadingImage: Images.info,
                    title: "Privacy policy",
                    onPressed: (){

                    },
                  ),
                  drawerItem(
                    leadingImage: Images.logout,
                    title: "Logout",
                    onPressed: (){
                     // Get.offAllNamed(RouteHelper.login);
                      Get.find<AuthController>().logout();
                    },
                  ),
                  const Divider(),
                  Text(
                    "Clear cache",
                    style: montserratRegular.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF000000).withOpacity(0.87)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget drawerItem({required String leadingImage, required title, required void Function() onPressed}){
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        padding: const EdgeInsets.only(right: 16),
        child: Row(
          children: [
            Image.asset(
              leadingImage,
              height: 22,
              width: 22,
            ),
            const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE,),
            Text(
              title,
              style: montserratRegular.copyWith(
                fontSize: 16,
                color: const Color(0xFF000000).withOpacity(0.87)
              ),
            ),
            const Spacer(),
            const SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: const Color(0xFF000000).withOpacity(0.60),
            )
          ],
        ),
      ),
    );
  }
}
