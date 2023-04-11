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
  final BuildContext context;
  final double? width;
  final Color ?backgroundShadow;
  final void Function()? onTap;
  final bool readOnly;
  final String ?hintText;
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
  final bool hasDecoration;
  final bool isShowLabel;
  final Color? borderColor;
  final Color? backGroundColor;
  final double? height;
  final double? contextPadding;
  final double? fontSize;

  const CustomInputTextField({
    Key? key,
    required this.controller,
    required this.context,
    this.width,
    this.backgroundShadow,
    this.onTap,
    this.readOnly = false,
    this.hintText,
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
    this.hasDecoration=true,
    this.isShowLabel=false,
    this.borderColor,
    this.height,
    this.backGroundColor,
    this.contextPadding,
    this.fontSize,

  }) : super(key: key);

  @override
  State<CustomInputTextField> createState() => _CustomInputTextFieldState();
}
class _CustomInputTextFieldState extends State<CustomInputTextField> {
  FocusNode focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {

    return Container(
      width: widget.width??double.infinity,
      height: widget.height??70,
      padding: const EdgeInsets.only(top: 13,left: 22,bottom: 0),
      decoration: BoxDecoration(
        border:  widget.hasDecoration ? null : Border.all(color: focusNode.hasFocus? const Color(0xFF65DACC): Colors.transparent,),
        color: widget.backGroundColor?? const Color(0xFFFFFFFF).withOpacity(widget.hasDecoration? .79:1),
        borderRadius: BorderRadius.circular(widget.hasDecoration? Dimensions.BORDER_RADIUS:8),
          boxShadow: widget.hasDecoration
              ?[]
              : [
            const BoxShadow(
              color: Color(0x05000000),
              offset: Offset(0,1),
              blurRadius: 8,
              spreadRadius: 0,
              blurStyle: BlurStyle.solid,
            ),
          ]
      ),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword,
        focusNode: focusNode,
        scrollPadding: const EdgeInsets.all(0),
        readOnly: widget.readOnly,
        keyboardType: widget.keyboardType,
        inputFormatters: widget.inputFormatters,
        textInputAction: widget.textInputAction,
        textCapitalization: TextCapitalization.sentences,
        onTap: (){
          if(widget.onTap!=null){
            FocusScope.of(context).unfocus();
            widget.onTap!();
          }
        },
        onChanged: widget.onValueChange,
        maxLength: widget.maxTextLength,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        style: montserratRegular.copyWith(fontSize: widget.fontSize?? 16,),
        enabled: !widget.readOnly,
        decoration: InputDecoration(
          contentPadding:   EdgeInsets.all(widget.contextPadding??0),
          filled: widget.backgroundShadow!=null,
          fillColor:  widget.backgroundShadow,
          errorMaxLines: 2,
          labelText: widget.hasDecoration?null:widget.hintText,

          errorStyle: montserratRegular.copyWith(color: AppColor.errorColor, fontSize: 11,),
          hintText: widget.hintText,
          hintStyle: montserratRegular.copyWith(color: Colors.black.withOpacity(.50),fontSize: widget.fontSize?? 16),
          counterStyle:  montserratRegular.copyWith(fontSize: 10,),
          suffixIcon: widget.suffixIcon,
          suffixIconColor: Colors.black,
          floatingLabelStyle: montserratRegular.copyWith(color: const Color(0xFF9B9B9B),fontSize: 15,fontWeight: FontWeight.w400),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          disabledBorder: inputFieldBorder(hasDecoration: widget.hasDecoration,borderColor:widget.borderColor),
          enabledBorder: inputFieldBorder(hasDecoration: widget.hasDecoration,borderColor:widget.borderColor),
          border: inputFieldBorder(hasDecoration: widget.hasDecoration,borderColor:widget.borderColor),
          errorBorder: inputFieldBorder(hasDecoration: widget.hasDecoration,borderColor:widget.borderColor),
          focusedBorder: inputFieldBorder(hasDecoration: widget.hasDecoration,borderColor:widget.borderColor),
          focusedErrorBorder: inputFieldBorder(hasDecoration: widget.hasDecoration,borderColor:widget.borderColor),
        ),
      ),
    );
  }
}


TextInputType getKeyboardTypeForDigitsOnly(){
  return Platform.isIOS?TextInputType.datetime:TextInputType.number;
}

InputBorder inputFieldBorder({bool hasDecoration=true,final Color? borderColor}){
  return hasDecoration
      ? OutlineInputBorder(
    borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS),
    borderSide:  BorderSide(color: borderColor??Colors.transparent),
  )
      : OutlineInputBorder(
    borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS),
    borderSide:  BorderSide(color:borderColor?? Colors.transparent),
  );
}
