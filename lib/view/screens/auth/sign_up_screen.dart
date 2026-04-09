import 'package:glow_solar/util/dimensions.dart';
import 'package:glow_solar/util/images.dart';
import 'package:glow_solar/util/styles.dart';
import 'package:glow_solar/view/base/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/auth_controller.dart';
import '../../../helper/route_helper.dart';
import '../../../util/app_constants.dart';
import '../../../util/app_strings.dart';
import '../../../util/color_constants.dart';
import '../../base/custom_button.dart';
import '../../base/my_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneNoFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
   bool hidePassword = true;
   bool hideConfirmPassword=true;

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
                              AppString.signUp.tr,
                              style: montserratMedium.copyWith(fontSize: 25),
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            Column(
                              children: [
                                /// Name Field
                                CustomInputTextField(
                                  controller: _nameController,
                                  focusNode: _nameFocus,
                                  isPassword: false,
                                  context: context,
                                  labelText: AppString.name,
                                  validator: (inputData) {
                                    return inputData!.trim().isEmpty
                                        ? ErrorMessage.nameEmptyError
                                        : inputData.length > 250
                                        ? ErrorMessage.nameMaxLengthError
                                        : null;
                                  },
                                ),
                                const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                                /// Email Field
                                CustomInputTextField(
                                  controller: _emailController,
                                  focusNode: _emailFocus,
                                  isPassword: false,
                                  context: context,
                                  labelText: AppString.email,
                                  validator: (inputData) {
                                    return inputData!.trim().isEmpty
                                        ? ErrorMessage.emailEmptyError
                                        : !RegExp(AppString.emailFormat)
                                        .hasMatch(inputData.trim())
                                        ? ErrorMessage.emailInvalidError
                                        : inputData.length > 250 ||
                                        !RegExp(AppString.emailFormat)
                                            .hasMatch(inputData.trim())
                                        ? ErrorMessage.emailMaxLengthError
                                        : null;
                                  },
                                ),
                                const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
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
                                        ? ErrorMessage.phoneMaxLengthError
                                        : null;
                                  },
                                ),
                                const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                                /// Password Field
                                CustomInputTextField(
                                  maxLines: 1,
                                  obscureText: hidePassword,
                                  controller: _passwordController,
                                  focusNode: _passwordFocus,
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
                                    return inputData!.isEmpty
                                        ? ErrorMessage.passwordEmptyError
                                        : inputData.length <
                                        AppConstants.PASSWORD_MIN_LENGTH
                                        ? ErrorMessage.passwordMinLengthError
                                        : inputData.length > 250
                                        ? ErrorMessage.passwordMaxLengthError
                                        : null;
                                  },
                                ),
                                const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                                /// Confirm Password Field
                                CustomInputTextField(
                                  maxLines: 1,
                                  obscureText: hideConfirmPassword,
                                  controller: _confirmPasswordController,
                                  focusNode: _confirmPasswordFocus,
                                  isPassword: true,
                                  context: context,
                                  labelText: AppString.confirmPassword,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hideConfirmPassword = !hideConfirmPassword;
                                      });
                                    },
                                    icon: hideConfirmPassword
                                        ? const Icon(Icons.visibility_off,)
                                        : const Icon(Icons.visibility,),
                                  ),
                                  validator: (inputData) {
                                    return inputData!.trim().isEmpty
                                        ? ErrorMessage.passwordEmptyError
                                        : inputData.length <
                                        AppConstants.PASSWORD_MIN_LENGTH
                                        ? ErrorMessage.passwordMinLengthError
                                        : inputData.length > 250
                                        ? ErrorMessage.passwordMaxLengthError
                                        : null;
                                  },
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
                                    buttonText: AppString.signUp.tr,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _register(authController);
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
                                Get.offNamed(RouteHelper.getSignInRoute());
                              },
                              child: Text(
                                AppString.signIn,
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
        //       AppString.alreadyHaveAccount,
        //       style: montserratRegular,
        //     ),
        //     TextButton(
        //       onPressed: () {
        //         Get.offNamed(RouteHelper.getSignInRoute());
        //       },
        //       child: Text(
        //         AppString.signIn,
        //         style: montserratRegular,
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  void _register(AuthController authController) {
    String name = _nameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String phoneNo = _phoneNoController.text.trim();
    String confirmPassword=_confirmPasswordController.text.trim();
    String countryCode="+1";
    if (password != confirmPassword) {
      showCustomSnackBar(ErrorMessage.confirmPasswordError.tr);
    } else {
      authController.signUp(email, password, name,phoneNo,countryCode);
    }
  }
}
