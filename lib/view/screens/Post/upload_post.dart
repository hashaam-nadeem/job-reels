import 'package:flutter/foundation.dart';
import 'package:jobreels/controller/post_controller.dart';
import 'package:jobreels/data/model/body/post_upload.dart';
import 'package:jobreels/helper/helper.dart';
import 'package:jobreels/util/app_strings.dart';
import 'package:jobreels/util/dimensions.dart';
import 'package:jobreels/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/view/base/custom_app_bar.dart';
import 'package:jobreels/view/base/my_text_field.dart';
import 'package:jobreels/view/base/social_media_links_text_form_fields.dart';
import '../../../controller/auth_controller.dart';
import '../../../util/app_constants.dart';
import '../../base/custom_button.dart';
import '../../base/custom_drop_down_item.dart';

class UploadPost extends StatefulWidget {
  final PostForm postForm;
  final bool isUpdateVideo;
  const UploadPost(
      {Key? key, required this.postForm, required this.isUpdateVideo})
      : super(key: key);

  @override
  UploadPostState createState() => UploadPostState();
}

class UploadPostState extends State<UploadPost> {
  bool hidePassword = true;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _portfolioFocus = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _portfolioController = TextEditingController();
  TextEditingController upworkTextController = TextEditingController();
  TextEditingController fiverrTextController = TextEditingController();
  TextEditingController linkedInTextController = TextEditingController();
  TextEditingController instagramTextController = TextEditingController();
  TextEditingController facebookTextController = TextEditingController();
  TextEditingController youtubeTextController = TextEditingController();
  TextEditingController tiktokTextController = TextEditingController();
  TextEditingController twitterTextController = TextEditingController();

  String errorText = '';
  bool isApiCalling = false;
  List<CustomDropdownMenuItem<Skill>> skillsDropDownList =
      <CustomDropdownMenuItem<Skill>>[];
  List<String> selectedSkills = <String>[];
  ValueListenable<bool> removeOverLayEntry = ValueNotifier(false);
  int formNumber = 1;

  @override
  void initState() {
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
    if (widget.postForm.listSkills.isNotEmpty) {
      selectedSkills.addAll(widget.postForm.listSkills);
    }

    if (widget.isUpdateVideo) {
      PostForm postForm = widget.postForm;
      _titleController.text = postForm.title;
      _descriptionController.text = postForm.description;
      _portfolioController.text = postForm.portfolio ?? "";
      upworkTextController.text = postForm.socialLinks.upwork.url ?? "";
      fiverrTextController.text = postForm.socialLinks.fiverr.url ?? "";
      linkedInTextController.text = postForm.socialLinks.linkedIn.url ?? "";
      instagramTextController.text = postForm.socialLinks.instagram.url ?? "";
      facebookTextController.text = postForm.socialLinks.facebook.url ?? "";
      youtubeTextController.text = postForm.socialLinks.youtube.url ?? "";
      tiktokTextController.text = postForm.socialLinks.tiktok.url ?? "";
      twitterTextController.text = postForm.socialLinks.twitter.url ?? "";
    }
    super.initState();
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
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: AppString.post,
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
              const SizedBox(
                  height: Dimensions.PADDING_SIZE_EXTRA_X_LARGE +
                      Dimensions.PADDING_SIZE_LARGE),
              Text(
                "${widget.isUpdateVideo ? 'Edit' : 'Post'} video",
                style: montserratMedium.copyWith(
                  fontSize: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    radius: 50,
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      if (_validateForm()) {
                        if (formNumber != 1) {
                          setState(() {
                            formNumber = 1;
                          });
                        }
                      }
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: formNumber == 1
                            ? Theme.of(context).secondaryHeaderColor
                            : Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '1',
                        textAlign: TextAlign.center,
                        style: montserratRegular.copyWith(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 90,
                    height: 4,
                    alignment: Alignment.center,
                    color: Theme.of(context).primaryColor,
                  ),
                  InkWell(
                    radius: 50,
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      if (_validateForm()) {
                        if (formNumber != 2) {
                          setState(() {
                            formNumber = 2;
                          });
                        }
                      }
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: formNumber == 2
                            ? Theme.of(context).secondaryHeaderColor
                            : Theme.of(context).primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '2',
                        textAlign: TextAlign.center,
                        style: montserratRegular.copyWith(
                          color: Theme.of(context).primaryColorLight,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_LARGE),
              Container(
                width: context.width,
                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                margin: EdgeInsets.zero,
                child: GetBuilder<AuthController>(builder: (authController) {
                  return Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.disabled,
                    child: Column(
                      children: [
                        formNumber == 1 ? form1() : form2(),

                        /// Server side error message
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              Flexible(
                                child: Text(
                                  errorText,
                                  textAlign: TextAlign.start,
                                  style: montserratRegular.copyWith(
                                    color: Theme.of(context).errorColor,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: Dimensions.PADDING_SIZE_DEFAULT,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (formNumber == 2)
                              CustomButton(
                                onPressed: () {
                                  formNumber = 1;
                                  setState(() {});
                                },
                                buttonText: AppString.previous,
                                textColor: Theme.of(context).primaryColor,
                                width: 120,
                                radius: 50,
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
                            CustomButton(
                              onPressed: () {
                                if (formNumber == 1 && _validateForm()) {
                                  formNumber = 2;
                                  setState(() {});
                                } else if (formNumber == 2) {
                                  validateDataAndCallApi();
                                }
                              },
                              buttonText: formNumber == 1
                                  ? AppString.next
                                  : AppString.submit,
                              width: 120,
                              radius: 50,
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget form1() {
    return Column(
      children: [
        ///Title
        CustomInputTextField(
          controller: _titleController,
          focusNode: _titleFocus,
          isPassword: false,
          context: context,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onFieldSubmit: (value) {
            _descriptionFocus.requestFocus();
            return value;
          },
          labelText: "${AppString.title} *",
          validator: (inputData) {
            return inputData!.trim().isEmpty
                ? ErrorMessage.titleEmptyError
                : inputData.length > 250
                    ? ErrorMessage.titleMaxLengthError
                    : null;
          },
        ),
        const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

        /// Description TextField
        CustomInputTextField(
          controller: _descriptionController,
          focusNode: _descriptionFocus,
          isPassword: false,
          context: context,
          keyboardType: TextInputType.multiline,
          // ma: 6,
          textInputAction: TextInputAction.newline,
          onFieldSubmit: (value) {
            _portfolioFocus.requestFocus();
            return value;
          },
          maxLines: 10,
          minLines: 1,
          labelText: "${AppString.description} *",
          validator: (inputData) {
            return inputData!.trim().isEmpty
                ? ErrorMessage.descriptionEmptyError
                : null;
          },
        ),
        const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

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
                onOpen: context.mediaQueryViewInsets.bottom > 0
                    ? () {
                        FocusScope.of(context).unfocus();
                      }
                    : null,
                isRemoveOverLayEntry: removeOverLayEntry,
                maxListHeight: context.height * 0.35,
                items: skillsDropDownList,
                hintText: "",
                borderRadius: 5,
                defaultSelectedIndex: -1,
                isMultiSelect: true,
                onChanged: (int index, dynamic val) {
                  CustomDropdownMenuItem<Skill> item =
                      skillsDropDownList[index];
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
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
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
      ],
    );
  }

  Widget form2() {
    return SocialMediaLinksFields(
        upworkTextController: upworkTextController,
        fiverrTextController: fiverrTextController,
        linkedInTextController: linkedInTextController,
        instagramTextController: instagramTextController,
        facebookTextController: facebookTextController,
        youtubeTextController: youtubeTextController,
        tiktokTextController: tiktokTextController,
        twitterTextController: twitterTextController);
  }

  bool _validateForm() {
    bool isValidated = false;
    bool isFormValidated = _formKey.currentState!.validate();
    if (selectedSkills.isEmpty) {
      errorText = 'Please select at least one skill.';
      isValidated = false;
      setState(() {});
    } else {
      isValidated = true;
    }
    bool isAllValidated = isValidated && isFormValidated;
    if (isAllValidated) {
      errorText = '';
      setState(() {});
    }
    return isAllValidated;
  }

  void validateDataAndCallApi() {
    if (errorText.isNotEmpty) {
      errorText = '';
      setState(() {});
    }
    if (_validateForm()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();
      _submitVideo();
    }
  }

  void _submitVideo() async {
    PostsController postsController = Get.find<PostsController>();
    widget.postForm.listSkills.clear();
    widget.postForm.listSkills.addAll(selectedSkills);
    widget.postForm.title = _titleController.text.trim();
    widget.postForm.description = _descriptionController.text.trim();
    widget.postForm.portfolio = _portfolioController.text.trim();
    widget.postForm.socialLinks.upwork.url = upworkTextController.text.trim();
    widget.postForm.socialLinks.fiverr.url = fiverrTextController.text.trim();
    widget.postForm.socialLinks.linkedIn.url =
        linkedInTextController.text.trim();
    widget.postForm.socialLinks.instagram.url =
        instagramTextController.text.trim();
    widget.postForm.socialLinks.facebook.url =
        facebookTextController.text.trim();
    widget.postForm.socialLinks.youtube.url = youtubeTextController.text.trim();
    widget.postForm.socialLinks.tiktok.url = tiktokTextController.text.trim();
    widget.postForm.socialLinks.twitter.url = twitterTextController.text.trim();
    await postsController.uploadVideo(widget.postForm,
        isUpdateVideo: widget.isUpdateVideo);
  }
}
