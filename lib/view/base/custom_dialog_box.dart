import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:jobreels/util/app_constants.dart';
import 'package:jobreels/util/styles.dart';
import '../../controller/theme_controller.dart';
import '../../util/app_strings.dart';
import '../../util/color_constants.dart';
import '../../util/images.dart';
import 'custom_button.dart';

Future<bool> showCustomDialog({required BuildContext context, required String descriptions,required String title,String? yes,String? no })async{
  bool isConfirmed = false;
  await showDialog(context: context,
      builder: (BuildContext context){
        return CustomDialogBox(
          descriptions: descriptions,
          title: title,
          yes: yes,
          no: no,
          onPress:(bool value){
            isConfirmed = value;
          },
        );
      });
  return isConfirmed;
}

class CustomDialogBox extends StatefulWidget {
  final String title, descriptions;
  final String? yes;
  final String? no;
  final Function (bool isConfirmed)onPress;

   const CustomDialogBox({Key? key, required this.title,required this.descriptions, required this.onPress, this.yes, this.no}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}
  class _CustomDialogBoxState extends State<CustomDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(left: AppConstants.padding,top: AppConstants.avatarRadius
              + AppConstants.padding, right: AppConstants.padding,bottom: AppConstants.padding
          ),
          margin: const EdgeInsets.only(top: AppConstants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(AppConstants.padding),
              boxShadow: const [
                BoxShadow(color: Colors.black,offset: Offset(0,1),
                    blurRadius: 6
                ),
              ]
          ),
          child: Column(

            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(widget.title,style: montserratMedium.copyWith(fontSize: 20),),
              const SizedBox(height: 5,),
              Text(widget.descriptions,style: varelaRoundRegular.copyWith(fontSize: 14),),
              const SizedBox(height: 25,),
              Row(
                children: [
                 // const Spacer(),
                  Expanded(
                     child: CustomButton(
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10),
                         color: Colors.transparent,
                         border: Border.all(color: Get.find<ThemeController>().isDarkMode?AppColor.primaryGradiantEnd:Colors.black.withOpacity(.30))
                       ),
                       onPressed: () {
                         widget.onPress(false);
                         Get.back();
                       },
                       textColor: Get.find<ThemeController>().isDarkMode?const Color(0xffFFC836):const Color(0xffB3B3B3),
                       radius: 10,
                       buttonText:widget.no?? AppString.no,

              )),
                  const SizedBox(width: 10,),
                  Expanded(
                    child:  CustomButton(
                      onPressed: () {
                        widget.onPress(true);
                        Get.back();
                      },
                      radius: 10,
                      buttonText:widget.yes?? AppString.yes,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: AppConstants.padding,
          right: AppConstants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: AppConstants.avatarRadius,
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(AppConstants.avatarRadius)),
              child: Image.asset(Images.alertDialogBox),
            ),
          ),
        ),
      ],
    );
  }
}

