import 'package:glow_solar/controller/auth_controller.dart';
import 'package:glow_solar/util/dimensions.dart';
import 'package:glow_solar/view/base/custom_app_bar.dart';
import 'package:glow_solar/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../util/app_strings.dart';
import '../../../util/styles.dart';
import '../../base/my_text_field.dart';

class ForgetPassScreen extends StatefulWidget {
  const ForgetPassScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPassScreen> createState() => _ForgetPassScreenState();
}

class _ForgetPassScreenState extends State<ForgetPassScreen> {
  final _formKey = GlobalKey<FormState>();
  //final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneNoFocus = FocusNode();
  //final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: const CustomAppBar(
          title: null,
          leading: null,
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
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  AppString.isForgetYourPassword.tr,
                                  style: montserratMedium.copyWith(fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            Text(
                              AppString.weSendMsgOnNoToResetPassword.tr,
                              style: montserratRegular.copyWith(fontSize: 14),
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            Column(
                              children: [
                                ///Phone No
                                CustomInputTextField(
                                  controller: _phoneNoController,
                                  focusNode: _phoneNoFocus,
                                  isPassword: false,
                                  context: context,
                                  keyboardType: TextInputType.phone,
                                  prefix: SizedBox(
                                      width: MediaQuery.of(context).size.width * .11,
                                      child:  Center(
                                          child: Text(
                                            "+1",
                                            style: montserratRegular.copyWith(color: Theme.of(context).primaryColorDark),
                                          ))),
                                  labelText: AppString.phoneNo,
                                  validator: (inputData) {
                                    return inputData!.trim().isEmpty
                                        ? ErrorMessage.phoneNoEmptyError
                                        : inputData.length > 250
                                        ? ErrorMessage.phoneNoLengthError
                                        : null;
                                  },
                                ),
                                // CustomInputTextField(
                                //   controller: _emailController,
                                //   focusNode: _emailFocus,
                                //   isPassword: false,
                                //   context: context,
                                //   labelText: AppString.email,
                                //   validator: (inputData) {
                                //     return inputData!.trim().isEmpty
                                //         ? ErrorMessage.emailEmptyError
                                //         : !RegExp(AppString.emailFormat)
                                //         .hasMatch(inputData)
                                //         ? ErrorMessage.emailInvalidError
                                //         : inputData.length > 250
                                //         ? ErrorMessage.emailMaxLengthError
                                //         : null;
                                //   },
                                // ),
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
                                    buttonText: AppString.next.tr,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _forgetPas(authController);
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

  void _forgetPas(AuthController authController) {
    String phoneNo = _phoneNoController.text.trim();
    String countryCode = "+1";
    FocusScope.of(context).unfocus();
    authController.forgetPassword(phoneNo,countryCode);
  }
}
