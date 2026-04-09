import 'dart:core';
import 'dart:io';
import 'package:dio/dio.dart' as ApiClient;
import 'package:camera/camera.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:http_parser/http_parser.dart';
import 'package:jobreels/data/model/helpers.dart';
import 'package:jobreels/data/model/response/state_city_model.dart';
import 'package:jobreels/data/model/response/user.dart';
import 'package:jobreels/enums/country.dart';
import 'package:jobreels/enums/validation_type.dart';
import 'package:jobreels/helper/helper.dart';
import 'package:jobreels/util/app_constants.dart';
import 'package:jobreels/util/app_strings.dart';
import 'package:jobreels/util/dimensions.dart';
import 'package:jobreels/util/images.dart';
import 'package:jobreels/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/view/base/custom_app_bar.dart';
import 'package:jobreels/view/base/custom_loader.dart';
import 'package:jobreels/view/base/custom_snackbar.dart';
import 'package:jobreels/view/base/custom_toast.dart';
import 'package:jobreels/view/base/document_image_selection_widget.dart';
import 'package:jobreels/view/base/drop_down_selection_widget.dart';
import 'package:jobreels/view/base/my_text_field.dart';
import 'package:jobreels/view/base/popup_alert.dart';
import 'package:jobreels/view/screens/auth/widget/register_otp_verification_screen.dart';
import 'package:jobreels/view/screens/delete%20account/delete_account.dart';
import '../../../../controller/auth_controller.dart';
import '../../../../controller/state_controller.dart';
import '../../../../data/api/Api_Handler/api_error_response.dart';
import '../../../../enums/gender.dart';
import '../../../base/CustomImagePicker/Utils/utils.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_drop_down_item.dart';
import '../../../base/custom_image.dart';
import '../../../base/social_media_links_text_form_fields.dart';
import '../../webview/webview_screen.dart';

class FreeLancerRegisterUpdateScreen extends StatefulWidget {
  const FreeLancerRegisterUpdateScreen({Key? key}) : super(key: key);

  @override
  FreeLancerRegisterUpdateScreenState createState() =>
      FreeLancerRegisterUpdateScreenState();
}

class FreeLancerRegisterUpdateScreenState
    extends State<FreeLancerRegisterUpdateScreen> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _firstnameFocusNode = FocusNode();
  final FocusNode _lastnameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _portfolioFocus = FocusNode();
  final FocusNode _jobTitleFocus = FocusNode();
  final FocusNode _bioFocus = FocusNode();
  final FocusNode _salaryRequirementsFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _portfolioController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _salaryRequirementsController =
      TextEditingController();
  TextEditingController upworkTextController = TextEditingController();
  TextEditingController fiverrTextController = TextEditingController();
  TextEditingController linkedInTextController = TextEditingController();
  TextEditingController instagramTextController = TextEditingController();
  TextEditingController facebookTextController = TextEditingController();
  TextEditingController youtubeTextController = TextEditingController();
  TextEditingController tiktokTextController = TextEditingController();
  TextEditingController twitterTextController = TextEditingController();
  XFile? profilePhoto;
  String? profilePhotoUrl;
  XFile? govtPhotoIdFront;
  String? govtPhotoIdFrontUrl;
  XFile? govtPhotoIdBack;
  String? govtPhotoIdBackUrl;
  XFile? govtWithHoldingPhotoId;
  String? govtWithHoldingPhotoIdUrl;
  String emailErrorText = '';
  String phoneErrorText = '';
  String errorText = '';
  bool isApiCalling = false;
  int currentFormNumber = 1;
  StateClass? selectedProvince;
  String? selectedCity;
  String? selectedAvailability;
  String? selectedYearsOfExperience;
  Gender? selectedGender;
  List<CustomDropdownMenuItem<Skill>> skillsDropDownList =
      <CustomDropdownMenuItem<Skill>>[];
  List<String> selectedSkills = <String>[];
  ValueListenable<bool> removeOverLayEntry = ValueNotifier(false);
  ValueListenable<bool> isResetSelection = ValueNotifier(false);
  String provinceErrorMessage = '';
  String cityErrorMessage = '';
  final GlobalKey<CustomDropDownState> _provinceKey = GlobalKey();
  final GlobalKey<CustomDropDownState> _cityKey = GlobalKey();
  bool isEmailHide = false;
  bool isPhoneNoHide = false;
  bool isTermsAndConditions = false;

  DateTime dateOfBirth = DateTime.now();
  bool isStep1Validated = false;
  bool isStep2Validated = false;
  bool isStep3Validated = false;
  bool isStep4Validated = false;
  bool isEditProfile = false;
  bool isStatesFetched = false;

  @override
  void initState() {
    isEditProfile = Get.find<AuthController>().authRepo.isLoggedIn();
    isStatesFetched = !isEditProfile;
    String formattedDate = dateFormat.format(dateOfBirth);
    if (!isEditProfile) {
      _dateOfBirthController.text = formattedDate;
    }
    Get.find<StateController>()
        .getStateList(Country.Philippines)
        .then((List<StateClass> stateList) {
      if (mounted && isEditProfile) {
        for (StateClass province in stateList) {
          if (province.stateName ==
              Get.find<AuthController>().getLoginUserData()?.state) {
            selectedProvince = province;
            for (String city in province.stateCities) {
              selectedCity = city;
              break;
            }
            break;
          }
        }
        isStatesFetched = true;
        setState(() {});
      }
    });
    skillsDropDownList.addAll(skillList
        .map((skill) => CustomDropdownMenuItem(
              value: skill,
              child: Text(
                skill.value,
                style: montserratRegular,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ))
        .toList());
    if (isEditProfile) {
      _setFieldsInCaseOfUpdateProfile();
    }

    _emailFocusNode.addListener(emailFocusListener);
    _phoneNumberFocusNode.addListener(phoneNumberFocusListener);
    super.initState();
  }

  void emailFocusListener() {
    if (!_emailFocusNode.hasFocus) {
      debugPrint(
          "_emailFocusNode.hasFocus in If:->> ${_emailFocusNode.hasFocus}");
      checkEmailOrPhoneValidation(_emailController.text, ValidationType.email);
    }
  }

  void phoneNumberFocusListener() {
    if (!_phoneNumberFocusNode.hasFocus) {
      checkEmailOrPhoneValidation(
          _phoneNumberController.text, ValidationType.phone);
    }
  }

  checkEmailOrPhoneValidation(String value, ValidationType type) {
    if (value.trim().isNotEmpty) {
      Get.find<AuthController>()
          .checkEmailOrPhoneValidation(type, value)
          .then((result) {
        if (result.containsKey(API_RESPONSE.ERROR)) {
          try {
            if (type == ValidationType.email) {
              emailErrorText = result[API_RESPONSE.ERROR]['errors']['email'][0];
            } else {
              phoneErrorText = result[API_RESPONSE.ERROR]['errors']['phone'][0];
            }
          } catch (e) {}
        } else {
          if (type == ValidationType.email) {
            emailErrorText = "";
          } else {
            phoneErrorText = "";
          }
        }
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        removeOverLayEntry = ValueNotifier(true);
        setState(() {});
        FocusScope.of(context).unfocus();
        Future.delayed(const Duration(milliseconds: 300)).then((value) {
          removeOverLayEntry = ValueNotifier(false);
          setState(() {});
        });
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () async {
          onBackButtonPressed();
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: CustomAppBar(
            title:
                isEditProfile ? AppString.editProfile : AppString.registration,
            titleColor: Theme.of(context).primaryColorLight,
            leading: IconButton(
              onPressed: () {
                onBackButtonPressed();
              },
              icon: Icon(
                isEditProfile ? Icons.arrow_back_ios : FontAwesome.close,
                color: Theme.of(context).primaryColorLight,
                size: 16,
              ),
            ),
            tileColor: Theme.of(context).primaryColor,
          ),
          body: SingleChildScrollView(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              width: context.width,
              padding:
                  const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_X_LARGE),
              margin: EdgeInsets.zero,
              child: isStatesFetched
                  ? GetBuilder<AuthController>(builder: (authController) {
                      return Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!isEditProfile)
                              Text(
                                AppString.signUpAsEmployee.tr,
                                style: montserratSemiBold.copyWith(
                                  fontSize: 25,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            if (!isEditProfile)
                              const SizedBox(
                                  height: Dimensions.PADDING_SIZE_DEFAULT),
                            SizedBox(
                              width: 250,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  stepFormWidget(1),
                                  stepLine(),
                                  stepFormWidget(2),
                                  stepLine(),
                                  stepFormWidget(3),
                                  stepLine(),
                                  stepFormWidget(4),
                                ],
                              ),
                            ),
                            const SizedBox(
                                height: Dimensions.PADDING_SIZE_EXTRA_X_LARGE),
                            currentFormNumber == 1
                                ? step1Form(authController)
                                : currentFormNumber == 2
                                    ? step2Form()
                                    : currentFormNumber == 3
                                        ? step3Form()
                                        : step4Form(),

                            /// Server side error message
                            Row(
                              children: [
                                Flexible(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 0),
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
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),
                            isEditProfile
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      /// Previous Button

                                      currentFormNumber > 1
                                          ? InkWell(
                                              onTap: () {
                                                currentFormNumber--;
                                                errorText = "";
                                                setState(() {});
                                              },
                                              radius: 50,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(Feather.arrow_left,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            )
                                          : const IconButton(
                                              onPressed: null,
                                              icon: SizedBox()),
                                      const SizedBox(
                                        width: 10,
                                      ),

                                      /// Next or Submit Button
                                      CustomButton(
                                        height: 50,
                                        onPressed: () {
                                          print(
                                              "isTermsAndConditions.........>$isTermsAndConditions");
                                          print(
                                              "isEditProfile.........>$isEditProfile");

                                          validateDataAndCallApi(
                                              authController);
                                        },
                                        buttonText: AppString.submit,
                                        width: 120,
                                        radius: 50,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      currentFormNumber < 4
                                          ? InkWell(
                                              onTap: () {
                                                if (_validateForm()) {
                                                  currentFormNumber++;
                                                  setState(() {});
                                                }
                                              },
                                              radius: 50,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .primaryColor),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(Feather.arrow_right,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                              ),
                                            )
                                          : const IconButton(
                                              onPressed: null,
                                              icon: SizedBox()),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      /// Previous Button
                                      if (currentFormNumber > 1)
                                        CustomButton(
                                          onPressed: () {
                                            currentFormNumber--;
                                            errorText = "";
                                            setState(() {});
                                          },
                                          buttonText: AppString.previous,
                                          textColor:
                                              Theme.of(context).primaryColor,
                                          width: 120,
                                          radius: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .primaryColorLight,
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                        ),
                                      const SizedBox(
                                        width: 10,
                                      ),

                                      /// Next or Submit Button
                                      CustomButton(
                                        height: 50,
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          if (currentFormNumber < 4) {
                                            if (_validateForm()) {
                                              currentFormNumber++;
                                              setState(() {});
                                            }
                                          } else {
                                            validateDataAndCallApi(
                                                authController);
                                          }
                                        },
                                        buttonText: currentFormNumber == 4
                                            ? AppString.submit
                                            : AppString.next,
                                        width: 120,
                                        radius: 50,
                                      )
                                    ],
                                  ),
                            const SizedBox(
                              height: Dimensions.PADDING_SIZE_DEFAULT,
                            ),
                            if (isEditProfile)
                              TextButton(
                                onPressed: () {
                                  Get.to(() => const DeleteAccount());
                                },
                                child: Text(
                                  "Delete my account",
                                  style: montserratRegular.copyWith(
                                    color: Theme.of(context).errorColor,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    })
                  : SizedBox(
                      height: context.height * 0.75,
                      width: context.width,
                      child: const Center(
                        child: CustomLoader(),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onBackButtonPressed() async {
    FocusScope.of(context).unfocus();
    await showPopUpAlert(
        popupObject: PopupObject(
      title: "Confirmation",
      body: "Are you sure you want to leave? This will close all signup pages.",
      buttonText: null,
      onYesPressed: () {
        Get.back();
        Get.back();
      },
    ));
  }

  Widget step1Form(AuthController authController) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (isEditProfile)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async {
                File? selectedImage = await getImage(true);
                if (selectedImage != null) {
                  profilePhoto = XFile(selectedImage.path);
                  setState(() {});
                  // ApiClient.FormData formData = ApiClient.FormData.fromMap({
                  //   "profile_picture": await getMultiPartFile(pickedFile: profilePhoto!),
                  // });
                  // authController.updateFreelancerProfileImage(formData);
                }
              },
              child: Stack(
                children: [
                  Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          shape: BoxShape.circle),
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.symmetric(
                          vertical: Dimensions.RADIUS_DEFAULT),
                      child: profilePhoto != null
                          ? Image.file(
                              File(profilePhoto!.path),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                          : CustomImage(
                              image: profilePhotoUrl!,
                              isProfileImage: false,
                              height: 150,
                              width: context.width,
                              key: Key(profilePhotoUrl!),
                            )),
                  Positioned(
                      bottom: 10,
                      right: 10,
                      child: Material(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 5,
                        color: Theme.of(context).primaryColorLight,
                        child: Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorLight,
                              shape: BoxShape.circle),
                          child: Icon(
                            MaterialCommunityIcons.image_edit,
                            size: 22,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      if (isEditProfile)
        const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),

      /// First Name and Last Name
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// First Name
          Expanded(
            child: CustomInputTextField(
              controller: _firstNameController,
              focusNode: _firstnameFocusNode,
              isPassword: false,
              context: context,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onFieldSubmit: (value) {
                _lastnameFocusNode.requestFocus();
                return value;
              },
              labelText: AppString.firstNameRequired,
              validator: (inputData) {
                return inputData!.trim().isEmpty
                    ? ErrorMessage.firstNameEmptyError
                    : inputData.length > 250
                        ? ErrorMessage.firstNameMaxLengthError
                        : null;
              },
            ),
          ),
          const SizedBox(
            width: 10,
          ),

          /// Last Name
          Expanded(
            child: CustomInputTextField(
              controller: _lastNameController,
              focusNode: _lastnameFocusNode,
              isPassword: false,
              context: context,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              onFieldSubmit: (value) {
                _emailFocusNode.requestFocus();
                return value;
              },
              labelText: AppString.lastNameRequired,
              validator: (inputData) {
                return inputData!.trim().isEmpty
                    ? ErrorMessage.lastNameEmptyError
                    : inputData.length > 250
                        ? ErrorMessage.lastMaxLengthError
                        : null;
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      ///Email Address
      CustomInputTextField(
        controller: _emailController,
        focusNode: _emailFocusNode,
        isPassword: false,
        readOnly: isEditProfile,
        context: context,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onValueChange: (value) {
          if (emailErrorText.isNotEmpty) {
            emailErrorText = "";
            setState(() {});
          }
          return value;
        },
        labelText: AppString.emailRequired,
        validator: (inputData) {
          return emailErrorText.isNotEmpty
              ? null
              : inputData!.trim().isEmpty
                  ? ErrorMessage.emailEmptyError
                  : inputData.length > 250
                      ? ErrorMessage.emailMaxLengthError
                      : !validateEmail(inputData.trim())
                          ? ErrorMessage.emailInvalidError
                          : null;
        },
      ),
      // Container(
      //   color: Colors.yellowAccent,
      //   child: CheckboxListTile(
      //     activeColor: Theme.of(context).primaryColor,
      //     contentPadding: const EdgeInsets.all(0),
      //     title: const Text("Hide email on profile"),
      //     value: isEmailHide,
      //     onChanged: (newValue) {
      //       isEmailHide=newValue!;
      //       setState(() {});
      //     },
      //     controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
      //   ),
      // ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CustomCheckboxWithText(
          label: 'Hide email on profile',
          onChanged: (value) {
            // Handle checkbox state changes here
            isEmailHide = value;
            setState(() {
              print('isEmailHide: $isEmailHide');
            });
          },
          initialValue: isEmailHide,
        ),
      ),

      /// Server email validation error
      if (emailErrorText.isNotEmpty)
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 8),
                child: Text(
                  emailErrorText,
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
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      ///Phone Number
      CustomInputTextField(
        controller: _phoneNumberController,
        focusNode: _phoneNumberFocusNode,
        isPassword: false,
        readOnly: isEditProfile,
        context: context,
        keyboardType: getKeyboardTypeForDigitsOnly(),
        textInputAction: TextInputAction.next,
        onValueChange: (value) {
          if (phoneErrorText.isNotEmpty) {
            phoneErrorText = "";
            setState(() {});
          }
          return value;
        },
        prefixIcon: Padding(
          padding:
              const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                Images.phFlag,
                width: 40,
                height: 20,
              ),
              Text(
                " +63",
                textAlign: TextAlign.start,
                style: montserratRegular.copyWith(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        hintText: '1234567890',
        inputFormatters: [
          FilteringTextInputFormatter.allow(maximumLengthFormatter(10)),
        ],
        labelText: AppString.phoneNumberRequired,
        validator: (inputData) {
          return inputData!.trim().isEmpty
              ? ErrorMessage.phoneNoEmptyError
              : validatePhoneNumber(inputData.trim())
                  ? ErrorMessage.phoneNoInvalidError
                  : inputData.length > 250
                      ? ErrorMessage.phoneMaxLengthError
                      : null;
        },
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CustomCheckboxWithText(
          initialValue: isPhoneNoHide,
          label: 'Hide Phone number on profile',
          onChanged: (value) {
            // Handle checkbox state changes here
            isPhoneNoHide = value;
            setState(() {
              print('isPhoneNoHide: $isPhoneNoHide');
            });
          },
        ),
      ),

      /// Server phone validation error
      if (phoneErrorText.isNotEmpty)
        Row(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 8),
                child: Text(
                  phoneErrorText,
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
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      /// Password TextField
      if (!isEditProfile)
        CustomInputTextField(
          maxLines: 1,
          controller: _passwordController,
          focusNode: _passwordFocus,
          obscureText: hidePassword,
          isPassword: true,
          context: context,
          textInputAction: TextInputAction.next,
          labelText: AppString.passwordRequired,
          onFieldSubmit: (value) {
            _confirmPasswordFocus.requestFocus();
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
                  : Image.asset(Images.eyeHide, height: 25, width: 25)),
          validator: (inputData) {
            return inputData!.trim().isEmpty
                ? ErrorMessage.passwordEmptyError
                : !passwordCombinationValidator(inputData)
                    ? ErrorMessage.passwordCombinationInvalidError
                    : inputData.length > 250
                        ? ErrorMessage.passwordMaxLengthError
                        : null;
          },
        ),
      if (!isEditProfile)
        const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      /// Confirm Password TextField
      if (!isEditProfile)
        CustomInputTextField(
          maxLines: 1,
          controller: _confirmPasswordController,
          focusNode: _confirmPasswordFocus,
          obscureText: hideConfirmPassword,
          isPassword: true,
          context: context,
          labelText: AppString.confirmPasswordRequired,
          onFieldSubmit: (value) {
            return value;
          },
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hideConfirmPassword = !hideConfirmPassword;
                });
              },
              icon: hideConfirmPassword
                  ? Image.asset(
                      Images.eye,
                      height: 25,
                      width: 25,
                    )
                  : Image.asset(Images.eyeHide, height: 25, width: 25)),
          validator: (inputData) {
            return inputData!.trim().isEmpty
                ? ErrorMessage.passwordEmptyError
                : inputData.trim() != _passwordController.text.trim()
                    ? ErrorMessage.passwordMissMatchError
                    : inputData.length > 250
                        ? ErrorMessage.passwordMaxLengthError
                        : null;
          },
        ),
      if (!isEditProfile)
        const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      /// Province Selection DropDown
      isStatesFetched
          ? GetBuilder(builder: (StateController stateController) {
              return GestureDetector(
                onTap: !stateController.isDataFetching
                    ? null
                    : () {
                        showCustomSnackBar('Fetching state list');
                      },
                child: DropDownWidget(
                  title: "Province",
                  errorMessage: provinceErrorMessage,
                  key: _provinceKey,
                  initialSelectedIndex: selectedProvince != null
                      ? stateController.stateList.indexOf(selectedProvince!)
                      : -1,
                  isRemoveOverLayEntry: removeOverLayEntry,
                  dropDownItems: stateController.stateList
                      .map((state) => CustomDropdownMenuItem(
                            value: state,
                            child: Text(
                              state.stateName,
                              style: montserratRegular,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ))
                      .toList(),
                  onChange: (int index, dynamic val) {
                    if (selectedProvince != val) {
                      selectedProvince = val;
                      if (selectedProvince != null) {
                        provinceErrorMessage = "";
                        isResetSelection = ValueNotifier(true);
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 200))
                            .then((value) {
                          isResetSelection = ValueNotifier(false);
                        });
                      }
                    }
                  },
                  isResetSelection: null,
                ),
              );
            })
          : const SizedBox(),
      if (isStatesFetched)
        const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      /// City Selection Drop down
      if (isStatesFetched)
        GestureDetector(
          onTap: (selectedProvince?.stateCities.isNotEmpty ?? false)
              ? null
              : () {
                  provinceErrorMessage = "Select province first.";
                  setState(() {});
                },
          child: DropDownWidget(
              title: AppString.cityRequired,
              errorMessage: cityErrorMessage,
              key: _cityKey,
              initialSelectedIndex: selectedCity != null
                  ? selectedProvince?.stateCities.indexOf(selectedCity!) ?? -1
                  : -1,
              isResetSelection: isResetSelection,
              isRemoveOverLayEntry: removeOverLayEntry,
              dropDownItems: selectedProvince == null
                  ? []
                  : selectedProvince!.stateCities
                      .map((city) => CustomDropdownMenuItem(
                            value: city,
                            child: Text(
                              city,
                              style: montserratRegular,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ))
                      .toList(),
              onChange: (int index, dynamic val) {
                selectedCity = val;
                if (selectedCity != null) {
                  cityErrorMessage = "";
                  try {
                    setState(() {});
                  } catch (e) {}
                }
              }),
        ),
      if (isStatesFetched)
        const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      /// Address
      CustomInputTextField(
        controller: _addressController,
        focusNode: _addressFocus,
        isPassword: false,
        context: context,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        labelText: AppString.addressRequired,
        validator: (inputData) {
          return inputData!.trim().isEmpty
              ? ErrorMessage.addressEmptyError
              : inputData.length > 250
                  ? ErrorMessage.addressMaxLengthError
                  : null;
        },
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      /// Gender
      DropDownWidget(
          title: AppString.genderOptional,
          errorMessage: '',
          hintText: 'Select Gender',
          isResetSelection: null,
          isRemoveOverLayEntry: removeOverLayEntry,
          initialSelectedIndex: selectedGender == null
              ? -1
              : selectedGender == Gender.Male
                  ? 0
                  : selectedGender == Gender.Female
                      ? 1
                      : 2,
          dropDownItems: [Gender.Male, Gender.Female, Gender.other]
              .map((gender) => CustomDropdownMenuItem(
                    value: gender,
                    child: Text(
                      gender == Gender.other
                          ? "Prefer not to say"
                          : gender.name,
                      style: montserratRegular,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ))
              .toList(),
          onChange: (int index, dynamic val) {
            selectedGender = val;
            // setState(() {});
          }),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      Text(
        AppString.dateOfBirthOptional,
        style: montserratRegular.copyWith(
          fontSize: 16,
          color: Theme.of(context).primaryColor,
        ),
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      GestureDetector(
        onTap: () {
          selectDob(context);
        },
        child: CustomInputTextField(
          controller: _dateOfBirthController,
          focusNode: null,
          context: context,
          readOnly: true,
        ),
      ),
    ]);
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(emailFocusListener);
    _phoneNumberFocusNode.removeListener(phoneNumberFocusListener);
    _firstnameFocusNode.dispose();
    _lastnameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _addressFocus.dispose();
    _portfolioFocus.dispose();
    _jobTitleFocus.dispose();
    _bioFocus.dispose();
    _salaryRequirementsFocus.dispose();

    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _addressController.dispose();
    _dateOfBirthController.dispose();
    _portfolioController.dispose();
    _jobTitleController.dispose();
    _bioController.dispose();
    _salaryRequirementsController.dispose();
    upworkTextController.dispose();
    fiverrTextController.dispose();
    linkedInTextController.dispose();
    instagramTextController.dispose();
    facebookTextController.dispose();
    youtubeTextController.dispose();
    tiktokTextController.dispose();
    twitterTextController.dispose();

    super.dispose();
  }

  Future<void> selectDob(
    BuildContext context,
  ) async {
    debugPrint("dateOfBirth:-> $dateOfBirth");
    DateTime? picked = await selectDateOfBirth(context, dateOfBirth);
    if (picked != null && picked != dateOfBirth) {
      setState(() {
        dateOfBirth = picked;
        _dateOfBirthController.text = dateFormat.format(dateOfBirth);
      });
    }
  }

  void requestToNextField(FocusNode focusNode, GlobalKey<FormState> formKey) {
    final context = formKey.currentContext;
    // focusNode.requestFocus();
    if (context != null) {
      Scrollable.ensureVisible(context,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 300))
          .then((value) {
        focusNode.requestFocus();
      });
    }
  }

  Widget step2Form() {
    return Column(children: [
      /// Step 2 form instructions
      Text(
        AppString.stepForm2Instructions,
        textAlign: TextAlign.start,
        style: montserratRegular.copyWith(
          color: Theme.of(context).primaryColorDark.withOpacity(0.7),
          fontSize: 16,
        ),
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      ///Profile Photo
      if (!isEditProfile)
        DocumentImageSelector(
            title: AppString.profilePhotoOptional,
            hint: "",
            documentImage: profilePhoto,
            pickImageFromGalleryAlso: true,
            instructions: AppString.profilePhotoInstructions,
            networkDocumentImagePath: profilePhotoUrl,
            onImageSelection: (XFile file) {
              profilePhoto = file;
              setState(() {});
            }),
      if (!isEditProfile)
        const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      ///Govt Issue Id Front Photo
      DocumentImageSelector(
          title: AppString.photoOfGovtIssuedId,
          hint: "Front",
          documentImage: govtPhotoIdFront,
          pickImageFromGalleryAlso: false,
          instructions: AppString.govtIssuedIdPhotoInstructions,
          networkDocumentImagePath: govtPhotoIdFrontUrl,
          onImageSelection: (XFile file) {
            govtPhotoIdFront = file;
            setState(() {});
          }),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      ///Govt Issue Id Back Photo
      DocumentImageSelector(
          title: "",
          hint: "Back",
          documentImage: govtPhotoIdBack,
          pickImageFromGalleryAlso: false,
          instructions: "",
          networkDocumentImagePath: govtPhotoIdBackUrl,
          onImageSelection: (XFile file) {
            govtPhotoIdBack = file;
            setState(() {});
          }),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      /// Photo with holding govt issued id Photo
      DocumentImageSelector(
          title: AppString.takeWithHoldingGovtId,
          hint: "",
          documentImage: govtWithHoldingPhotoId,
          pickImageFromGalleryAlso: false,
          instructions: AppString.withHoldingIdPhotoInstructions,
          networkDocumentImagePath: govtWithHoldingPhotoIdUrl,
          onImageSelection: (XFile file) {
            govtWithHoldingPhotoId = file;
            setState(() {});
          }),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      /// Portfolio TextField
      CustomInputTextField(
        controller: _portfolioController,
        focusNode: _portfolioFocus,
        isPassword: false,
        hintText: 'https://www.website.com',
        context: context,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.go,
        onFieldSubmit: (value) {
          _portfolioFocus.unfocus();
          return value;
        },
        maxLines: 2,
        minLines: 1,
        labelText: AppString.portfolioOptional,
        validator: (inputData) {
          return inputData!.trim().isNotEmpty &&
                  !validateUrlText(inputData.trim())
              ? "Url is wrong! Use https://www.abc@xyz.com pattern"
              : null;
        },
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
    ]);
  }

  Widget step3Form() {
    return Column(children: [
      ///Job Title
      CustomInputTextField(
        controller: _jobTitleController,
        focusNode: _jobTitleFocus,
        isPassword: false,
        context: context,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmit: (value) {
          _bioFocus.requestFocus();
          return value;
        },
        labelText: AppString.jobTitleOptional,
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

      ///Bio Text field
      CustomInputTextField(
        controller: _bioController,
        focusNode: _bioFocus,
        isPassword: false,
        context: context,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmit: (value) {
          _salaryRequirementsFocus.requestFocus();
          return value;
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            maximumLengthFormatter(300),
          ),
        ],
        labelText: AppString.bio300CharactersRequired,
        // validator: (inputData) {
        //   return inputData!.trim().isEmpty
        //       ? ErrorMessage.bioEmptyError
        //       : inputData.length > 300
        //       ? ErrorMessage.bioMaxLengthError
        //       : null;
        // },
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

      /// Salary requirements Text field
      CustomInputTextField(
        controller: _salaryRequirementsController,
        focusNode: _salaryRequirementsFocus,
        isPassword: false,
        context: context,
        keyboardType: getKeyboardTypeForDigitsOnly(),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        textInputAction: TextInputAction.done,
        labelText: AppString.salaryRequirementRequired,
        validator: (inputData) {
          return inputData!.trim().isEmpty
              ? ErrorMessage.salaryRequirementEmptyError
              : inputData.length > 250
                  ? ErrorMessage.salaryMaxLengthError
                  : null;
        },
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

      /// Availability TextField
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Availability *",
            style: montserratRegular.copyWith(
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            padding: const EdgeInsets.all(10),
            child: CustomDropDown(
              isRemoveOverLayEntry: removeOverLayEntry,
              maxListHeight: context.height * 0.35,
              items: availabilityFilterList
                  .map((type) => CustomDropdownMenuItem(
                        value: type,
                        child: Text(
                          type,
                          style: montserratRegular,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ))
                  .toList(),
              hintText: "",
              borderRadius: 5,
              defaultSelectedIndex: selectedAvailability != null
                  ? availabilityFilterList.indexOf(selectedAvailability!)
                  : -1,
              isMultiSelect: false,
              onChanged: (int index, dynamic val) {
                String type = val;
                setState(() {
                  selectedAvailability = type;
                });
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

      /// Years of Experience TextField
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Years of experience (optional)",
            style: montserratRegular.copyWith(
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            padding: const EdgeInsets.all(10),
            child: CustomDropDown(
              isRemoveOverLayEntry: removeOverLayEntry,
              maxListHeight: context.height * 0.35,
              items: yearsOfExperienceList
                  .map((year) => CustomDropdownMenuItem(
                        value: year,
                        child: Text(
                          year,
                          style: montserratRegular,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ))
                  .toList(),
              hintText: "",
              borderRadius: 5,
              defaultSelectedIndex: selectedYearsOfExperience != null
                  ? yearsOfExperienceList.indexOf(selectedYearsOfExperience!)
                  : -1,
              isMultiSelect: false,
              onChanged: (int index, dynamic val) {
                String type = val;
                setState(() {
                  selectedYearsOfExperience = type;
                });
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

      /// Skill TextField
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Skills *",
            style: montserratRegular.copyWith(
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            padding: const EdgeInsets.all(10),
            child: CustomDropDown(
              isRemoveOverLayEntry: removeOverLayEntry,
              maxListHeight: context.height * 0.35,
              items: skillsDropDownList,
              hintText: "",
              borderRadius: 5,
              defaultSelectedIndex: -1,
              isMultiSelect: true,
              onChanged: (int index, dynamic val) {
                CustomDropdownMenuItem<Skill> item = skillsDropDownList[index];
                if (selectedSkills.length == 6) {
                  errorText = ErrorMessage.youCanSelectMaximum6Skills;
                  setState(() {});
                } else {
                  if (!selectedSkills.contains(item.value.value)) {
                    if (selectedSkills.isEmpty) {
                      errorText = '';
                    }
                    selectedSkills.add(item.value.value);
                    setState(() {});
                  }
                }
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Wrap(
            children: selectedSkills
                .map((skill) => InkWell(
                      onTap: () {
                        selectedSkills.remove(skill);
                        if (errorText ==
                            ErrorMessage.youCanSelectMaximum6Skills) {
                          errorText = '';
                        }
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 8, right: 3, top: 2, bottom: 2),
                        margin: const EdgeInsets.only(right: 4, bottom: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              skill,
                              style: montserratRegular.copyWith(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.highlight_remove,
                              color: Color(0xFFe60909),
                              size: 18,
                            )
                          ],
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    ]);
  }

  Widget step4Form() {
    return Column(children: [
      SocialMediaLinksFields(
          upworkTextController: upworkTextController,
          fiverrTextController: fiverrTextController,
          linkedInTextController: linkedInTextController,
          instagramTextController: instagramTextController,
          facebookTextController: facebookTextController,
          youtubeTextController: youtubeTextController,
          tiktokTextController: tiktokTextController,
          twitterTextController: twitterTextController),
      CustomInputTextField(
        controller:
            TextEditingController(text: AppString.sendVerificationCodeToPhone),
        focusNode: null,
        isPassword: false,
        readOnly: true,
        context: context,
        hintText: AppString.sendVerificationCodeToPhone,
        labelText: AppString.verifyThroughPhoneRequired,
      ),

      ///PrivacyPolicy checkBox
      isEditProfile
          ? const SizedBox()
          : const SizedBox(
              height: 15,
            ),
      isEditProfile
          ? const SizedBox()
          : CustomCheckboxWithText(
              initialValue: isTermsAndConditions,
              label: 'I have read and agreed to the ',
              linkText: "${AppConstants.APP_NAME} Terms of use",
              onChanged: (bool value) {
                setState(() {
                  isTermsAndConditions = value;
                });
              },
            )
    ]);
  }

  Widget stepLine() {
    return Expanded(
      child: Container(
        height: 4,
        alignment: Alignment.center,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget stepFormWidget(int stepNumber) {
    return InkWell(
      radius: 50,
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        if (_validateForm() || stepNumber < currentFormNumber) {
          bool ifAllPreviousFormsAreValidated = false;
          int invalidateFormNumber = 0;
          if (stepNumber == 1) {
            ifAllPreviousFormsAreValidated = true;
          } else if (stepNumber == 2) {
            ifAllPreviousFormsAreValidated = isStep1Validated;
            if (!ifAllPreviousFormsAreValidated) {
              invalidateFormNumber = 1;
            }
          } else if (stepNumber == 3) {
            ifAllPreviousFormsAreValidated =
                isStep1Validated && isStep2Validated;
            if (!ifAllPreviousFormsAreValidated && invalidateFormNumber == 0) {
              invalidateFormNumber = !isStep1Validated
                  ? 1
                  : !isStep2Validated
                      ? 2
                      : 0;
            }
          } else if (stepNumber == 4) {
            ifAllPreviousFormsAreValidated =
                isStep1Validated && isStep2Validated && isStep3Validated;
            if (!ifAllPreviousFormsAreValidated && invalidateFormNumber == 0) {
              invalidateFormNumber = !isStep1Validated
                  ? 1
                  : !isStep2Validated
                      ? 2
                      : !isStep3Validated
                          ? 3
                          : 0;
            }
          }
          if (ifAllPreviousFormsAreValidated) {
            if (currentFormNumber != stepNumber) {
              currentFormNumber = stepNumber;
            }
          } else {
            currentFormNumber = invalidateFormNumber;
            errorText = AppString.pleaseEnterAllRequiredFieldToMoveNext;
            showCustomToast(errorText, isErrorToast: true);
          }
        }
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: currentFormNumber == stepNumber
              ? Theme.of(context).secondaryHeaderColor
              : Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: Text(
          '$stepNumber',
          textAlign: TextAlign.center,
          style: montserratRegular.copyWith(
            color: Theme.of(context).primaryColorLight,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    bool isFormValidated = checkValidation();
    errorText =
        isFormValidated ? '' : AppString.pleaseEnterAllRequiredFieldToMoveNext;
    setState(() {});
    if (currentFormNumber == 1) {
      isStep1Validated = isFormValidated;
    } else if (currentFormNumber == 2) {
      isStep2Validated = isFormValidated;
    } else if (currentFormNumber == 3) {
      isStep3Validated = isFormValidated;
    } else if (currentFormNumber == 4) {
      isStep4Validated = isFormValidated;
    }
    return isFormValidated;
  }

  bool checkValidation() {
    bool isFormValidated = _formKey.currentState?.validate() ?? false;
    if (currentFormNumber == 1) {
      if (emailErrorText.isNotEmpty) {
        isFormValidated = false;
      }
      if (phoneErrorText.isNotEmpty) {
        isFormValidated = false;
      }
      if (selectedProvince == null) {
        provinceErrorMessage = "Province is required.";
        isFormValidated = false;
      }
      if (selectedCity == null) {
        cityErrorMessage = '${AppString.city} is required.';
        isFormValidated = false;
      }
      if (!isFormValidated) {
        isStep1Validated = false;
      }
    } else if (currentFormNumber == 2) {
      if (govtPhotoIdFront == null && govtPhotoIdFrontUrl == null) {
        isFormValidated = false;
      }
      if (govtPhotoIdBack == null && govtPhotoIdBackUrl == null) {
        isFormValidated = false;
      }
      if (govtWithHoldingPhotoId == null && govtWithHoldingPhotoIdUrl == null) {
        isFormValidated = false;
      }
      if (!isFormValidated) {
        isStep1Validated = false;
      }
    } else if (currentFormNumber == 3) {
      if (selectedAvailability == null) {
        isFormValidated = false;
      }
      if (selectedSkills.isEmpty) {
        isFormValidated = false;
      }
    }
    return isFormValidated;
  }

  void validateDataAndCallApi(
    AuthController authController,
  ) {
    FocusScope.of(context).unfocus();
    if (isTermsAndConditions || isEditProfile) {
      errorText = "";
      setState(() {});
      _callApi(
        authController,
      );
    } else {
      errorText = "You must agree to the terms and conditions.";
      setState(() {});
    }
  }

  void _callApi(
    AuthController authController,
  ) async {
    String? fcmToken;
    if (Platform.isAndroid) {
      fcmToken = await FirebaseMessaging.instance.getToken();
    } else if (Platform.isIOS) {
      fcmToken = await FirebaseMessaging.instance.getAPNSToken();
    }
    Map<String, dynamic> body = {
      "gender": selectedGender == Gender.other
          ? "Prefer not to say"
          : selectedGender?.name,
      "otpType": "phone",
      "first_name": _firstNameController.text.trim(),
      "last_name": _lastNameController.text.trim(),
      "email": _emailController.text.trim(),
      "phone": _phoneNumberController.text.trim(),
      "password": _passwordController.text.trim(),
      "password_confirmation": _confirmPasswordController.text.trim(),
      "state": selectedProvince?.stateName,
      "city": selectedCity,
      "address": _addressController.text.trim(),
      "FCMToken": fcmToken,
      "portfolio_website": _portfolioController.text.trim(),
      "description": _bioController.text.trim(),
      "salary_requirements": _salaryRequirementsController.text.trim(),
      "full_time": selectedAvailability,
      "upwork": upworkTextController.text.trim(),
      "fiverr": fiverrTextController.text.trim(),
      "linkedin": linkedInTextController.text.trim(),
      "youtube": youtubeTextController.text.trim(),
      "instagram": instagramTextController.text.trim(),
      "facebook": facebookTextController.text.trim(),
      "tiktok": tiktokTextController.text.trim(),
      "twitter": twitterTextController.text.trim(),
      "years_experience": selectedYearsOfExperience,
      "date_of_birth": _dateOfBirthController.text,
      "job_title": _jobTitleController.text.trim(),
      "skills_assessment[]": selectedSkills,
      "is_email_private": isEmailHide ? 1 : 0,
      "is_phone_private": isPhoneNoHide ? 1 : 0,
    };
    print("my body...........>$body");
    ApiClient.FormData formData = ApiClient.FormData.fromMap(body);

    if (govtPhotoIdFront != null) {
      formData.files.add(MapEntry("photo_of_govt_id",
          await getMultiPartFile(pickedFile: govtPhotoIdFront!)));
    }
    if (govtPhotoIdBack != null) {
      formData.files.add(MapEntry("photo_of_govt_id_back",
          await getMultiPartFile(pickedFile: govtPhotoIdBack!)));
    }
    if (govtWithHoldingPhotoId != null) {
      formData.files.add(MapEntry("photo_with_govt_id",
          await getMultiPartFile(pickedFile: govtWithHoldingPhotoId!)));
    }
    if (isEditProfile) {
      if (profilePhoto != null) {
        formData.files.add(MapEntry("profile_picture",
            await getMultiPartFile(pickedFile: profilePhoto!)));
      }
      await authController
          .updateFreelancerProfile(formData)
          .then((Map<String, dynamic> result) async {
        if (!result.containsKey(API_RESPONSE.SUCCESS)) {
          if (result.containsKey(API_RESPONSE.ERROR)) {
            Map<String, dynamic> error =
                result[API_RESPONSE.ERROR]['errors'] as Map<String, dynamic>;
            error.forEach((key, value) {
              errorText = "$errorText\n${(value as List).first}";
            });
          }
          debugPrint("errorText:->>> $errorText");
          setState(() {});
        }
      });
    } else {
      if (profilePhoto != null) {
        formData.files.add(MapEntry(
            "photo", await getMultiPartFile(pickedFile: profilePhoto!)));
      }

      await authController
          .sendFreelancerRegisterOtp(formData)
          .then((Map<String, dynamic> result) async {
        if (result.containsKey(API_RESPONSE.SUCCESS)) {
          num time = num.parse("${result[API_RESPONSE.SUCCESS]['time'] ?? 1}");
          num verify =
              num.parse("${result[API_RESPONSE.SUCCESS]['verify'] ?? 1235}");
          String otpCode = decryptDataAndGetOtp(verify: verify, time: time);
          print("otpCode............>$otpCode");
          ApiClient.FormData formData1 = ApiClient.FormData.fromMap(body);
          if (profilePhoto != null) {
            formData.files.add(MapEntry(
                "photo", await getMultiPartFile(pickedFile: profilePhoto!)));
          }
          if (govtPhotoIdFront != null) {
            formData.files.add(MapEntry("photo_of_govt_id",
                await getMultiPartFile(pickedFile: govtPhotoIdFront!)));
          }
          if (govtPhotoIdBack != null) {
            formData.files.add(MapEntry("photo_of_govt_id_back",
                await getMultiPartFile(pickedFile: govtPhotoIdBack!)));
          }
          if (govtWithHoldingPhotoId != null) {
            formData.files.add(MapEntry("photo_with_govt_id",
                await getMultiPartFile(pickedFile: govtWithHoldingPhotoId!)));
          }
          Get.to(() => RegisterOtpVerificationScreen(
              registerFormData: formData1,
              otpCode: otpCode,
              isFreeLancer: true));
        } else {
          if (result.containsKey(API_RESPONSE.ERROR)) {
            Map<String, dynamic> error =
                result[API_RESPONSE.ERROR]['errors'] as Map<String, dynamic>;
            error.forEach((key, value) {
              errorText = "$errorText\n${(value as List).first}";
            });
          }
          debugPrint("errorText:->>> $errorText");
          setState(() {});
        }
      });
    }
  }

  Future<ApiClient.MultipartFile> getMultiPartFile(
      {required XFile pickedFile}) async {
    File file = File(pickedFile.path);
    ApiClient.MultipartFile? multipartFile =
        await ApiClient.MultipartFile.fromFile(
      file.path,
      filename:
          "${DateTime.now().millisecondsSinceEpoch}${file.path.split("/").last}",
      contentType: MediaType('image', 'jpg'),
    );
    return multipartFile;
  }

  _setFieldsInCaseOfUpdateProfile() {
    User? user = Get.find<AuthController>().getLoginUserData();
    _firstNameController.text = user?.firstName ?? '';
    _lastNameController.text = user?.lastName ?? '';
    _emailController.text = user?.email ?? '';
    _phoneNumberController.text = user?.phone ?? '';
    _addressController.text = user?.address ?? '';
    selectedGender = user?.freelancer?.gender?.toLowerCase() ==
            Gender.Male.name.toLowerCase()
        ? Gender.Male
        : user?.freelancer?.gender?.toLowerCase() ==
                Gender.Female.name.toLowerCase()
            ? Gender.Female
            : user?.freelancer?.gender == "Prefer not to say"
                ? Gender.other
                : null;
    DateTime? dateTime = user?.freelancer?.dateOfBirth != null
        ? DateTime.parse(user!.freelancer!.dateOfBirth!)
        : null;
    if (dateTime != null) {
      dateOfBirth = dateTime;
    }
    print(
        "my linked is controller: ${user?.freelancer?.socialLinks.linkedIn.name}");
    String formattedDate = dateFormat.format(dateTime ?? dateOfBirth);
    _dateOfBirthController.text = formattedDate;
    profilePhotoUrl = user?.profilePicture;
    govtPhotoIdFrontUrl = user?.freelancer?.photoOfGovtId;
    govtPhotoIdBackUrl = user?.freelancer?.photoOfGovtIdBack;
    govtWithHoldingPhotoIdUrl = user?.freelancer?.photoWithGovtId;
    _portfolioController.text = user?.freelancer?.portfolioWebsite ?? "";
    _jobTitleController.text = user?.freelancer?.jobTitle ?? "";
    _bioController.text = user?.freelancer?.description ?? "";
    isEmailHide = user?.isEmailHide ?? false;
    isPhoneNoHide = user?.isPhoneNumberHide ?? false;
    _salaryRequirementsController.text =
        user?.freelancer?.salaryRequirements ?? "";
    selectedAvailability = user?.freelancer?.fullTime;
    selectedYearsOfExperience = user?.freelancer?.yearsExperience;
    selectedSkills = user?.freelancer?.skillsAssessment ?? [];
    upworkTextController.text = user?.freelancer?.socialLinks.upwork.name ?? '';
    fiverrTextController.text = user?.freelancer?.socialLinks.fiverr.name ?? '';
    linkedInTextController.text =
        user?.freelancer?.socialLinks.linkedIn.name ?? '';
    instagramTextController.text =
        user?.freelancer?.socialLinks.instagram.name ?? '';
    facebookTextController.text =
        user?.freelancer?.socialLinks.facebook.name ?? '';
    youtubeTextController.text =
        user?.freelancer?.socialLinks.youtube.name ?? '';
    tiktokTextController.text = user?.freelancer?.socialLinks.tiktok.name ?? '';
    twitterTextController.text =
        user?.freelancer?.socialLinks.twitter.name ?? '';
    isStep1Validated = true;
    isStep2Validated = true;
    isStep3Validated = true;
    isStep4Validated = true;
  }
}

class CustomCheckboxWithText extends StatefulWidget {
  final String label;
  final String? linkText;
  final ValueChanged<bool> onChanged;
  final bool initialValue;

  const CustomCheckboxWithText({
    required this.label,
    required this.onChanged,
    required this.initialValue,
    Key? key,
    this.linkText,
  }) : super(key: key);

  @override
  _CustomCheckboxWithTextState createState() => _CustomCheckboxWithTextState();
}

class _CustomCheckboxWithTextState extends State<CustomCheckboxWithText> {
  bool _isChecked = false;
  @override
  void initState() {
    super.initState();
    _isChecked = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      GestureDetector(
        onTap: () {
          setState(() {
            _isChecked = !_isChecked;
            widget.onChanged(_isChecked);
          });
        },
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(2),
              color: _isChecked
                  ? Theme.of(context).primaryColor
                  : Colors.transparent),
          child: _isChecked
              ? const Center(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                )
              : null,
        ),
      ),
      const SizedBox(width: 8),
      Flexible(
          child: Text.rich(
        TextSpan(
            text: widget.label,
            style: montserratSemiBold.copyWith(
              fontSize: 12,
            ),
            children: <TextSpan>[
              TextSpan(
                text: widget.linkText ?? "",
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    Get.to(() => const WebViewScreen(
                          url: AppString.privacyPolicyUrl,
                          title: AppString.privacyPolicy,
                        ));
                    // AppRoutes.push(
                    // context, const PoliciesScreen());
                  },
                style: montserratSemiBold.copyWith(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                    decoration: TextDecoration.underline),
              )
            ]),
      ))
    ]);
  }
}
