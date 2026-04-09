import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:jobreels/helper/route_helper.dart';
import 'package:jobreels/util/images.dart';
import 'package:jobreels/util/styles.dart';
import 'package:jobreels/view/base/custom_button.dart';
import '../../data/model/helpers.dart';

Future<void> showPopUpAlert({required PopupObject popupObject, bool barrierDismissible=true})async{
  await Get.dialog(PopupAlert(popupObject: popupObject, barrierDismissible: barrierDismissible), barrierDismissible:barrierDismissible);
}

class PopupAlert extends StatelessWidget {
  final PopupObject popupObject;
  final bool barrierDismissible;

   const PopupAlert({
    Key ?key,
    required this.popupObject,
    this.barrierDismissible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        if(barrierDismissible){
          Get.back();
        }
        return false;
      },
      child: GestureDetector(
        onTap: () {
          if(barrierDismissible){
            Get.back();
          }
        },
        child: Container(
          color: Colors.transparent,
          margin: EdgeInsets.only(left: context.width *0.1, right: context.width *0.1, top: context.height*0.28),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Material(
                color: Colors.transparent,
                child: Container(
                  margin: const EdgeInsets.only(top: 36),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 50,),
                      Text(
                        popupObject.title,
                        textAlign: TextAlign.center,
                        style: montserratBold.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        popupObject.body,
                        textAlign: TextAlign.center,
                        style: montserratRegular.copyWith(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      popupObject.buttonText!=null
                          ? CustomButton(
                        onPressed: () {
                          popupObject.onYesPressed();
                        },
                        width: 120,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textColor: Theme.of(context).primaryColorLight,
                        height: 40,
                        buttonText: popupObject.buttonText!,
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomButton(
                            onPressed: () {
                              Get.back();
                            },
                            width: 70,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              border: Border.all(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textColor: Theme.of(context).primaryColor,
                            height: 40,
                            buttonText: 'No',
                          ),
                          const SizedBox(width: 10,),
                          CustomButton(
                            onPressed: () {
                              popupObject.onYesPressed();
                            },
                            width: 70,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              border: Border.all(color: Theme.of(context).primaryColor),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            textColor: Theme.of(context).primaryColorLight,
                            height: 40,
                            buttonText: popupObject.buttonText ?? 'Yes',
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Image.asset(
                  Images.logo,
                  width: 70.0,
                  height: 70.0,
                  fit: BoxFit.contain,
                ),
              ),
              if(popupObject.buttonText!=null&& !popupObject.hideTopRightCancelButton)
                Positioned(
                top: 40,
                right: 5,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  clipBehavior: Clip.antiAlias,
                  child: Material(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: (){Get.back();},
                        icon: const Icon(Icons.clear),
                      ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}