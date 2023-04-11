import 'package:flutter/material.dart';
import 'package:workerapp/utils/color_constants.dart';
import '../../../../utils/color_constants.dart';
import '../../../../utils/styles.dart';

class BottomNavItemWidget extends StatelessWidget {
  final String title;
  final String assetImagePath;
  final bool isSelected;
  const BottomNavItemWidget({Key? key,required this.title,required this.assetImagePath, this.isSelected=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backGroundColor = isSelected? const Color(0xFF87D5A6): AppColor.primaryColor.withOpacity(0.5);
    return Container(
      color: backGroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetImagePath,height: 20,width: 20,),
          Text(
            title,
            style: montserratRegular.copyWith(color: Colors.white,fontSize: 11),
          ),
        ],
      ),
    );
  }
}
