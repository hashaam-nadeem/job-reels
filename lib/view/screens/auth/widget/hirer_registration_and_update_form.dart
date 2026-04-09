import 'dart:core';
import 'dart:io';
import 'package:dio/dio.dart' as ApiClient;
import 'package:camera/camera.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:http_parser/http_parser.dart';
import 'package:jobreels/data/model/helpers.dart';
import 'package:jobreels/data/model/response/state_city_model.dart';
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
import 'package:jobreels/view/base/custom_snackbar.dart';
import 'package:jobreels/view/base/custom_toast.dart';
import 'package:jobreels/view/base/drop_down_selection_widget.dart';
import 'package:jobreels/view/base/my_text_field.dart';
import 'package:jobreels/view/base/popup_alert.dart';
import 'package:jobreels/view/screens/auth/widget/freelancer_registration_update_form.dart';
import 'package:jobreels/view/screens/auth/widget/register_otp_verification_screen.dart';
import '../../../../controller/auth_controller.dart';
import '../../../../controller/state_controller.dart';
import '../../../../data/api/Api_Handler/api_error_response.dart';
import '../../../../data/model/response/user.dart';
import '../../../base/CustomImagePicker/Utils/utils.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_drop_down_item.dart';
import '../../../base/custom_image.dart';
import '../../delete account/delete_account.dart';

class HirerRegisterUpdateScreen extends StatefulWidget {
  const HirerRegisterUpdateScreen({Key? key}) : super(key: key);

  @override
  HirerRegisterUpdateScreenState createState() =>
      HirerRegisterUpdateScreenState();
}

class HirerRegisterUpdateScreenState extends State<HirerRegisterUpdateScreen> {
  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isTermsAndConditions = false;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _firstNameFocusNode = FocusNode();
  final FocusNode _lastnameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _phoneNumberFocusNode = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _cityFocus = FocusNode();
  final FocusNode _zipCodeFocus = FocusNode();
  final FocusNode _bioFocus = FocusNode();
  final FocusNode _businessFocus = FocusNode();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();
  String emailErrorText = '';
  String phoneErrorText = '';
  String errorText = '';
  int currentFormNumber = 1;
  StateClass? selectedState;
  ValueListenable<bool> removeOverLayEntry = ValueNotifier(false);
  ValueListenable<bool> isResetSelection = ValueNotifier(false);
  String stateErrorMessage = '';
  String industryErrorMessage = '';
  bool isStep1Validated = false;
  bool isStep2Validated = false;
  bool isEditProfile = false;
  String? selectedIndustry;
  XFile? profilePhoto;
  String? profilePhotoUrl;

  @override
  void initState() {
    AuthController authController = Get.find<AuthController>();
    isEditProfile = authController.authRepo.isLoggedIn();
    Get.find<StateController>()
        .getStateList(Country.USA)
        .then((List<StateClass> usaStates) {
      if (isEditProfile) {
        setState(() {
          isTermsAndConditions = true;
        });
        User user = authController.getLoginUserData()!;
        for (StateClass state in usaStates) {
          if (user.state == state.stateName) {
            selectedState = state;
            break;
          }
        }
      } else {
        setState(() {
          isTermsAndConditions = false;
        });
      }
    });
    if (isEditProfile) {
      setState(() {
        isTermsAndConditions = true;
      });
      User user = authController.getLoginUserData()!;
      _setFieldsInCaseOfUpdateProfile(user);
    }
    _emailFocusNode.addListener(emailFocusListener);
    _phoneNumberFocusNode.addListener(phoneNumberFocusListener);
    super.initState();
  }

  @override
  void dispose() {
    _emailFocusNode.removeListener(emailFocusListener);
    _phoneNumberFocusNode.removeListener(phoneNumberFocusListener);
    _emailFocusNode.dispose();
    _phoneNumberFocusNode.dispose();
    super.dispose();
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
    // print("emplue: ${AppString.signUpAsEmployee.tr}");
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
              child: GetBuilder<AuthController>(builder: (authController) {
                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (!isEditProfile)
                        Text(
                          AppString.signUpAsEmployer.tr,
                          style: montserratSemiBold.copyWith(
                            fontSize: 25,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      if (!isEditProfile)
                        const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                      SizedBox(
                        width: 150,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            stepFormWidget(1),
                            stepLine(),
                            stepFormWidget(2),
                          ],
                        ),
                      ),
                      const SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_X_LARGE),
                      currentFormNumber == 1
                          ? step1Form(authController)
                          : step2Form(),
                      const SizedBox(
                          height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      /// Server side error message
                      Row(
                        children: [
                          Flexible(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10, top: 0),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          /// Previous Button
                          if (currentFormNumber > 1)
                            CustomButton(
                              onPressed: () {
                                movePrevious();
                              },
                              buttonText: AppString.previous,
                              textColor: Theme.of(context).primaryColor,
                              width: 120,
                              radius: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                border: Border.all(
                                    color: Theme.of(context).primaryColor),
                                borderRadius: BorderRadius.circular(50),
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
                              if (currentFormNumber == 1) {
                                moveNext();
                              } else {
                                setState(() {
                                  isStep2Validated =
                                      _formKey.currentState?.validate() ??
                                          false;
                                });
                                if (isStep1Validated) {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    if (isTermsAndConditions == false) {
                                      showCustomToast(
                                          "please confirm terms and conditions!");
                                    } else {
                                      print(
                                          "termsand condition: $isStep2Validated");
                                      if (isStep2Validated) {
                                        // if (isTermsAndConditions == false) {
                                        //   showCustomToast(
                                        //       "please confirm terms and conditions!");
                                        // } else {
                                        validateDataAndCallApi(authController);
                                        // }
                                      } else {
                                        // if (selectedState == null) {
                                        //   stateErrorMessage =
                                        //       "${AppString.state} is required.";
                                        // }
                                        if (selectedIndustry == null) {
                                          industryErrorMessage =
                                              "The industry field is required.";
                                        }
                                        errorText = AppString
                                            .pleaseEnterAllRequiredFieldToMoveNext;
                                        print(
                                            "current for no: $currentFormNumber");
                                      }
                                    }
                                  }
                                } else {
                                  setState(() {
                                    currentFormNumber = 1;
                                  });

                                  errorText = AppString
                                      .pleaseEnterAllRequiredFieldToMoveNext;
                                  setState(() {});
                                  _formKey.currentState?.validate();
                                }
                              }
                            },
                            buttonText: currentFormNumber == 2
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
              }),
            ),
          ),
        ),
      ),
    );
  }

  _setFieldsInCaseOfUpdateProfile(User user) {
    profilePhotoUrl = user.profilePicture;
    _businessController.text = user.businessName ?? '';
    _bioController.text = user.description ?? '';
    _firstNameController.text = user.firstName ?? '';
    _lastNameController.text = user.lastName ?? '';
    _emailController.text = user.email ?? '';
    _phoneNumberController.text = user.phone ?? '';
    _addressController.text = user.address ?? '';
    _cityController.text = user.city ?? "";
    _zipCodeController.text = user.zipCode ?? "";
    selectedIndustry = user.industry ?? "";
    isStep1Validated = true;
    isStep2Validated = true;
  }

  Future<void> onBackButtonPressed() async {
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

      ///Business Name Text field
      CustomInputTextField(
        controller: _businessController,
        focusNode: _businessFocus,
        isPassword: false,
        context: context,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmit: (value) {
          _bioFocus.requestFocus();
          return value;
        },
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            maximumLengthFormatter(300),
          ),
        ],
        labelText: AppString.businessNameOptional,
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      /// Bio Text field
      CustomInputTextField(
        controller: _bioController,
        focusNode: _bioFocus,
        isPassword: false,
        context: context,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmit: (value) {
          _firstNameFocusNode.requestFocus();
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
        //       ? null
        //       : inputData.length > 300
        //       ? ErrorMessage.bioMaxLengthError
        //       : null;
        // },
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      /// First Name and Last Name
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// First Name
          Expanded(
            child: CustomInputTextField(
              controller: _firstNameController,
              focusNode: _firstNameFocusNode,
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
        readOnly: isEditProfile,
        isPassword: false,
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
                Images.usaFlag,
                width: 40,
                height: 20,
              ),
              Text(
                " +1",
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
    ]);
  }

  void requestToNextField(FocusNode focusNode, GlobalKey<FormState> formKey) {
    final context = formKey.currentContext;
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
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      /// State Selection DropDown
      GetBuilder(builder: (StateController stateController) {
        return GestureDetector(
          onTap: !stateController.isDataFetching
              ? null
              : () {
                  showCustomSnackBar('Fetching state list');
                },
          child: DropDownWidget(
            title: AppString.stateRequired,
            errorMessage: stateErrorMessage,
            initialSelectedIndex: selectedState != null
                ? stateController.stateList.indexOf(selectedState!)
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
              if (selectedState != val) {
                selectedState = val;
                if (selectedState != null) {
                  stateErrorMessage = "";
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
      }),
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
        onFieldSubmit: (value) {
          _cityFocus.requestFocus();
          return value;
        },
        validator: (inputData) {
          // return inputData!.trim().isEmpty
          //     ? ErrorMessage.addressEmptyError
          //     : inputData.length > 250
          //         ? ErrorMessage.addressMaxLengthError
          //         : null;
        },
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      /// City
      CustomInputTextField(
        controller: _cityController,
        focusNode: _cityFocus,
        isPassword: false,
        context: context,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        labelText: AppString.cityRequired,
        onFieldSubmit: (value) {
          _zipCodeFocus.requestFocus();
          return value;
        },
        validator: (inputData) {
          // return inputData!.trim().isEmpty
          //     ? ErrorMessage.cityEmptyError
          //     : inputData.length > 250
          //         ? ErrorMessage.cityMaxLengthError
          //         : null;
        },
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      /// Zip Code
      CustomInputTextField(
        controller: _zipCodeController,
        focusNode: _zipCodeFocus,
        isPassword: false,
        context: context,
        keyboardType: getKeyboardTypeForDigitsOnly(),
        textInputAction: TextInputAction.next,
        labelText: AppString.zipCodeRequired,
        validator: (inputData) {
          // return inputData!.trim().isEmpty
          //     ? ErrorMessage.zipCodeEmptyError
          //     : inputData.length > 250
          //         ? ErrorMessage.zipCodeMaxLengthError
          //         : null;
        },
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

      /// Industry TextField
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Industry *",
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
              items: hirerIndustryList
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
              defaultSelectedIndex: selectedIndustry != null
                  ? hirerIndustryList.indexOf(selectedIndustry!)
                  : -1,
              isMultiSelect: false,
              onChanged: (int index, dynamic val) {
                String type = val;
                setState(() {
                  industryErrorMessage = "";
                  selectedIndustry = type;
                });
              },
            ),
          ),
        ],
      ),
      const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
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
      SizedBox(
        height: 10,
      ),
      isEditProfile
          ? const SizedBox(
              height: 0,
              width: 0,
            )
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
        if (stepNumber == 1 && currentFormNumber == 2) {
          /// Go to form 1
          movePrevious();
        } else {
          /// Go to form 2
          moveNext();
        }
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

  void movePrevious() {
    errorText = "";
    isStep2Validated =
        (_formKey.currentState?.validate() ?? true) && selectedState != null;
    currentFormNumber = 1;
    setState(() {});
  }

  void moveNext() {
    errorText = "";
    FocusScope.of(context).unfocus();
    _businessController.text = _businessController.text;
    _bioController.text = _bioController.text;
    _firstNameController.text = _firstNameController.text;
    _lastNameController.text = _lastNameController.text;
    _emailController.text = _emailController.text;
    _phoneNumberController.text = _phoneNumberController.text;
    bool isFormValidated = (_formKey.currentState?.validate() ?? false);
    _formKey.currentState?.save();
    isStep1Validated =
        isFormValidated && phoneErrorText.isEmpty && emailErrorText.isEmpty;
    setState(() {});
    if (isStep1Validated) {
      currentFormNumber = 2;
    } else {
      if (!isFormValidated) {
        errorText = emailErrorText.isNotEmpty
            ? emailErrorText
            : phoneErrorText.isNotEmpty
                ? phoneErrorText
                : "";
      }
    }
    setState(() {});
  }

  void validateDataAndCallApi(
    AuthController authController,
  ) {
    FocusScope.of(context).unfocus();
    errorText = "";
    setState(() {});
    _sendOtp(
      authController,
    );
  }

  void _sendOtp(
    AuthController authController,
  ) async {
    String? fcmToken;
    if (Platform.isAndroid) {
      fcmToken = await FirebaseMessaging.instance.getToken();
    } else if (Platform.isIOS) {
      fcmToken = await FirebaseMessaging.instance.getAPNSToken();
    }
    Map<String, dynamic> body = {
      "otpType": "phone",
      "industry": selectedIndustry,
      "first_name": _firstNameController.text.trim(),
      "last_name": _lastNameController.text.trim(),
      "email": _emailController.text.trim(),
      "phone": _phoneNumberController.text.trim(),
      "password": _passwordController.text.trim(),
      "password_confirmation": _confirmPasswordController.text.trim(),
      "state": selectedState?.stateName,
      "city": _cityController.text.trim(),
      "address": _addressController.text.trim(),
      "zip_code": _zipCodeController.text.trim(),
      "FCMToken": fcmToken,
      "portfolio_website": _zipCodeController.text.trim(),
      "description": _bioController.text.trim(),
      "business_name": _businessController.text.trim(),
    };
    print("my body: ${body}");
    debugPrint("body:->>> $body");
    ApiClient.FormData formData = ApiClient.FormData.fromMap(body);

    if (isEditProfile) {
      if (profilePhoto != null) {
        formData.files.add(MapEntry("profile_picture",
            await getMultiPartFile(pickedFile: profilePhoto!)));
      }
      await authController
          .updateHirerProfile(formData)
          .then((Map<String, dynamic> result) async {
        if (!result.containsKey(API_RESPONSE.SUCCESS)) {
          if (result.containsKey(API_RESPONSE.ERROR)) {
            Map<String, dynamic> error =
                result[API_RESPONSE.ERROR]['errors'] as Map<String, dynamic>;
            error.forEach((key, value) {
              errorText = "$errorText\n${(value as List).first}";
            });
          }
          setState(() {});
        }
      });
    } else {
      await authController
          .sendHirerRegisterOtp(formData)
          .then((Map<String, dynamic> result) async {
        if (result.containsKey(API_RESPONSE.SUCCESS)) {
          num time = num.parse("${result[API_RESPONSE.SUCCESS]['time'] ?? 1}");
          num verify =
              num.parse("${result[API_RESPONSE.SUCCESS]['verify'] ?? 1235}");
          String otpCode = ((verify - time) / time).toStringAsFixed(0);
          ApiClient.FormData formData1 = ApiClient.FormData.fromMap(body);
          Get.to(() => RegisterOtpVerificationScreen(
              registerFormData: formData1,
              otpCode: otpCode,
              isFreeLancer: false));
        } else {
          if (result.containsKey(API_RESPONSE.ERROR)) {
            Map<String, dynamic> error =
                result[API_RESPONSE.ERROR]['errors'] as Map<String, dynamic>;
            error.forEach((key, value) {
              errorText = "$errorText\n${(value as List).first}";
            });
          }
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
}
