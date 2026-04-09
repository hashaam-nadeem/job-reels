import 'dart:async';
import 'package:flutter/services.dart';
import 'package:glow_solar/controller/auth_controller.dart';
import 'package:glow_solar/util/dimensions.dart';
import 'package:glow_solar/view/base/custom_app_bar.dart';
import 'package:glow_solar/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glow_solar/view/base/my_text_field.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../enums/otp_verify_type.dart';
import '../../../util/app_strings.dart';
import '../../../util/styles.dart';
import '../../base/custom_snackbar.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

class OtpVerificationScreen extends StatefulWidget {
  final OtpVerifyType verifyType;
  const OtpVerificationScreen({Key? key, required this.verifyType}) : super(key: key);

  @override
  OtpVerificationScreenState createState() => OtpVerificationScreenState();
}

class OtpVerificationScreenState extends State<OtpVerificationScreen> {

  StreamController<ErrorAnimationType> errorController = StreamController<ErrorAnimationType>();
  TextEditingController otpPinController = TextEditingController();
  String otpCode = '';
  final numberReg = RegExp(r'\d+', multiLine: true);

  @override
  void initState() {
    _startListeningSms();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: const CustomAppBar(title: null, leading: null,showLeading: true,),
        body: SafeArea(
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Container(
                  width: context.width,
                  padding:  const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  margin:  EdgeInsets.zero,
                  child: GetBuilder<AuthController>(builder: (authController) {
                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                AppString.otpAuthentication.tr,
                                style: montserratMedium.copyWith(fontSize: 18),
                              ),
                            ],
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(AppString.otpSentToPhoneNo.tr,
                                  style: montserratRegular.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          Column(
                            children: [
                              PinCodeTextField(
                                length: 6,
                                obscureText: false,
                                animationType: AnimationType.fade,
                                inputFormatters:[FilteringTextInputFormatter.digitsOnly],
                                keyboardType: getKeyboardTypeForDigitsOnly(),
                                pinTheme: PinTheme(
                                  fieldHeight: 50,
                                  fieldWidth: 50,
                                  borderWidth: 0,
                                  shape: PinCodeFieldShape.box,
                                  borderRadius: BorderRadius.circular(5),
                                  selectedColor: Theme.of(context).backgroundColor,
                                  selectedFillColor: Theme.of(context).backgroundColor,
                                  activeFillColor: Theme.of(context).backgroundColor,
                                  activeColor: Theme.of(context).backgroundColor,
                                  inactiveFillColor: Theme.of(context).backgroundColor,
                                  inactiveColor: Theme.of(context).backgroundColor,
                                  errorBorderColor: Theme.of(context).errorColor,
                                ),
                                textStyle: montserratMedium.copyWith(fontSize: 24),
                                enableActiveFill: true,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                animationDuration: const Duration(milliseconds: 300),
                                backgroundColor: Colors.transparent,
                                errorAnimationController: errorController,
                                controller: otpPinController,
                                onChanged: (value) {
                                  otpCode = value;
                                },
                                beforeTextPaste: (text) {
                                  return false;
                                },
                                appContext: context,
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
                                  buttonText: AppString.conTinue.tr,
                                  onPressed: (){
                                    if(otpCode.length<6){
                                      onInvalidOtpEntered();
                                    }else{
                                      _otpVerified(authController);
                                    }
                                  },
                                ),
                              ]),
                          const SizedBox(height: 30),
                        ]);
                  }),
                ),
              ),
            )),
      ),
    );
  }

  void _otpVerified(AuthController authController,) async{
    String otpPin = otpPinController.text;
    bool isVerified = await authController.verifyOtp(int.parse(otpPin), widget.verifyType);
    if(!isVerified){
      onInvalidOtpEntered();
    }
  }

  _startListeningSms()  {
    SmsVerification.startListeningSms().then((message) {
      setState(() {
        otpCode = SmsVerification.getCode(message, numberReg);
        otpPinController.text = otpCode;
        _otpVerified(Get.find<AuthController>());
      });
    });
  }

  void onInvalidOtpEntered(){
    errorController.add(ErrorAnimationType.shake);
    showCustomSnackBar('Enter valid otp code to continue'.tr);
  }
}
