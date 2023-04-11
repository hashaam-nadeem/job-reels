
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workerapp/utils/dimensions.dart';
import '../../../controller/auth_controller.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/styles.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key,}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isRemember = false;
  bool hidePassword = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color fieldBackgroundColor = const Color(0xFF020B1B);
    return Scaffold(
      backgroundColor: fieldBackgroundColor,
      body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              width:context.width,
              height: context.height,
              color: fieldBackgroundColor,
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              child: GetBuilder<AuthController>(builder: (authController) {
                return Form(
                  key: _formKey,
                  child: Column(children: [
                    const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 46),
                        child: Image.asset(Images.pearlCare,)),
                    const SizedBox(height: 52),
                    CustomInputTextField(
                      controller: _userNameController,
                      isPassword: false,
                      context: context,
                      hintText: AppString.userName,
                      validator: (inputData) {
                        return inputData!.trim().isEmpty
                            ? ErrorMessage.emailEmptyError
                            : null;
                      },
                      suffixIcon: SizedBox(
                        height: 15,
                        width: 15,
                        child: Container(
                          margin: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.person,size: 25,color: const Color(0xFFFFFFFF).withOpacity(.60),),),
                      ),
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                    CustomInputTextField(
                      controller: _passwordController,
                      isPassword: hidePassword,
                      context: context,
                      hintText: AppString.password,
                      maxLines: 1,
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
                            : null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: (){
                            setState((){
                              isRemember = !isRemember;
                            });
                          },
                          child: Container(
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: isRemember ? const Center(child: Icon(Icons.done,size: 12,color: Colors.white,)): const SizedBox(),
                          ),
                        ),
                        const SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),
                        GestureDetector(
                          onTap: (){
                            setState((){
                              isRemember = !isRemember;
                            });
                          },
                          child: Text(AppString.keepMeLoggedIn.tr,
                            style: montserratRegular.copyWith(fontSize: 16,color: Colors.white),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: (){
                          },
                          child: Text(
                            AppString.isForgetPassword,
                            style: montserratRegular.copyWith(color: Theme.of(context).primaryColorLight),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                    !authController.isLoading
                        ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: CustomButton(
                              height: 48,
                              radius: 5,
                              buttonText: AppString.login.toUpperCase().tr,
                              onPressed: (){
                                if (_formKey.currentState!.validate()) {
                                  FocusScope.of(context).unfocus();
                                  _login(authController,);
                                }
                               // Get.offNamed(RouteHelper.getMainScreenRoute());
                              },
                            ),
                          ),
                        ])
                        : const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 30),
                  ]),
                );
              }),
            ),
          )),
    );
  }
  void _login(AuthController authController,) {
    String email = _userNameController.text.trim();
    String password = _passwordController.text.trim();
    authController.login(email, password);
  }
}
