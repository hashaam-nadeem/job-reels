import 'package:jobreels/util/app_strings.dart';
import 'package:jobreels/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/view/base/custom_app_bar.dart';
import 'package:jobreels/view/screens/auth/widget/freelancer_registration_update_form.dart';
import 'package:jobreels/view/screens/auth/widget/hirer_registration_and_update_form.dart';
import '../../base/custom_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    // print("emplue: ${AppString.signUpAsEmployee.tr}");
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: AppString.signUp,
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
        body: Container(
          height: context.height,
          padding: EdgeInsets.symmetric(horizontal: context.width * 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                width: context.width,
                onPressed: () {
                  Get.to(() => const FreeLancerRegisterUpdateScreen());
                },
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorLight,
                  border: Border.all(color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                textColor: Theme.of(context).primaryColor,
                buttonText: AppString.iAmLookingForWork,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  AppString.or,
                  style: montserratBold.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 19,
                  ),
                ),
              ),
              CustomButton(
                width: context.width,
                onPressed: () {
                  Get.to(() => const HirerRegisterUpdateScreen());
                },
                height: 60,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                buttonText: AppString.iAmLookingToHireSomeone,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
