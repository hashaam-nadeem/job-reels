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
  final IconData ?icon;
  const CustomButton({Key? key, required this.onPressed, required this.buttonText, this.transparent = false, this.margin, this.width, this.height,
    this.fontSize, this.radius = 5, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Center(child: SizedBox(width: width ?? Dimensions.WEB_MAX_WIDTH, child: Container(
      padding: margin ?? const EdgeInsets.all(0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Color(0xFF1554F6),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        height: height,
        minWidth: width,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          icon != null ? Padding(
            padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: Icon(icon, color: transparent ? Theme.of(context).primaryColor : Theme.of(context).cardColor),
          ) : const SizedBox(),
          Text(buttonText, textAlign: TextAlign.center, style: montserratBold.copyWith(
            color: transparent ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
            fontSize: fontSize ?? Dimensions.fontSizeLarge,
          )),
        ]),
      ),
    )));
  }
}
