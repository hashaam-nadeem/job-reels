import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glow_solar/util/styles.dart';

import '../../util/color_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String ?title;
  final Widget ?leading;
  final bool showLeading;
  final List<Widget> trailing;
  final Color? tileColor;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.leading,
    List<Widget> ?trailing,
    this.showLeading = true, this.tileColor,
  }):trailing = trailing??const <Widget>[] , super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      top: true,
      child: PreferredSize(
        preferredSize: Size(deviceSize.width,deviceSize.height*.05),
        child: ListTile(
            tileColor: tileColor?? Colors.transparent,
          leading: !showLeading ? const SizedBox(): leading ?? IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios,color: Theme.of(context).primaryColorDark,)),
          contentPadding: const EdgeInsets.all(0),
          title: title!=null?Center(child: Text(title!,style: montserratMedium.copyWith(fontSize: 16),)):const SizedBox(),
          trailing: trailing.isEmpty?const SizedBox(width: 5,): Wrap(
            alignment: WrapAlignment.end,
            children: trailing,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size(Get.width, GetPlatform.isDesktop ? 70 : 50);
}
