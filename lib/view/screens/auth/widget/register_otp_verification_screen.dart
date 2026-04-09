import 'package:flutter/services.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/helper/route_helper.dart';
import 'package:jobreels/util/dimensions.dart';
import 'package:jobreels/view/base/custom_app_bar.dart';
import 'package:jobreels/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/view/base/my_text_field.dart';
import 'package:dio/dio.dart' as ApiClient;
import '../../../../data/model/helpers.dart';
import '../../../../util/app_strings.dart';
import '../../../../util/styles.dart';
import '../../../base/popup_alert.dart';

class RegisterOtpVerificationScreen extends StatefulWidget {
  final ApiClient.FormData registerFormData;
  final String otpCode;
  final bool isFreeLancer;
  const RegisterOtpVerificationScreen({Key? key, required this.registerFormData, required this.otpCode, required this.isFreeLancer}) : super(key: key);

  @override
  RegisterOtpVerificationScreenState createState() => RegisterOtpVerificationScreenState();
}

class RegisterOtpVerificationScreenState extends State<RegisterOtpVerificationScreen> {

  String otpCode = '';
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String otpErrorText = '';

  @override
  void dispose() {
    super.dispose();
  }
  @override
  void initState() {
    otpCode = widget.otpCode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: AppString.verifyCode,
          titleColor: Theme.of(context).primaryColorLight,
          leading: IconButton(
            onPressed: (){
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColorLight,size: 16,),
          ),
          tileColor: Theme.of(context).primaryColor,
        ),
        body: SafeArea(
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  width: context.width,
                  padding:  const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  margin:  EdgeInsets.zero,
                  child: GetBuilder<AuthController>(builder: (authController) {
                    return Form(
                      key: _formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                              child: Text(
                                AppString.signUpAsRemoteEmployee.tr,
                                textAlign: TextAlign.center,
                                style: montserratMedium.copyWith(
                                  fontSize: 24,
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            CustomInputTextField(
                              controller: _otpController,
                              focusNode: _otpFocusNode,
                              isPassword: false,
                              context: context,
                              keyboardType: getKeyboardTypeForDigitsOnly(),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              textInputAction: TextInputAction.done,
                              labelText: AppString.verificationCode,
                              onValueChange: (value){
                                if(otpErrorText.isNotEmpty){
                                  otpErrorText = "";
                                  setState(() {});
                                }
                                return value;
                              },
                              validator: (inputData) {
                                return inputData!.trim().isEmpty
                                    ? ErrorMessage.otpCodeEmptyError
                                    : null;
                              },
                            ),
                            if(otpErrorText.isNotEmpty)
                              Row(
                                children: [
                                  Flexible(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10,top: 8),
                                      child: Text(
                                        otpErrorText,
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
                                    width: 120,
                                    height: 50,
                                    radius: 50,
                                    buttonText: AppString.verifyCode.tr,
                                    onPressed: (){
                                      if((_formKey.currentState?.validate()??true)){
                                        if(_otpController.text.trim()==otpCode){
                                          _otpVerified(authController);
                                        }else{
                                          onInvalidOtpEntered();
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

  void _otpVerified(AuthController authController,) async{
    if(widget.isFreeLancer){
      await authController.registerFreeLancer(widget.registerFormData);
    }else{
      await authController.registerHirer(widget.registerFormData);
    }
  }

  void onInvalidOtpEntered(){
    otpErrorText = ErrorMessage.enterValidCodeToContinue.tr;
    setState(() {});
  }
}
