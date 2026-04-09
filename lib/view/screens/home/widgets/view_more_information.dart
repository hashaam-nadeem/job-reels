import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/data/model/response/post.dart';
import 'package:jobreels/helper/helper.dart';
import 'package:jobreels/helper/route_helper.dart';
import 'package:jobreels/util/images.dart';
import 'package:jobreels/util/styles.dart';
import 'package:jobreels/view/base/custom_button.dart';
import 'package:jobreels/view/base/custom_linkable.dart';
import 'package:jobreels/view/base/linkify_widget.dart';
import '../../../../util/app_strings.dart';
import '../../../../util/dimensions.dart';
import '../../../base/custom_app_bar.dart';

class ViewMoreInformation extends StatelessWidget {
  final Post post;
  final bool showVisitProfileButton;
  const ViewMoreInformation(
      {Key? key, required this.post, this.showVisitProfileButton = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: AppString.moreInfo,
        titleColor: Theme.of(context).primaryColor,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).primaryColor,
              size: 20,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: context.width,
              // height: context.height,
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
              margin: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFF208db0),
                      offset: Offset(0, 0),
                      blurRadius: 2,
                      spreadRadius: 0.1,
                      blurStyle: BlurStyle.outer,
                    )
                  ]),
              child: Wrap(
                // mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  setInfoHeaderAndTitle(
                      AppString.name, getUserName(user: post.user!), context),
                  if (post.title.isNotEmpty)
                    setInfoHeaderAndTitle(AppString.title, post.title, context),
                  if (post.skills.isNotEmpty)
                    setInfoHeaderAndTitle(
                        AppString.skills, post.skills.join(', '), context),
                  if (post.description.isNotEmpty)
                    setInfoHeaderAndTitle(
                        AppString.description, post.description, context),

                  /// Social Media Links
                  Get.find<AuthController>().authRepo.isLoggedOut()
                      ? socialMediaLinks()
                      : Get.find<AuthController>()
                                  .getLoginUserData()
                                  ?.isFreelancer ??
                              true
                          ? Container(
                              height: 0,
                              width: 0,
                            )
                          : socialMediaLinks()

                  // if (post.socialLinks.upwork.url != null)
                  //   LinkifyWidgetIconWidgetInRow(
                  //     leadingIcon: prefixWidget(
                  //       Images.upwork,
                  //     ),
                  //     description: post.socialLinks.upwork.url!,
                  //     userId: post!.userId!,
                  //   ),
                  // if (post.socialLinks.fiverr.url != null)
                  //   LinkifyWidgetIconWidgetInRow(
                  //     leadingIcon: prefixWidget(
                  //       Images.fiverr,
                  //     ),
                  //     description: post.socialLinks.fiverr.url!,
                  //     userId: post.userId!,
                  //   ),
                  // if (post.socialLinks.linkedIn.url != null)
                  //   LinkifyWidgetIconWidgetInRow(
                  //     leadingIcon: prefixWidget(
                  //       Images.socialLinkedIn,
                  //     ),
                  //     description: post.socialLinks.linkedIn.url!,
                  //     userId: post.id!,
                  //   ),
                  // if (post.socialLinks.instagram.url != null)
                  //   LinkifyWidgetIconWidgetInRow(
                  //     leadingIcon: prefixWidget(
                  //       Images.socialInstagram,
                  //     ),
                  //     description: post.socialLinks.instagram.url!,
                  //     userId: post.id!,
                  //   ),
                  // if (post.socialLinks.facebook.url != null)
                  //   LinkifyWidgetIconWidgetInRow(
                  //     leadingIcon: prefixWidget(
                  //       Images.socialFacebook,
                  //     ),
                  //     description: post.socialLinks.facebook.url!,
                  //     userId: post.id!,
                  //   ),
                  // if (post.socialLinks.youtube.url != null)
                  //   LinkifyWidgetIconWidgetInRow(
                  //     leadingIcon: prefixWidget(
                  //       Images.socialYoutube,
                  //     ),
                  //     description: post.socialLinks.youtube.url!,
                  //     userId: post.id!,
                  //   ),
                  // if (post.socialLinks.tiktok.url != null)
                  //   LinkifyWidgetIconWidgetInRow(
                  //     leadingIcon: prefixWidget(
                  //       Images.tiktok,
                  //     ),
                  //     description: post.socialLinks.tiktok.url!,
                  //     userId: post.id!,
                  //   ),
                  // if (post.socialLinks.twitter.url != null)
                  //   LinkifyWidgetIconWidgetInRow(
                  //     leadingIcon: prefixWidget(
                  //       Images.twitter,
                  //     ),
                  //     description: post.socialLinks.twitter.url!,
                  //     userId: post.id!,
                  //   ),

                  // if (post.socialLinks.upwork.url?.isNotEmpty ?? false)
                  //   Get.find<AuthController>().authRepo.isLoggedOut()
                  //       ? Text(
                  //           "Login to view Data",
                  //           style: montserratSemiBold.copyWith(
                  //             color: Colors.red,
                  //             fontSize: 16,
                  //             fontWeight: FontWeight.w500,
                  //           ),
                  //         )
                  //       : setInfoHeaderAndTitle(post.socialLinks.upwork.name,
                  //           post.socialLinks.upwork.url ?? "", context,
                  //           isRestrictedData: true),
                  // if (post.socialLinks.fiverr.url?.isNotEmpty ?? false)
                  //   setInfoHeaderAndTitle(post.socialLinks.fiverr.name,
                  //       post.socialLinks.fiverr.url ?? "", context,
                  //       isRestrictedData: true),
                  // if (post.socialLinks.linkedIn.url?.isNotEmpty ?? false)
                  //   setInfoHeaderAndTitle(post.socialLinks.linkedIn.name,
                  //       post.socialLinks.linkedIn.url ?? "", context,
                  //       isRestrictedData: true),
                  // if (post.socialLinks.instagram.url?.isNotEmpty ?? false)
                  //   setInfoHeaderAndTitle(post.socialLinks.instagram.name,
                  //       post.socialLinks.instagram.url ?? "", context,
                  //       isRestrictedData: true),
                  // if (post.socialLinks.facebook.url?.isNotEmpty ?? false)
                  //   setInfoHeaderAndTitle(post.socialLinks.facebook.name,
                  //       post.socialLinks.facebook.url ?? "", context,
                  //       isRestrictedData: true),
                  // if (post.socialLinks.youtube.url?.isNotEmpty ?? false)
                  //   setInfoHeaderAndTitle(post.socialLinks.youtube.name,
                  //       post.socialLinks.youtube.url ?? "", context,
                  //       isRestrictedData: true),
                  // if (post.socialLinks.tiktok.url?.isNotEmpty ?? false)
                  //   setInfoHeaderAndTitle(post.socialLinks.tiktok.name,
                  //       post.socialLinks.tiktok.url ?? "", context,
                  //       isRestrictedData: true),
                  // if (post.socialLinks.twitter.url?.isNotEmpty ?? false)
                  //   setInfoHeaderAndTitle(post.socialLinks.twitter.name,
                  //       post.socialLinks.twitter.url ?? "", context,
                  //       isRestrictedData: true),
                  ,
                  const SizedBox(
                    height: 12,
                  ),
                  if (showVisitProfileButton)
                    CustomButton(
                      onPressed: () {
                        print("visit profile");
                        Get.find<AuthController>()
                            .visitProfile(post.userId!, post.user);
                      },
                      buttonText: AppString.visitProfile,
                      height: 32,
                      radius: 10,
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget socialMediaLinks() {
    // print("is my profile: ${widget.isMyProfile}");
    return Column(
      children: [
        if (post!.user!.phone != null && !post.user!.isPhoneNumberHide)
          // Get.find<AuthController>().getLoginUserData()?.isFreelancer ?? true
          //     ? Container(
          //         height: 0,
          //         width: 0,
          //       )
          //     : !authController.isLoginUserSubscribed
          //         ? Container(
          //             height: 0,
          //             width: 0,
          //           )
          //         :
          LinkifyWidgetIconWidgetInRow(
            icon: Ionicons.call,
            description: "+63${post.user!.phone!}",
            userId: post.user!.id!,
          ),
        // if (user!.email != null && !user!.isEmailHide)
        //   user!.isFreelancer
        //       ? Container(
        //           height: 0,
        //           width: 0,
        //         )
        //       :
        // LinkifyWidgetIconWidgetInRow(
        //   icon: Feather.mail,
        //   description: user!.email!,
        //   userId: user!.id!,
        // ),
        if (post.user!.freelancer!.socialLinks.upwork.url != null)
          LinkifyWidgetIconWidgetInRow(
            leadingIcon: prefixWidget(
              Images.upwork,
            ),
            description: post.user!.freelancer!.socialLinks.upwork.url!,
            userId: post.user!.id!,
          ),
        if (post.user!.freelancer!.socialLinks.fiverr.url != null)
          LinkifyWidgetIconWidgetInRow(
            leadingIcon: prefixWidget(
              Images.fiverr,
            ),
            description: post.user!.freelancer!.socialLinks.fiverr.url!,
            userId: post.user!.id!,
          ),
        if (post.user!.freelancer!.socialLinks.linkedIn.url != null)
          LinkifyWidgetIconWidgetInRow(
            leadingIcon: prefixWidget(
              Images.socialLinkedIn,
            ),
            description: post.user!.freelancer!.socialLinks.linkedIn.url!,
            userId: post.user!.id!,
          ),
        if (post.user!.freelancer!.socialLinks.instagram.url != null)
          LinkifyWidgetIconWidgetInRow(
            leadingIcon: prefixWidget(
              Images.socialInstagram,
            ),
            description: post.user!.freelancer!.socialLinks.instagram.url!,
            userId: post.user!.id!,
          ),
        if (post.user!.freelancer!.socialLinks.facebook.url != null)
          LinkifyWidgetIconWidgetInRow(
            leadingIcon: prefixWidget(
              Images.socialFacebook,
            ),
            description: post.user!.freelancer!.socialLinks.facebook.url!,
            userId: post.user!.id!,
          ),
        if (post.user!.freelancer!.socialLinks.youtube.url != null)
          LinkifyWidgetIconWidgetInRow(
            leadingIcon: prefixWidget(
              Images.socialYoutube,
            ),
            description: post.user!.freelancer!.socialLinks.youtube.url!,
            userId: post.user!.id!,
          ),
        if (post.user!.freelancer!.socialLinks.tiktok.url != null)
          LinkifyWidgetIconWidgetInRow(
            leadingIcon: prefixWidget(
              Images.tiktok,
            ),
            description: post.user!.freelancer!.socialLinks.tiktok.url!,
            userId: post.user!.id!,
          ),
        if (post.user!.freelancer!.socialLinks.twitter.url != null)
          LinkifyWidgetIconWidgetInRow(
            leadingIcon: prefixWidget(
              Images.twitter,
            ),
            description: post.user!.freelancer!.socialLinks.twitter.url!,
            userId: post.user!.id!,
          ),
      ],
    );
  }

  Widget prefixWidget(String assetPath, {double? height, double? width}) {
    return Container(
        width: 20,
        height: 20,
        // margin: const EdgeInsets.only(bottom: 5),
        alignment: Alignment.center,
        child: Image.asset(
          assetPath,
          width: width ?? 13,
          height: height ?? 13,
          fit: BoxFit.cover,
        ));
  }

  Widget setInfoHeaderAndTitle(
      String title, String description, BuildContext context,
      {bool isRestrictedData = false}) {
    return GetBuilder(builder: (AuthController authController) {
      String? errorDescription;
      if (isRestrictedData &&
          authController.getLoginUserData()?.id != post.user?.id) {
        if (authController.authRepo.isLoggedOut()) {
          errorDescription = "Login to view this data";
        } else if (!authController.isLoginUserSubscribed) {
          errorDescription = 'Subscribe to view this data (free for now)';
        }
      }
      return SizedBox(
        width: context.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: montserratSemiBold.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Flexible(
              child: InkWell(
                onTap: authController.getLoginUserData()?.id == post.user?.id ||
                        !isRestrictedData
                    ? null
                    : authController.authRepo.isLoggedIn() &&
                            !authController.isLoginUserSubscribed
                        ? () {
                            if (Get.find<AuthController>()
                                    .getLoginUserData()!
                                    .type
                                    .toString() ==
                                "admin") {
                            } else {
                              debugPrint(
                                  "isRestrictedData:-> $isRestrictedData authController.getLoginUserData(${authController.getLoginUserData()?.id})?.id== userId[${post.user?.id}]:->> ${authController.getLoginUserData()?.id == post.user?.id}");
                              showSubscriptionBuyMessage();
                            }
                          }
                        : authController.authRepo.isLoggedOut()
                            ? () {
                                Get.toNamed(RouteHelper.getSignInRoute());
                              }
                            : null,
                child: CustomLinkable(
                  text: errorDescription ?? description,
                  style: montserratRegular.copyWith(
                    fontSize: 16,
                  ),
                  textColor: errorDescription != null &&
                          authController.authRepo.isLoggedIn()
                      ? Theme.of(context).errorColor
                      : const Color(0xFF333333),
                  linkColor: errorDescription != null &&
                          authController.authRepo.isLoggedIn()
                      ? Theme.of(context).errorColor
                      : Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      );
    });
  }
}
