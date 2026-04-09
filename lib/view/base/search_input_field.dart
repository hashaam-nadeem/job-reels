import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jobreels/util/color_constants.dart';
import 'package:jobreels/util/dimensions.dart';
import 'package:jobreels/util/styles.dart';

class SearchCustomInputTextField extends StatefulWidget {

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
  final String? hintText;
  final bool? obscureText;
  final Widget ? prefix;
  final Widget ? prefixIcon;

  const SearchCustomInputTextField({
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
    this.prefix,
    this.onValueChange,
    this.hintText,
    this.prefixIcon,
    this.isPassword = false, this.obscureText,
  }) : super(key: key);

  @override
  State<SearchCustomInputTextField> createState() => _SearchCustomInputTextFieldState();
}

class _SearchCustomInputTextFieldState extends State<SearchCustomInputTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width??double.infinity,
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
        onChanged: widget.onValueChange,
        maxLength: widget.maxTextLength,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        autovalidateMode: AutovalidateMode.disabled,
        validator: widget.validator,
        style: montserratRegular.copyWith(fontSize: 16,),
        enabled: !widget.readOnly,
        decoration: inputDecoration(context: context,labelText: widget.labelText, suffixIcon: widget.suffixIcon, hintText: widget.hintText, prefix:widget.prefix,prefixIcon:widget.prefixIcon, backgroundColor: widget.backgroundShadow),
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

InputDecoration inputDecoration({required BuildContext context, String ?labelText, Widget ?suffixIcon,Widget ?prefixIcon,String? hintText, Widget? prefix, Color ?backgroundColor}){
  return InputDecoration(

    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
    filled: true,
    fillColor: backgroundColor ?? Theme.of(context).backgroundColor,
    errorMaxLines: 2,
    errorStyle: montserratRegular.copyWith(color: Theme.of(context).errorColor, fontSize: 11,),
    floatingLabelStyle: montserratRegular.copyWith(fontSize: 14,color: Theme.of(context).primaryColor),
    counterStyle:  montserratRegular.copyWith(fontSize: 14,),
    labelStyle: montserratRegular.copyWith(color: Theme.of(context).hintColor),
    labelText: labelText,
    suffixIcon: suffixIcon,
    suffixIconColor: Theme.of(context).hintColor,
    disabledBorder: inputFieldBorder(),
    enabledBorder: inputFieldBorder(),
    border: inputFieldBorder(),
    errorBorder: inputFieldBorder(),
    focusedBorder: inputFieldBorder(),
    focusedErrorBorder: inputFieldBorder(),
    hintText: hintText,
    prefix: prefix,
    prefixIcon: prefixIcon,
  );
}