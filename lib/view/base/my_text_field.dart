import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobreels/util/dimensions.dart';
import 'package:jobreels/util/styles.dart';

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
  final String? Function(String?)? onFieldSubmit;
  final List<TextInputFormatter> ?inputFormatters;
  final TextInputAction? textInputAction;
  final int ?minLines;
  final int ?maxLines;
  final int? maxTextLength;
  final String? hintText;
  final bool? obscureText;
  final Widget ? prefix;
  final Widget ? prefixIcon;
  final bool showLabelText;
  final double borderRadius;
  final bool isNoBorderDecoration;

  const CustomInputTextField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.context,
    this.showLabelText = true,
    this.width,
    this.backgroundShadow,
    this.onFieldSubmit,
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
    this.prefix,
    this.onValueChange,
    this.hintText,
    this.prefixIcon,
    this.isNoBorderDecoration = false,
    this.isPassword = false, this.obscureText,
    this.borderRadius = Dimensions.BORDER_RADIUS,
  }) : super(key: key);

  @override
  State<CustomInputTextField> createState() => _CustomInputTextFieldState();
}

class _CustomInputTextFieldState extends State<CustomInputTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width??double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(widget.labelText!=null && widget.showLabelText)
            Text(
              widget.labelText!,
              style: montserratRegular.copyWith(fontSize: 16, color: Theme.of(context).primaryColor,),
            ),
          if(widget.labelText!=null && widget.showLabelText)
            const SizedBox(height: 5,),
    Theme(data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
            selectionColor: Theme.of(context).secondaryHeaderColor)),
            child: TextFormField(
              obscureText:widget.obscureText?? false,
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
              onFieldSubmitted: widget.onFieldSubmit,
              onChanged: widget.onValueChange,
              maxLength: widget.maxTextLength,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: widget.validator,
              style: montserratRegular.copyWith(fontSize: 16,),
              enabled: !widget.readOnly,
              decoration: inputDecoration(context: context,labelText: widget.labelText, suffixIcon: widget.suffixIcon, hintText: widget.hintText, prefix:widget.prefix,prefixIcon:widget.prefixIcon, backgroundColor: widget.backgroundShadow, borderRadius: widget.borderRadius, isNoBorderDecoration: widget.isNoBorderDecoration),
            ),
          ),
        ],
      ),
    );
  }
}
TextInputType getKeyboardTypeForDigitsOnly(){
  return Platform.isIOS?TextInputType.datetime:TextInputType.number;
}

InputBorder inputFieldBorder(BuildContext context, double borderRadius, bool  isNoBorderDecoration){
  return isNoBorderDecoration ? InputBorder.none : OutlineInputBorder(
    borderRadius: BorderRadius.circular(borderRadius),
    borderSide: BorderSide(color: Theme.of(context).primaryColor),
  );
}

InputDecoration inputDecoration({required BuildContext context, String ?labelText, Widget ?suffixIcon,Widget ?prefixIcon,String? hintText, Widget? prefix, Color ?backgroundColor, required double borderRadius, bool isNoBorderDecoration = false}){
  return InputDecoration(
    contentPadding: const EdgeInsets.all(10),
    filled: true,
    fillColor: backgroundColor ?? Theme.of(context).primaryColorLight,
    errorMaxLines: 3,
    errorStyle: montserratRegular.copyWith(color: Theme.of(context).errorColor, fontSize: 14, fontStyle: FontStyle.italic,),
    floatingLabelStyle: montserratRegular.copyWith(fontSize: 14,color: Theme.of(context).primaryColor),
    counterStyle:  montserratRegular.copyWith(fontSize: 14,),
    labelStyle: montserratRegular.copyWith(color: Theme.of(context).hintColor),
    suffixIcon: suffixIcon,
    suffixIconColor: Theme.of(context).hintColor,
    disabledBorder: inputFieldBorder(context, borderRadius, isNoBorderDecoration),
    enabledBorder: inputFieldBorder(context, borderRadius, isNoBorderDecoration),
    border: inputFieldBorder(context, borderRadius, isNoBorderDecoration),
    errorBorder: inputFieldBorder(context, borderRadius, isNoBorderDecoration),
    focusedBorder: inputFieldBorder(context, borderRadius, isNoBorderDecoration),
    focusedErrorBorder: inputFieldBorder(context, borderRadius, isNoBorderDecoration),
    hintText: hintText,
    prefix: prefix,
    prefixIcon: prefixIcon,
  );
}
