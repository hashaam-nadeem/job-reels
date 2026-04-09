import 'package:dio/dio.dart' as ApiClient;
import 'package:flutter/foundation.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/util/dimensions.dart';
import 'package:jobreels/util/images.dart';
import 'package:jobreels/view/base/custom_app_bar.dart';
import 'package:jobreels/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/view/base/custom_snackbar.dart';
import 'package:jobreels/view/base/custom_toast.dart';
import '../../../data/api/Api_Handler/api_error_response.dart';
import '../../../helper/helper.dart';
import '../../../util/app_strings.dart';
import '../../../util/styles.dart';
import '../../base/custom_drop_down_item.dart';
import '../../base/drop_down_selection_widget.dart';
import '../../base/my_text_field.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final _formKey = GlobalKey<FormState>();

  final GlobalKey<CustomDropDownState> _numberSelectionKey = GlobalKey();
  String selectedCountryCode = "+63";
  final TextEditingController _phoneNoController = TextEditingController();
  final FocusNode _phoneNoFocus = FocusNode();
  final TextEditingController _otpCodeController = TextEditingController();
  final FocusNode _otpCodeFocus = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  bool hidePassword = false;
  bool hideConfirmPassword = false;
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FocusNode _confirmPasswordFocus = FocusNode();
  ValueListenable<bool> removeOverLayEntry = ValueNotifier(false);
  String otpCode = "";
  String errorText = "";

  @override
  Widget build(BuildContext context) {
    debugPrint("otpCode:-> $otpCode");
    return GestureDetector(
      onTap: (){
        removeOverLayEntry = ValueNotifier(true);
        setState(() {});
        FocusScope.of(context).unfocus();
        Future.delayed(const Duration(milliseconds: 300)).then((value){
          removeOverLayEntry = ValueNotifier(false);
          setState(() {});
        });
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: AppString.forgotPassword,
          titleColor: Theme.of(context).primaryColorLight,
          tileColor: Theme.of(context).primaryColor,
          leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColorLight,size: 16,),
          ),
          showLeading: true,
        ),
        body: SafeArea(
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  width: context.width,
                  padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  margin: EdgeInsets.zero,
                  child: GetBuilder<AuthController>(builder: (authController) {
                    return Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE *2),
                            Image.asset(
                              Images.logo,
                              width: 150,
                              height: 150,
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            Text(
                              AppString.forgotPassword.tr,
                              style: montserratBold.copyWith(fontSize: 25,color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            otpCode.isEmpty
                              ? Column(
                              children: [
                                ///Phone Number
                                CustomInputTextField(
                                  controller: _phoneNoController,
                                  focusNode: _phoneNoFocus,
                                  isPassword: false,
                                  context: context,
                                  keyboardType: TextInputType.phone,
                                  prefixIcon: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10,bottom: 10, left: 10,),
                                        child: SizedBox(
                                          width: 87,
                                          child: DropDownWidget(
                                            title: "",
                                            errorMessage: "",
                                            key: _numberSelectionKey,
                                            decorationNone: true,
                                            initialSelectedIndex: selectedCountryCode=="+63" ? 0 : 1,
                                            isRemoveOverLayEntry: removeOverLayEntry,
                                            dropDownItems: ['+63','+1'].map((countryCode) => CustomDropdownMenuItem(
                                              value: countryCode,
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    countryCode=="+63" ? Images.phFlag : Images.usaFlag,
                                                    width: 27,
                                                    height: 20,
                                                  ),
                                                  Expanded(child: Center(child: Text(countryCode, style: montserratRegular, overflow: TextOverflow.ellipsis, maxLines: 1,))),
                                                ],
                                              ),
                                            )).toList(),
                                            onChange: (int index, dynamic val) {
                                              if(selectedCountryCode!=val){
                                                selectedCountryCode = val;
                                                if(errorText.isNotEmpty){
                                                  errorText = "";
                                                }
                                                setState(() {});
                                              }
                                            }, isResetSelection: null,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                          child: VerticalDivider(
                                            color: Theme.of(context).primaryColor,
                                            thickness: 2,
                                            width: 2,
                                          ),
                                      ),
                                    ],
                                  ),
                                  onValueChange: (value){
                                    if(errorText.isNotEmpty){
                                      errorText = "";
                                      setState(() {});
                                    }
                                    return value;
                                  },
                                  labelText: AppString.phoneNumberRequired,
                                  validator: (inputData) {
                                    return inputData!.trim().isEmpty
                                        ? ErrorMessage.phoneNoEmptyError
                                        : inputData.length > 250
                                        ? ErrorMessage.phoneNoLengthError
                                        : null;
                                  },
                                ),
                              ],
                            )
                              : Column(
                                  children: [
                                    /// Otp Controller
                                    CustomInputTextField(
                                      controller: _otpCodeController,
                                      focusNode: _otpCodeFocus,
                                      isPassword: false,
                                      context: context,
                                      keyboardType: getKeyboardTypeForDigitsOnly(),
                                      onValueChange: (value){
                                        if(errorText.isNotEmpty){
                                          errorText = "";
                                          setState(() {});
                                        }
                                        return value;
                                      },
                                      onFieldSubmit: (value){
                                        _passwordFocus.requestFocus();
                                        return value;
                                      },
                                      labelText: AppString.verificationCodeRequired,
                                      validator: (inputData) {
                                        return inputData!.trim().isEmpty
                                            ? ErrorMessage.otpCodeEmptyError
                                            : inputData.length > 250
                                            ? ErrorMessage.otpCodeMaxLengthError
                                            : null;
                                      },
                                    ),
                                    const SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                                    /// Password Controller
                                    CustomInputTextField(
                                      controller: _passwordController,
                                      focusNode: _passwordFocus,
                                      onFieldSubmit: (value){
                                        _confirmPasswordFocus.requestFocus();
                                        return value;
                                      },
                                      isPassword: false,
                                      context: context,
                                      keyboardType: TextInputType.text,
                                      onValueChange: (value){
                                        if(errorText.isNotEmpty){
                                          errorText = "";
                                          setState(() {});
                                        }
                                        return value;
                                      },
                                      labelText: AppString.passwordRequired,
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              hidePassword = !hidePassword;
                                            });
                                          },
                                          icon: hidePassword
                                              ?  Image.asset(Images.eye,height: 25,width: 25,)
                                              : Image.asset(Images.eyeHide,height: 25,width: 25)
                                      ),
                                      validator: (inputData) {
                                        return inputData!.trim().isEmpty
                                            ? ErrorMessage.passwordEmptyError
                                            : !passwordCombinationValidator(inputData)
                                            ? ErrorMessage.passwordCombinationInvalidError
                                            : inputData.length > 250
                                            ? ErrorMessage.passwordMaxLengthError
                                            : null;
                                      },
                                    ),
                                    const SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
                                    /// Confirm Password Controller
                                    CustomInputTextField(
                                      controller: _confirmPasswordController,
                                      focusNode: _confirmPasswordFocus,
                                      isPassword: false,
                                      context: context,
                                      keyboardType: TextInputType.text,
                                      onValueChange: (value){
                                        if(errorText.isNotEmpty){
                                          errorText = "";
                                          setState(() {});
                                        }
                                        return value;
                                      },
                                      labelText: AppString.confirmPasswordRequired,
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              hideConfirmPassword = !hideConfirmPassword;
                                            });
                                          },
                                          icon: hideConfirmPassword
                                              ?  Image.asset(Images.eye,height: 25,width: 25,)
                                              : Image.asset(Images.eyeHide,height: 25,width: 25)
                                      ),
                                      validator: (inputData) {
                                        return inputData!.trim().isEmpty
                                            ? ErrorMessage.passwordEmptyError
                                            : inputData.trim()!=_passwordController.text.trim()
                                            ? ErrorMessage.passwordMissMatchError
                                            : inputData.length > 250
                                            ? ErrorMessage.passwordMaxLengthError
                                            : null;
                                      },
                                    ),
                                  ],
                                ),
                            if(errorText.isNotEmpty)
                              Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10,top: 8),
                                      child: Text(
                                        errorText,
                                        textAlign: TextAlign.start,
                                        style: montserratRegular.copyWith(
                                          color: Theme.of(context).errorColor,
                                          fontSize: 14,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomButton(
                                    width: context.width*.94,
                                    height: 50,
                                    radius: 10,
                                    buttonText: otpCode.isEmpty ? AppString.sendVerificationCode : AppString.resetPassword.tr,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if(otpCode.isEmpty){
                                          _forgetPassword(authController);
                                        }else{
                                          _resetPassword(authController);
                                        }
                                      }
                                    },
                                  ),
                                ]),
                            const SizedBox(height: 30),
                          ]),
                    );
                  }),
                ),
              ),
            )),
      ),
    );
  }

  void _forgetPassword(AuthController authController) {
    String phoneNo = _phoneNoController.text.trim();
    FocusScope.of(context).unfocus();
    authController.sendForgotPasswordOtp(ApiClient.FormData.fromMap({
      "phone": selectedCountryCode + phoneNo,
      "type": "phone",
    })).then((Map<String, dynamic> result){
      debugPrint("result:-> $result");
      if(result.containsKey(API_RESPONSE.SUCCESS)){
        otpCode = "${result[API_RESPONSE.SUCCESS]['OTPcode']}";
        setState(() {});
      }else{
        if(result.containsKey(API_RESPONSE.ERROR)){
          Map<String, dynamic>error = result[API_RESPONSE.ERROR]['errors'] as Map<String, dynamic>;
          error.forEach((key, value) {
            errorText = "$errorText\n${(value as List).first}";
          });
        }
        setState(() {});
      }
    });
  }
  void _resetPassword(AuthController authController) {
    String phone = _phoneNoController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    FocusScope.of(context).unfocus();
    authController.resetForgetPassword(ApiClient.FormData.fromMap({
      "phone": selectedCountryCode + phone,
      "password": password,
      "password_confirmation": confirmPassword,
    })).then((Map<String, dynamic> result){
      if(result.containsKey(API_RESPONSE.SUCCESS)){
        showCustomSnackBar("Password updated successfully",isError: false);
        Get.back();
      }else{
        if(result.containsKey(API_RESPONSE.ERROR)){
          Map<String, dynamic>error = result[API_RESPONSE.ERROR]['errors'] as Map<String, dynamic>;
          error.forEach((key, value) {
            errorText = "$errorText\n${(value as List).first}";
          });
        }
        setState(() {});
      }
    });
  }
}
