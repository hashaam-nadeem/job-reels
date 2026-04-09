import 'package:jobreels/util/color_constants.dart';
import 'package:jobreels/util/dimensions.dart';
import 'package:jobreels/util/styles.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  final Column? columnS;
  final List<Widget>? children;
  final String buttonText;
  final bool transparent;
  final EdgeInsets ?margin;
  final double ?height;
  final double ?width;
  final double ?fontSize;
  final double radius;
  final IconData ?icon;
  final Decoration? decoration;
  final Color? textColor;
  const CustomButton({Key? key, required this.onPressed, required this.buttonText, this.transparent = false, this.margin, this.width, this.height,
    this.fontSize, this.radius = 8, this.icon, this.decoration, this.textColor, this.children, this.columnS}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Center(child: SizedBox(width: width ?? Dimensions.WEB_MAX_WIDTH, height: height, child: Container(
      padding: margin ?? const EdgeInsets.all(0),
      decoration: decoration ?? BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Theme.of(context).primaryColor,
      ),
      child: MaterialButton(
        onPressed: onPressed,
        height: height,
        minWidth: width,
        padding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            columnS??
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [

              icon != null ? Padding(
                padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                child: Icon(icon, color: transparent ? Theme.of(context).primaryColor : Theme.of(context).cardColor),
              ) : const SizedBox(),
              Text(buttonText, textAlign: TextAlign.center, style: montserratBold.copyWith(
                color: transparent ? Theme.of(context).primaryColor : textColor ?? Theme.of(context).cardColor,//Theme.of(context).cardColor,
                fontSize: fontSize ?? Dimensions.fontSizeLarge,
              )),
            ]),
          ],
        ),
      ),
    )));
  }
}
