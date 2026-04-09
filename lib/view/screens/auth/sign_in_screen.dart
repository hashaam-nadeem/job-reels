import 'package:jobreels/helper/helper.dart';
import 'package:jobreels/util/app_strings.dart';
import 'package:jobreels/util/dimensions.dart';
import 'package:jobreels/util/images.dart';
import 'package:jobreels/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/view/base/custom_app_bar.dart';
import 'package:jobreels/view/base/my_text_field.dart';
import 'package:pay/pay.dart';
import '../../../controller/auth_controller.dart';
import '../../../data/api/Api_Handler/api_error_response.dart';
import '../../../helper/route_helper.dart';
import '../../../util/default_payment_config.dart';
import '../../base/custom_button.dart';
import '../../base/custom_loader.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  bool hidePassword = true;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailNoFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorText = '';
  bool isApiCalling = false;
  static const _paymentItems = [
    PaymentItem(
      label: 'JobReels App',
      amount: '1.00',
      status: PaymentItemStatus.final_price,
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: AppString.logIn,
          titleColor: Theme.of(context).primaryColorLight,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Theme.of(context).primaryColorLight,
                size: 16,
              )),
          tileColor: Theme.of(context).primaryColor,
        ),
        body: SingleChildScrollView(
          padding: MediaQuery.of(context).viewInsets,
          child: Column(
            children: [
              Container(
                width: context.width,
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                margin: EdgeInsets.zero,
                child: GetBuilder<AuthController>(builder: (authController) {
                  return Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(children: [
                      const SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_X_LARGE),
                      Image.asset(
                        Images.logo,
                        width: 150,
                        height: 150,
                      ),
                      const SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_X_LARGE),
                      Text(
                        AppString.logIn.tr,
                        style: montserratBold.copyWith(
                          fontSize: 25,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(
                              height: Dimensions.PADDING_SIZE_EXTRA_X_LARGE),

                          ///Email Address
                          CustomInputTextField(
                            controller: _emailController,
                            focusNode: _emailNoFocus,
                            isPassword: false,
                            context: context,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onFieldSubmit: (value) {
                              _passwordFocus.requestFocus();
                              return value;
                            },
                            labelText: AppString.email,
                            validator: (inputData) {
                              return inputData!.trim().isEmpty
                                  ? ErrorMessage.emailEmptyError
                                  : inputData.length > 250
                                      ? ErrorMessage.emailMaxLengthError
                                      : !validateEmail(inputData.trim())
                                          ? ErrorMessage.emailInvalidError
                                          : null;
                            },
                          ),
                          const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT),

                          /// Password TextField
                          CustomInputTextField(
                            maxLines: 1,
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            obscureText: hidePassword,
                            isPassword: true,
                            context: context,
                            labelText: AppString.password,
                            onFieldSubmit: (value) {
                              validateDataAndCallApi(authController);
                              return value;
                            },
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                icon: hidePassword
                                    ? Image.asset(
                                        Images.eye,
                                        height: 25,
                                        width: 25,
                                      )
                                    : Image.asset(Images.eyeHide,
                                        height: 25, width: 25)),
                            validator: (inputData) {
                              return inputData!.trim().isEmpty
                                  ? ErrorMessage.passwordEmptyError
                                  : inputData.length > 250
                                      ? ErrorMessage.passwordMaxLengthError
                                      : null;
                            },
                          ),
                          const SizedBox(
                              height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                          /// Server side error message
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  errorText,
                                  textAlign: TextAlign.start,
                                  style: montserratRegular.copyWith(
                                    color: Theme.of(context).errorColor,
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          /// Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Get.toNamed(
                                      RouteHelper.getForgetPasswordRoute());
                                },
                                child: Text(
                                  AppString.isForgotPassword,
                                  style: montserratBold.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomButton(
                                height: 50,
                                buttonText: isApiCalling
                                    ? AppString.pleaseWait.tr
                                    : AppString.logIn.tr,
                                onPressed: () async {
                                  validateDataAndCallApi(authController);
                                },
                              ),
                            ),
                          ]),
                      const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: CustomButton(
                                height: 50,
                                buttonText: AppString.signUp.tr,
                                onPressed: () async {
                                  Get.toNamed(RouteHelper.signUp);
                                },
                              ),
                            ),
                          ]),
                      const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                      // GooglePayButton(
                      //   paymentConfiguration: PaymentConfiguration.fromJsonString(googlePayConfig),
                      //   paymentItems: _paymentItems,
                      //   type: GooglePayButtonType.subscribe,
                      //   margin: const EdgeInsets.only(top: 15.0),
                      //   onPaymentResult: onGooglePayResult,
                      //   loadingIndicator: const Center(
                      //     child: CustomLoader(),
                      //   ),
                      // ),

                      const SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_X_LARGE),

                      // Container(
                      //   width: 90,
                      //   color: Colors.red,
                      //   child:  ApplePayButton(
                      //     paymentConfiguration: PaymentConfiguration.fromJsonString(applePayConfig),
                      //     paymentItems: _paymentItems,
                      //     style: ApplePayButtonStyle.black,
                      //     type: ApplePayButtonType.subscribe,
                      //     margin: const EdgeInsets.only(top: 15.0),
                      //     onPaymentResult: (Map<String, dynamic> result){
                      //       debugPrint("result of apple Pay:->> $result");
                      //     },
                      //     loadingIndicator: const Center(
                      //       child: CircularProgressIndicator(),
                      //     ),
                      //   ),
                      // ),
                    ]),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onGooglePayResult(paymentResult) {
    debugPrint("onGooglePayResult:-> $paymentResult");
  }

  void validateDataAndCallApi(
    AuthController authController,
  ) {
    if (errorText.isNotEmpty) {
      errorText = '';
      setState(() {});
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      _login(
        authController,
      );
    }
  }

  void _login(
    AuthController authController,
  ) async {
    isApiCalling = true;
    setState(() {});
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    await authController
        .login(
      email,
      password,
    )
        .then((Map<String, dynamic> result) {
      print("my login result is: ${result}");
      if (!result.containsKey(API_RESPONSE.SUCCESS)) {
        errorText =
            "${result[API_RESPONSE.ERROR] != null ? (result[API_RESPONSE.ERROR]['message']) : result[API_RESPONSE.EXCEPTION] ?? 'Something went wring'}";
        setState(() {});
      }
    });
    isApiCalling = false;
    setState(() {});
  }
}
