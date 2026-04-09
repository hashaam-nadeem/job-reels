import 'package:dio/dio.dart' as ApiClient;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jobreels/data/api/Api_Handler/api_error_response.dart';
import 'package:jobreels/enums/report_type.dart';
import 'package:jobreels/util/images.dart';
import '../../../controller/auth_controller.dart';
import '../../../helper/helper.dart';
import '../../../util/app_strings.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
import '../../base/my_text_field.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  String otpCode = '';
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  String otpErrorText = '';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: AppString.deleteAccount,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Images.logo,
                                  width: 60,
                                  height: 60,
                                ),
                              ],
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppString.deleteAccount.tr,
                                  textAlign: TextAlign.center,
                                  style: montserratMedium.copyWith(
                                    fontSize: 24,
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            Text(
                              AppString.deletingYourAccountWill,
                              style: montserratMedium.copyWith(
                                color: Theme.of(context).errorColor,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            Text(
                              AppString.deletingYourInformation,
                              style: montserratRegular.copyWith(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            Text(
                              Get.find<AuthController>().getLoginUserData()!.isFreelancer ? AppString.deletingYourConversationsWithJobSeekers : AppString.deletingYourVideos,
                              style: montserratRegular.copyWith(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            Text(
                              Get.find<AuthController>().getLoginUserData()!.isFreelancer ? AppString.deletingYourPostedVideos : AppString.deletingYourConversations,
                              style: montserratRegular.copyWith(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            Text(
                              AppString.youWillUnableToRecoverButCanCreateNewAccount,
                              style: montserratRegular.copyWith(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 15,
                              ),
                            ),
                            if(!Get.find<AuthController>().getLoginUserData()!.isFreelancer)
                            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            if(!Get.find<AuthController>().getLoginUserData()!.isFreelancer)
                              Text(
                                AppString.ifYouHaveSubscriptionCancelThem,
                                style: montserratRegular.copyWith(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: 15,
                                ),
                              ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            Text(
                              AppString.needToVerifyCodeTOConfirmDelete,
                              style: montserratRegular.copyWith(
                                color: Theme.of(context).primaryColorDark,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            otpCode.isEmpty
                                ? CustomInputTextField(
                              controller: TextEditingController(text: AppString.sendVerificationCodeToPhone),
                              focusNode: null,
                              isPassword: false,
                              readOnly: true,
                              context: context,
                              hintText: AppString.sendVerificationCodeToPhone,
                              labelText: AppString.verifyThroughPhoneRequired,
                            )
                                : CustomInputTextField(
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
                                  Expanded(
                                    child: CustomButton(
                                      height: 50,
                                      radius: 8,
                                      buttonText: otpCode.isEmpty? AppString.sendVerificationCode.tr : AppString.verifyCode.tr,
                                      onPressed: (){
                                        if(otpCode.isEmpty){
                                          /// Send Verification code
                                          authController.deleteAccountOtpSend(ApiClient.FormData.fromMap({"otpType": "phone",})).then((Map<String, dynamic> result){
                                            if(result.containsKey(API_RESPONSE.SUCCESS)){
                                              num time = num.parse("${result[API_RESPONSE.SUCCESS]['time']??1}");
                                              num verify = num.parse("${result[API_RESPONSE.SUCCESS]['verify']??1235}");
                                              otpCode = decryptDataAndGetOtp(verify: verify, time: time);
                                              setState(() {});
                                            }
                                          });
                                        }else{
                                          /// Delete account
                                          if((_formKey.currentState?.validate()??true)){
                                            if(_otpController.text.trim()==otpCode){
                                              _otpVerified(authController);
                                            }else{
                                              onInvalidOtpEntered();
                                            }
                                          }
                                        }
                                      },
                                    ),
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
    String otpPin = _otpController.text.trim();
    await authController.deleteAccount(ApiClient.FormData.fromMap({"otpType": "phone",}));
  }

  void onInvalidOtpEntered(){
    otpErrorText = ErrorMessage.enterValidCodeToContinue.tr;
    setState(() {});
  }

}
