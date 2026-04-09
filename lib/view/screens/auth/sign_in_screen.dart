import 'package:glow_solar/util/app_strings.dart';
import 'package:glow_solar/util/color_constants.dart';
import 'package:glow_solar/util/dimensions.dart';
import 'package:glow_solar/util/images.dart';
import 'package:glow_solar/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glow_solar/view/base/my_text_field.dart';
import '../../../controller/auth_controller.dart';
import '../../../helper/route_helper.dart';
import '../../base/custom_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  bool hidePassword=true;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _phoneNoFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
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
        body: SafeArea(
            child: Center(
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Center(
                    child: Container(
                      width: context.width,
                      padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      margin: EdgeInsets.zero,
                      child: GetBuilder<AuthController>(builder: (authController) {
                        return Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(children: [
                            Image.asset(Images.logo, width: 200),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                            Text(
                              AppString.signIn.tr,
                              style: montserratMedium.copyWith(fontSize: 25),
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
                                        ? ErrorMessage.emailMaxLengthError
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
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    icon: hidePassword
                                        ? const Icon(Icons.visibility_off,)
                                        : const Icon(Icons.visibility,),
                                  ),
                                  validator: (inputData) {
                                    return inputData!.trim().isEmpty
                                        ? ErrorMessage.passwordEmptyError
                                        : inputData.length > 250
                                        ? ErrorMessage.passwordMaxLengthError
                                        : null;
                                  },
                                ),
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
                                        style: montserratRegular.copyWith(
                                            color: Theme.of(context).primaryColorDark),
                                      ),
                                    ),
                                  ],
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
                                    buttonText: AppString.signIn.tr,
                                    onPressed: ()async {
                                      if (_formKey.currentState!.validate()) {
                                        FocusScope.of(context).unfocus();
                                        _login(authController,);
                                      }
                                    },
                                  ),
                                ]),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 100,
                                  child: Divider(
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    "OR",
                                    style: montserratRegular.copyWith(
                                        color: Theme.of(context).primaryColorDark),
                                  ),
                                ),
                                const SizedBox(
                                  width: 100,
                                  child: Divider(
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            TextButton(
                              onPressed: (){
                                Get.offNamed(RouteHelper.getSignUpRoute());
                              },
                              child: Text(
                                AppString.signUp,
                                style: montserratBold.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.primaryGradiantStart
                                ),
                              ),
                            ),
                          ]),
                        );
                      }),
                    ),
                  ),
                ),
              ),
            )),
        // bottomNavigationBar: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(
        //       AppString.doNotHaveAccount,
        //       style: montserratRegular,
        //     ),
        //     TextButton(
        //       onPressed: () {
        //         Get.offNamed(RouteHelper.getSignUpRoute());
        //       },
        //       child: Text(
        //         AppString.signUp,
        //         style: montserratRegular,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  void _login(AuthController authController,) {
    String phoneNo = _phoneNoController.text.trim();
    String password = _passwordController.text.trim();
    String countryCode = "+1";
    authController.login(phoneNo, password,countryCode);
  }
}
