import 'package:flutter/material.dart';
import '../../utils/color_constants.dart';
import '../../utils/dimensions.dart';
import '../../utils/styles.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final bool transparent;
  final EdgeInsets ?margin;
  final double ?height;
  final double ?width;
  final double ?fontSize;
  final double radius;
  final Widget ?icon;
  final bool iconAtStart;
  final double ?spaceBetweenTextAndIcon;
  final Color ?color;
  final Color ?textColor;

  const CustomButton({Key? key, required this.onPressed, required this.buttonText, this.transparent = false, this.margin, this.width, this.height,
    this.fontSize, this.radius = 5, this.icon, this.color, this.textColor, this.iconAtStart=true, this.spaceBetweenTextAndIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Center(child: SizedBox(width: width ?? Dimensions.WEB_MAX_WIDTH, child: Container(
      padding: margin ?? const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color ?? AppColor.primaryColor,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        height: height,
        minWidth: width,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
          icon != null&& iconAtStart ? icon! : const SizedBox(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(buttonText, textAlign: TextAlign.center, style: montserratBold.copyWith(
                  color: transparent ? Theme.of(context).primaryColor : textColor ?? Theme.of(context).cardColor,
                  fontSize: fontSize ?? Dimensions.fontSizeLarge,
                )),
              ],
            ),
          ),
          icon != null&& !iconAtStart ? icon! : const SizedBox(),
        ]),
      ),
    )));
  }
}
