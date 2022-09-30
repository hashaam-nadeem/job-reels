import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/color_constants.dart';
import '../../utils/dimensions.dart';
import '../../utils/styles.dart';

TextStyle postTextStyle({
  double fontSize = 15,
  FontWeight fontWeight = FontWeight.w400,
  String ?fontFamily,
  TextDecoration decoration = TextDecoration.none,
  Color color = Colors.black,
  FontStyle fontStyle = FontStyle.normal,
}){

  return TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
    decoration: decoration,
    color: color,
    fontStyle: fontStyle,
  );
}

class PostDoneButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;
  final double minWidth;
  final Color ?backGroundColor;
  const PostDoneButton({Key? key,required this.onPressed, this.buttonText = 'Done',this.minWidth=double.infinity, this.backGroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: minWidth,
      height: 40,
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(33),
      ),
      color: backGroundColor??Theme.of(context).primaryColor,
      child: Text(
        buttonText,
        style: postTextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class CustomInputTextField extends StatefulWidget {

  final TextEditingController controller;
  final FocusNode ?focusNode;
  final BuildContext context;
  final double? width;
  final Color ?backgroundShadow;
  final void Function()? onTap;
  final bool readOnly;
  final String ?labelText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final String? Function(String?)? onValueChange;
  final List<TextInputFormatter> ?inputFormatters;
  final TextInputAction? textInputAction;
  final int ?minLines;
  final int ?maxLines;
  final int? maxTextLength;

  const CustomInputTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.context,
    this.width,
    this.backgroundShadow,
    this.onTap,
    this.readOnly = false,
    this.labelText,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.textInputAction,
    this.minLines,
    this.maxLines,
    this.maxTextLength,
    this.validator,
    this.onValueChange,
    this.isPassword = false,
  }) : super(key: key);

  @override
  State<CustomInputTextField> createState() => _CustomInputTextFieldState();
}

class _CustomInputTextFieldState extends State<CustomInputTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width??double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withOpacity(.79),
        borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS)
      ),
      child: Center(
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          readOnly: widget.readOnly,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          textInputAction: widget.textInputAction,
          textCapitalization: TextCapitalization.sentences,
          onTap: widget.onTap!=null?(){
            FocusScope.of(context).unfocus();
            widget.onTap!();
          }:null,
          onChanged: widget.onValueChange,
          maxLength: widget.maxTextLength,
          minLines: widget.minLines,
          maxLines: widget.maxLines,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: widget.validator,
          style: montserratRegular.copyWith(fontSize: 16,),
          enabled: !widget.readOnly,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(10),
            filled: widget.backgroundShadow!=null,
            fillColor:  widget.backgroundShadow,
            errorMaxLines: 2,
            errorStyle: montserratRegular.copyWith(color: AppColor.errorColor, fontSize: 11,),
            hintText: widget.labelText,
            hintStyle: montserratRegular.copyWith(color: Colors.black,fontSize: 16),
            counterStyle:  montserratRegular.copyWith(fontSize: 10,),
            suffixIcon: widget.suffixIcon,
            suffixIconColor: Colors.black,
            disabledBorder: inputFieldBorder(),
            enabledBorder: inputFieldBorder(),
            border: inputFieldBorder(),
            errorBorder: inputFieldBorder(),
            focusedBorder: inputFieldBorder(),
            focusedErrorBorder: inputFieldBorder(),
          ),
        ),
      ),
    );
  }
}
TextInputType getKeyboardTypeForDigitsOnly(){
  return Platform.isIOS?TextInputType.datetime:TextInputType.number;
}

InputBorder inputFieldBorder(){
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS),
    borderSide: const BorderSide(color: Colors.transparent),
  );
}
