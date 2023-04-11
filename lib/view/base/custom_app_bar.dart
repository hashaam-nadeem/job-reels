import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workerapp/utils/color_constants.dart';

import '../../utils/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String ?title;
  final Widget ?titleWidget;
  final Widget ?leading;
  final List<Widget> trailing;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.leading,
    this.titleWidget,
    List<Widget> ?trailing,
  }):trailing = trailing??const <Widget>[] , super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        color: AppColor.primaryColor,
        child: PreferredSize(
          preferredSize: Size(deviceSize.width,deviceSize.height*.05),
          child: ListTile(
            textColor: Colors.white,
            leading: leading ?? IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).primaryColorLight,)),
            contentPadding: const EdgeInsets.all(0),
            title: titleWidget ?? (title!=null?Text(title!,style: montserratMedium.copyWith(fontSize: 20,color: Colors.white),):const SizedBox()),
            trailing: trailing.isEmpty?const SizedBox(width: 5,): Wrap(
              alignment: WrapAlignment.end,
              children: trailing,
            ),
          ),

        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, GetPlatform.isDesktop ? 70 : 50);
}

// class CustomExpandableAppBar extends AppBar {
//   final String appbarTitle;
//   final Widget ?leading;
//   final List<Widget> trailing;
//   final List<Widget> expandedWidgets;
//   final bool isExpanded;
//   final void Function()  onTap;
//
//   CustomExpandableAppBar({
//     Key? key,
//     required this.appbarTitle,
//     required this.leading,
//     required this.isExpanded,
//     required this.expandedWidgets,
//     required this.onTap,
//     List<Widget> ?trailing,
//   }):trailing = trailing??const <Widget>[], super(key: key);



  AppBar CustomExpandableAppBar({
    Key? key,
    required String appbarTitle,
    required Widget ?leading,
    required bool isExpanded,
    required List<Widget> expandedWidgets,
    required void Function() onTap,
    List<Widget> ?trailing,
  }) {
    trailing = trailing??[];
    return AppBar(
      backgroundColor: AppColor.primaryColor,
      automaticallyImplyLeading: false,
      elevation: 5.0,
      leading: leading ?? IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios,color: AppColor.blackColor,)),
      centerTitle: true,
      title: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                appbarTitle,
                style: montserratMedium.copyWith(fontSize: 20,color: Colors.white)
            ),
            Transform.rotate(
              angle: isExpanded ? -pi :0,
              child: const Icon(
                Icons.arrow_drop_down_sharp,
                size: 30,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      actions: trailing,
    );
  }

// }
