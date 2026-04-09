import 'package:glow_solar/controller/auth_controller.dart';
import 'package:glow_solar/util/dimensions.dart';
import 'package:glow_solar/view/base/custom_app_bar.dart';
import 'package:glow_solar/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glow_solar/view/base/custom_snackbar.dart';
import '../../../util/app_constants.dart';
import '../../../util/app_strings.dart';
import '../../../util/styles.dart';
import '../../base/my_text_field.dart';

class CreateOrChangePasswordScreen extends StatefulWidget {
  final bool isChangePassword;
  const CreateOrChangePasswordScreen({Key? key, required this.isChangePassword})
      : super(key: key);

  @override
  State<CreateOrChangePasswordScreen> createState() =>
      _CreateOrChangePasswordScreenState();
}

class _CreateOrChangePasswordScreenState
    extends State<CreateOrChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final FocusNode _oldPasswordFocus = FocusNode();
  final TextEditingController _oldPasswordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool hideOldPassword=true;
  bool hideNewPassword=true;
  bool hideConfirmPassword=true;

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
                                  AppString.createNewPassword.tr,
                                  style: montserratMedium.copyWith(fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  AppString.createNewPasswordToSignIn.tr,
                                  style: montserratRegular.copyWith(fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            Column(
                              children: [
                                /// Old Password if to change password
                                widget.isChangePassword
                                    ? CustomInputTextField(
                                  maxLines: 1,
                                  obscureText: hideOldPassword,
                                  controller: _oldPasswordController,
                                  focusNode: _oldPasswordFocus,
                                  isPassword: false,
                                  context: context,
                                  labelText: AppString.oldPassword,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hideOldPassword = !hideOldPassword;
                                      });
                                    },
                                    icon: hideOldPassword
                                        ? const Icon(Icons.visibility_off,)
                                        : const Icon(Icons.visibility,),
                                  ),
                                  validator: (inputData) {
                                    return inputData!.trim().isEmpty
                                        ? ErrorMessage.passwordEmptyError
                                        : inputData.length <
                                        AppConstants.PASSWORD_MIN_LENGTH
                                        ? ErrorMessage
                                        .passwordMinLengthError
                                        : inputData.length > 250
                                        ? ErrorMessage
                                        .passwordMaxLengthError
                                        : null;
                                  },
                                )
                                    : const SizedBox(),
                                SizedBox(
                                    height: widget.isChangePassword
                                        ? Dimensions.PADDING_SIZE_DEFAULT
                                        : 0),
                                /// New Password to change password
                                CustomInputTextField(
                                  maxLines: 1,
                                  obscureText: hideNewPassword,
                                  controller: _passwordController,
                                  focusNode: _passwordFocus,
                                  isPassword: false,
                                  context: context,
                                  labelText: AppString.password,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hideNewPassword = !hideNewPassword;
                                      });
                                    },
                                    icon: hideNewPassword
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
                                const SizedBox(
                                    height: Dimensions.PADDING_SIZE_DEFAULT),
                                /// Confirm Password to change password
                                CustomInputTextField(
                                  maxLines: 1,
                                  obscureText: hideConfirmPassword,
                                  controller: _confirmPasswordController,
                                  focusNode: _confirmPasswordFocus,
                                  isPassword: false,
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
                                    buttonText: AppString.createPassword.tr,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if(_confirmPasswordController.text.trim()!=_passwordController.text.trim()){
                                          showCustomSnackBar(
                                            ErrorMessage.confirmPasswordError,
                                          );
                                        }else{
                                          if(widget.isChangePassword){
                                            _changePassword(authController);
                                          }else{
                                            _forgetPas(authController);
                                          }
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

  void _changePassword(AuthController authController) async {
    String oldPassword= _oldPasswordController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    if (password != confirmPassword) {
      showCustomSnackBar(ErrorMessage.confirmPasswordError.tr);
    } else {
      authController.changePassword(oldPassword,password);
    }
  }

  void _forgetPas(AuthController authController) {
    String password = _passwordController.text.trim();
    FocusScope.of(context).unfocus();
    authController.resetPassword(password);
  }
}
