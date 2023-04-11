import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workerapp/view/base/custom_app_bar.dart';

import '../../../controller/auth_controller.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/color_constants.dart';
import '../../base/custom_button.dart';
import '../../base/custom_text_field.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {

  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController addressEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackGroundColor,
      appBar: CustomAppBar(
        title: AppString.updateProfile,
        leading: IconButton(
          onPressed: (){},
          iconSize: 20,
          icon: const Icon(Icons.menu,color: Colors.white,),
        ),
      ),
      body: Container(
          width:context.width,
          height: context.height,
          color: AppColor.scaffoldBackGroundColor,
        child: GetBuilder<AuthController>(builder: (authController) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 35,),
                CustomInputTextField(
                  controller: nameEditingController,
                  context: context,
                  hintText: 'Name',
                  hasDecoration: false,
                ),
                const SizedBox(height: 10,),
                CustomInputTextField(
                  controller: phoneEditingController,
                  context: context,
                  hintText: 'Phone',
                  hasDecoration: false,
                ),
                const SizedBox(height: 10,),
                CustomInputTextField(
                  controller: addressEditingController,
                  context: context,
                  hintText: 'Address',
                  hasDecoration: false,
                ),
                const SizedBox(height: 30,),
                CustomButton(
                  onPressed: (){
                    updateProfile(authController);
                    setState((){});
                  },
                  spaceBetweenTextAndIcon: 70,
                  iconAtStart: false,
                  icon: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.arrow_forward_ios_rounded,color: Color(0xFF65DACC),size: 15,),
                  ),
                  buttonText:  "SAVE",
                  radius: 30,
                  width: 180,

                  color: const Color(0xFF65DACC),
                ),
              ],

            ),
          );
        }),

      ),
    );
  }
  void updateProfile(AuthController authController){
    String name=nameEditingController.text.trim();
    String phone=phoneEditingController.text.trim();
    String address=addressEditingController.text.trim();
    authController.updateProfile(name,phone,address,'');
  }
}
