import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/util/styles.dart';

import '../../util/color_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String ?title;
  final Widget ?leading;
  final bool showLeading;
  final List<Widget> trailing;
  final Color? leadingColor;
  final Color? tileColor;
  final Color? titleColor;
  final void Function()? onTap;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.leadingColor,
    required this.leading,
    List<Widget> ?trailing,
    this.showLeading = true, this.tileColor,
    this.titleColor, this.onTap,
  }):trailing = trailing??const <Widget>[] , super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return PreferredSize(
      preferredSize: Size(deviceSize.width,deviceSize.height*.05),
      child: AppBar(
        leading: !showLeading ? const SizedBox(): leading ?? IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios,color: leadingColor ?? Theme.of(context).primaryColorLight,)),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: tileColor ?? Colors.transparent,
        title: InkWell(
            onTap: onTap,
            child: Text(title!,textAlign: TextAlign.center, style: montserratMedium.copyWith(fontSize: 16, color: titleColor ?? Theme.of(context).primaryColorDark,),)),
        actions: trailing,
      ),
      // child: ListTile(
      //     tileColor: tileColor?? Colors.transparent,
      //   leading: !showLeading ? const SizedBox(): leading ?? IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).primaryColorLight,)),
      //   contentPadding: const EdgeInsets.all(0),
      //   title: title!=null?Row(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       Text(title!,textAlign: TextAlign.center, style: montserratMedium.copyWith(fontSize: 16, color: titleColor ?? Theme.of(context).primaryColorDark,),),
      //     ],
      //   ):const SizedBox(),
      //   trailing: trailing.isEmpty?const SizedBox(width: 5,): Wrap(
      //     alignment: WrapAlignment.end,
      //     children: trailing,
      //   ),
      // ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, GetPlatform.isDesktop ? 70 : 50);
}
