import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workerapp/controller/auth_controller.dart';
import 'package:workerapp/data/model/response/userInfo_model.dart';
import 'package:workerapp/utils/app_images.dart';
import 'package:workerapp/utils/styles.dart';
import 'package:workerapp/view/base/custom_button.dart';
import 'package:workerapp/view/base/custom_text_field.dart';
import '../../../../utils/app_strings.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  bool hidePassword=true;
  bool isProfileDataViewActive = true;
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController phoneEditingController = TextEditingController();
  TextEditingController addressEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  UserInfoModel? userInfoModel;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    userInfoModel=Get.find<AuthController>().userInfoModel;
    nameEditingController.text=userInfoModel?.name??"";
    emailEditingController.text=userInfoModel?.email??"";
    phoneEditingController.text=userInfoModel?.phone??"";
    addressEditingController.text=userInfoModel?.address??"";
    passwordEditingController.text=Get.find<AuthController>().authRepo.getUserPassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isProfileDataViewActive
            ? profileDataView()
            : profileDataEditWidget(),
        const SizedBox(height: 10,),
        Text(
          "Leave empty if no change required",
          style: montserratRegular.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF222B45),
          ),
        ),
        const SizedBox(height: 25,),
        CustomButton(
            onPressed: isProfileDataViewActive
                ?(){
              isProfileDataViewActive = !isProfileDataViewActive;
              setState((){});

            }
                :() async {
              if (_formKey.currentState!.validate()) {
               await Get.find<AuthController>().updateProfile(nameEditingController.text,phoneEditingController.text,addressEditingController.text,passwordEditingController.text);
                isProfileDataViewActive = !isProfileDataViewActive;
                setState((){});
              }
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
            buttonText: isProfileDataViewActive? "EDIT": "SAVE",
          radius: 30,
          width: 180,

          color: const Color(0xFF65DACC),
        ),
        const SizedBox(height: 10,),
      ],
    );
  }
  Widget profileDataView(){
    return Padding(
      padding: const EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFFFFF),
            ),
            child: Column(
              children: [
                const SizedBox(height: 5,),
                TileWidget(
                  leadingImage: Images.halfProfile,
                  title: 'Full Name',
                  subTitle: userInfoModel?.name,
                  trailing: null,
                  onTap: (){},
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Divider(),
                ),
                TileWidget(
                  leadingImage: Images.passwordLock,
                  title: 'Password',
                  subTitle: "************",
                  trailing: Images.passwordAttitude,
                  onTap: (){},
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Divider(),
                ),
                TileWidget(
                  leadingImage: Images.email,
                  title: 'Email Address',
                  subTitle: userInfoModel?.email,
                  trailing: Images.verified,
                  onTap: (){},
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Divider(),
                ),
                TileWidget(
                  leadingImage: Images.mobile,
                  title: 'Phone',
                  subTitle: userInfoModel?.phone,
                  trailing: Images.phoneInfo,
                  onTap: (){},
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Divider(),
                ),
                TileWidget(
                  leadingImage: Images.shipping,
                  title: 'Address',
                  subTitle: userInfoModel?.address,
                  trailing: null,
                  onTap: (){},
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Divider(),
                ),
                TileWidget(
                  leadingImage: Images.notificationSetting,
                  title: 'Notification Settings',
                  subTitle: null,
                  trailing: null,
                  onTap: (){},
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Divider(),
                ),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget profileDataEditWidget(){
    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 5,),
            CustomInputTextField(
              controller: nameEditingController,
              context: context,
              hintText: 'Name',
              hasDecoration: false,
              validator: (inputData) {
                return inputData!.trim().isEmpty
                    ? ErrorMessage.nameEmptyError
                    : inputData.length > 250
                    ? ErrorMessage.addressLengthError
                    : null;
              },
            ),
            const SizedBox(height: 10,),
            CustomInputTextField(
              controller: emailEditingController,
              context: context,
              readOnly: true,
              hintText: 'Email',
              hasDecoration: false,
            ),
            const SizedBox(height: 10,),
            CustomInputTextField(
              controller: phoneEditingController,
              context: context,
              hintText: 'Phone',
              hasDecoration: false,
              validator: (inputData) {
                return inputData!.trim().isEmpty
                    ? ErrorMessage.phoneEmptyError
                    : inputData.length > 250
                    ? ErrorMessage.addressLengthError
                    : null;
              },
            ),
            const SizedBox(height: 10,),
            CustomInputTextField(
              controller: addressEditingController,
              context: context,
              hintText: 'Address',
              hasDecoration: false,
              validator: (inputData) {
                return inputData!.trim().isEmpty
                    ? ErrorMessage.addressEmptyError
                    : inputData.length > 250
                    ? ErrorMessage.addressLengthError
                    : null;
              },
            ),
            const SizedBox(height: 10,),
            CustomInputTextField(
              controller: passwordEditingController,
              context: context,
              hintText: 'Password',
              hasDecoration: false,
              isPassword: hidePassword,
              maxLines: 1,
              isShowLabel:true,
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
                    : inputData.length < 8
                    ? ErrorMessage.passwordLengthError
                    : null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TileWidget extends StatelessWidget {
  final String leadingImage;
  final String title;
  final String ?subTitle;
  final String ?trailing;
  final void Function() ?onTap;
  const TileWidget({
    Key? key,
    required this.leadingImage,
    required this.title,
    required this.subTitle,
    required this.trailing,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = const Color(0xFF515C6F);
    return InkWell(
      onTap: (){
        debugPrint("$title pressed");
        if(onTap!=null){
          onTap!();
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
        child: Row(
          children: [
            Image.asset(leadingImage,width: 20,height: 20,),
            const SizedBox(width: 20,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,style: montserratRegular.copyWith(fontSize: 15,fontWeight: FontWeight.w400,color: textColor),),
                  subTitle==null
                      ?const SizedBox()
                      : Text(subTitle!,style: montserratRegular.copyWith(fontSize: 13,fontWeight: FontWeight.w400,color: textColor),),
                ],
              ),
            ),
            const SizedBox(width: 10,),
            trailing!=null
                ? Image.asset(trailing!,width: 20, height: 18,)
                : const SizedBox(),
            SizedBox(width: trailing!=null?10:0,),
            Image.asset(
              Images.arrow,
              width: 20,
              height: 18,
            )
          ],
        ),
      ),
    );
  }
}

