import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:jobreels/controller/notification_chat_controller.dart';
import 'package:jobreels/data/api/Api_Handler/api_error_response.dart';
import 'package:jobreels/data/model/response/post.dart';
import 'package:jobreels/data/model/response/user.dart';
import 'package:jobreels/enums/report_type.dart';
import 'package:jobreels/helper/helper.dart';
import 'package:jobreels/view/base/linkify_widget.dart';
import 'package:jobreels/view/screens/auth/widget/freelancer_registration_update_form.dart';
import 'package:jobreels/view/screens/auth/widget/hirer_registration_and_update_form.dart';
import 'package:jobreels/view/screens/chat/chat_screen.dart';
import 'package:jobreels/view/screens/report/report_user_or_post.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../controller/auth_controller.dart';
import '../../../controller/post_controller.dart';
import '../../../data/model/body/post_upload.dart';
import '../../../data/model/helpers.dart';
import '../../../data/model/response/chat_thread_model.dart';
import '../../../util/app_strings.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
import '../../base/custom_image.dart';
import '../../base/custom_loader.dart';
import '../../base/popup_alert.dart';
import '../../base/video_thumnail_layout.dart';
import '../Post/upload_post.dart';
import '../home/home_screen.dart';
import '../webview/webview_screen.dart';

class ProfileScreen extends StatefulWidget {
  final int ?userId;
  final bool isMyProfile;
  final bool showAppbarLeading;
  const ProfileScreen({Key? key, this.userId, this.isMyProfile = true, this.showAppbarLeading = false}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isProfileFetching = true;
  RefreshController refreshController = RefreshController();
  User ?user;
  List<Post> myPostedVideosList = [];
  List<Post> otherUsersSavedPosts = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void initState(){
    getUserProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: AppString.profile,
        titleColor: Theme.of(context).primaryColorLight,
        leading: !widget.showAppbarLeading ? null : IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).primaryColorLight,size: 16,),
        ),
        showLeading: widget.showAppbarLeading,
        tileColor: Theme.of(context).primaryColor,
        trailing: widget.isMyProfile ? [
          GestureDetector(
            onTap: (){
              if(_scaffoldKey.currentState?.isEndDrawerOpen??false){
                _scaffoldKey.currentState?.closeEndDrawer();
              }else{
                _scaffoldKey.currentState?.openEndDrawer();
              }
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
              child: Icon(Icons.menu,),
            ),
          )
        ] : [],
      ),
      body: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        drawerEdgeDragWidth: context.width * 0.3,
        endDrawer: widget.isMyProfile ? drawerWidget() : null,
        body: SmartRefresher(
          controller: refreshController,
          onRefresh: ()async{
            await getUserProfileData();
            refreshController.refreshCompleted();
          },
          child: SingleChildScrollView(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              width: context.width,
              padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
              margin: EdgeInsets.zero,
              child: isProfileFetching
                  ? SizedBox(height: context.height * 0.75,width: context.width, child: const Center(child:  CustomLoader(),),)
                  : user== null
                  ? SizedBox(
                height: context.height * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Failed to load data.\nPlease try again.",
                      textAlign: TextAlign.center,
                      style: montserratRegular.copyWith(
                        color: Theme.of(context).errorColor,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: context.height * 0.05,),
                    CustomButton(
                      onPressed: () {
                        setState(() {
                          isProfileFetching = true;
                        });
                        getUserProfileData();
                      },
                      buttonText: AppString.retry,

                    ),
                  ],
                ),
              )
                  : Column(
                children: [
                  const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: !widget.isMyProfile ? null : ()async{
                              onEditProfilePressed();
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Theme.of(context).primaryColor,)
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: CustomImage(
                                  image: user!.profilePicture!,
                                  isProfileImage: false,
                                  height: 100,
                                  width: 100,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
                          Text(
                            "${user!.firstName} ${user!.lastName}",
                            textAlign: TextAlign.center,
                            style: montserratBold.copyWith(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
                          user!.isFreelancer
                              ? freeLancerView()
                              : hirerView(),
                          if(widget.isMyProfile)
                            CustomButton(
                              onPressed: (){
                                onEditProfilePressed();
                              },
                              height: 50,
                              radius: 0,
                              width: 150,
                              textColor: Theme.of(context).primaryColor,
                              decoration: BoxDecoration(
                                color: Theme.of(context).primaryColorLight,
                                borderRadius: BorderRadius.circular(0),
                                border: Border.all(color: Theme.of(context).primaryColor),
                              ),
                              buttonText: AppString.editProfile,
                            ),
                          if(user!.isFreelancer && !widget.isMyProfile)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomButton(
                                  onPressed: (){
                                    // if(user!.isSubscribed){
                                    Get.find<ChatNotificationController>().fetchThreadAndGoToChatScreen(user!.id!);
                                    // }else{
                                    //   showSubscriptionBuyMessage();
                                    // }
                                  },
                                  height: 45,
                                  radius: 0,
                                  width: 150,
                                  textColor: Theme.of(context).primaryColorLight,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  buttonText: AppString.chat,
                                ),
                                const SizedBox(width: 10,),
                                InkWell(
                                  onTap: (){
                                    Get.to(ReportVideo(id: user!.id!, reportType: Report.User));
                                  },
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Theme.of(context).primaryColor),
                                    ),
                                    child: Icon(
                                      Ionicons.md_flag,
                                      size: 22,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            myPostedVideosList.isNotEmpty
                                ? SizedBox(
                              width: context.width-10,
                              child: GridView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: myPostedVideosList.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.57, // Adjust the aspect ratio as needed
                                ),
                                itemBuilder: (context, index){
                                  Post post = myPostedVideosList[index];
                                  return GestureDetector(
                                    onTap: (){
                                      Get.to(()=> HomeScreen(postListToRender: myPostedVideosList,initialPage: index,title: "${user!.firstName} ${user!.lastName}",showVisitProfileButton: false));
                                    },
                                    child: Stack(
                                      children: [
                                        VideoGridSearch(post: post),
                                        if(widget.isMyProfile)
                                          Positioned(
                                            left: 15,
                                            bottom: 25,
                                            child: InkWell(
                                              onTap: ()async{
                                                Get.to(()=> UploadPost(
                                                  postForm: PostForm(
                                                    postId: post.id,
                                                    title: post.title,
                                                    description: post.description,
                                                    portfolio: post.portfolio,
                                                    listSkills: post.skills,
                                                    socialLinks: post.socialLinks,
                                                  ),
                                                  isUpdateVideo: true,
                                                ),
                                                );
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).primaryColorLight,
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  FontAwesome5.edit,
                                                  size: 15,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        if(widget.isMyProfile)
                                          Positioned(
                                            right: 15,
                                            bottom: 25,
                                            child: InkWell(
                                              onTap: ()async{
                                                showPopUpAlert(
                                                  popupObject: PopupObject(
                                                      title: "Confirm Delete",
                                                      body: "Are you sure you want to delete this post?",
                                                      buttonText: null,
                                                      onYesPressed: (){
                                                        Get.find<PostsController>().deleteVideo(post.id!).then((bool isDeleted){
                                                          if(isDeleted){
                                                            Get.back();
                                                            myPostedVideosList.removeWhere((video) => video.id==post.id);
                                                            setState(() {});
                                                          }
                                                        });
                                                      }
                                                  ),
                                                );
                                              },
                                              child: Container(
                                                height: 30,
                                                width: 30,
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).primaryColorLight,
                                                  shape: BoxShape.circle,
                                                ),
                                                alignment: Alignment.center,
                                                child: Icon(
                                                  Ionicons.trash,
                                                  size: 15,
                                                  color: Theme.of(context).errorColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                                : otherUsersSavedPosts.isNotEmpty
                                ? SizedBox(
                              width: context.width-10,
                              child: GridView.builder(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: otherUsersSavedPosts.length,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 0.57, // Adjust the aspect ratio as needed
                                ),
                                itemBuilder: (context, index){
                                  Post post = otherUsersSavedPosts[index];
                                  return GestureDetector(
                                    onTap: ()async{
                                      await Get.to(()=> HomeScreen(postListToRender: otherUsersSavedPosts,initialPage: index,title: "${user!.firstName} ${user!.lastName}",showVisitProfileButton: false));
                                      otherUsersSavedPosts.removeWhere((video) => !video.userSaved);
                                      setState(() {});
                                    },
                                    child: VideoGridSearch(post: post),
                                  );
                                },
                              ),
                            )
                                : SizedBox(
                              width: context.width * 0.94,
                              height: context.height*0.2,
                              child: Center(
                                child: Text(
                                  '${widget.isMyProfile ? "You have":"This user has"} not posted any video!',
                                  textAlign: TextAlign.center,
                                  style: montserratRegular.copyWith(
                                    color: const Color(0xFFe60909),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }

  Widget freeLancerView(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${user!.freelancer?.jobTitle}",
              textAlign: TextAlign.center,
              style: montserratMedium.copyWith(
                color: Theme.of(context).primaryColorDark,
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: context.width *0.9,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: user!.freelancer!.skillsAssessment.map((skill) => Container(
                  padding: const EdgeInsets.only(left: 8, right: 8,top: 2,bottom: 2),
                  margin: const EdgeInsets.only(right: 4, bottom: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Theme.of(context).primaryColor),
                  ),
                  child: Text(
                    skill,
                    style: montserratRegular.copyWith(fontSize: 16, color: Theme.of(context).primaryColor,),
                  ),
                )).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
        InfoWidget(icon: Entypo.info, title: AppString.bio, description: user!.freelancer!.description??""),
        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
        InfoWidget(icon: Fontisto.dollar, title: AppString.expectedSalaryMonthly, description: "${user!.freelancer!.salaryRequirements??""}(\$/month)"),
        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
        InfoWidget(icon: AntDesign.clockcircle, title: AppString.availability, description: user!.freelancer!.fullTime??""),
        const SizedBox(height: Dimensions.PADDING_SIZE_SMALL,),
        InfoWidget(icon: MaterialIcons.work, title: AppString.yearsOfExperience, description: user!.freelancer!.yearsExperience??""),
        /// Divider
        Container(
          color: Theme.of(context).primaryColorDark.withOpacity(0.2),
          height: 1,
          margin: const EdgeInsets.symmetric(vertical: 15),
          width: context.width-10,
        ),
        SizedBox(
          width: context.width-10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Basic Information",
                  textAlign: TextAlign.center,
                  style: montserratMedium.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
          ),
        ),
        if(user!.freelancer!.gender!=null)
        SizedBox(
          width: context.width-10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Gender: ",
                  textAlign: TextAlign.start,
                  style: montserratMedium.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 17,
                  ),
                ),
                Text(
                  user!.freelancer!.gender??"",
                  textAlign: TextAlign.start,
                  style: montserratRegular.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
        if((user!.freelancer!.age??0)>0)
        SizedBox(
          width: context.width-10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Age: ",
                  textAlign: TextAlign.start,
                  style: montserratMedium.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 17,
                  ),
                ),
                Text(
                  "${user!.freelancer!.age}",
                  textAlign: TextAlign.start,
                  style: montserratRegular.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ),
        if(user!.city!=null||user!.state!=null)
          SizedBox(
            width: context.width-10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Location: ",
                    textAlign: TextAlign.start,
                    style: montserratMedium.copyWith(
                      color: Theme.of(context).primaryColorDark,
                      fontSize: 17,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      (user!.city!=null?"${user!.city}, ":"")+ (user!.state ?? ""),
                      textAlign: TextAlign.start,
                      style: montserratRegular.copyWith(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
        SizedBox(
          width: context.width-10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact Information",
                  textAlign: TextAlign.center,
                  style: montserratMedium.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 19,
                  ),
                ),
              ],
            ),
          ),
        ),
        if(user!.phone!=null)
        LinkifyWidgetIconWidgetInRow(
          icon: Ionicons.call,
          description: "+63${user!.phone!}",
          userId: user!.id!,
        ),
        if(user!.email!=null)
        LinkifyWidgetIconWidgetInRow(
          icon: Feather.mail,
          description: user!.email!,
          userId: user!.id!,
        ),
        if(user!.freelancer!.socialLinks.upwork?.url !=null)
        LinkifyWidgetIconWidgetInRow(
          leadingIcon: prefixWidget(Images.upwork,),
          description: user!.freelancer!.socialLinks.upwork!.url!,
          userId: user!.id!,
        ),
        if(user!.freelancer!.socialLinks.fiverr?.url !=null)
        LinkifyWidgetIconWidgetInRow(
          leadingIcon: prefixWidget(Images.fiverr,),
          description: user!.freelancer!.socialLinks.fiverr!.url!,
          userId: user!.id!,
        ),
        if(user!.freelancer!.socialLinks.linkedIn?.url !=null)
        LinkifyWidgetIconWidgetInRow(
          leadingIcon: prefixWidget(Images.socialLinkedIn,),
          description: user!.freelancer!.socialLinks.linkedIn!.url!,
          userId: user!.id!,
        ),
        if(user!.freelancer!.socialLinks.instagram?.url !=null)
        LinkifyWidgetIconWidgetInRow(
          leadingIcon: prefixWidget(Images.socialInstagram,),
          description: user!.freelancer!.socialLinks.instagram!.url!,
          userId: user!.id!,
        ),
        if(user!.freelancer!.socialLinks.facebook?.url !=null)
        LinkifyWidgetIconWidgetInRow(
          leadingIcon: prefixWidget(Images.socialFacebook,),
          description: user!.freelancer!.socialLinks.facebook!.url!,
          userId: user!.id!,
        ),
        if(user!.freelancer!.socialLinks.youtube?.url !=null)
        LinkifyWidgetIconWidgetInRow(
          leadingIcon: prefixWidget(Images.socialYoutube,),
          description: user!.freelancer!.socialLinks.youtube!.url!,
          userId: user!.id!,
        ),
        if(user!.freelancer!.socialLinks.tiktok?.url !=null)
        LinkifyWidgetIconWidgetInRow(
          leadingIcon: prefixWidget(Images.tiktok,),
          description: user!.freelancer!.socialLinks.tiktok!.url!,
          userId: user!.id!,
        ),
        if(user!.freelancer!.socialLinks.twitter?.url !=null)
          LinkifyWidgetIconWidgetInRow(
            leadingIcon: prefixWidget(Images.twitter,),
            description: user!.freelancer!.socialLinks.twitter!.url!,
            userId: user!.id!,
          ),
        /// Divider
        Container(
          color: Theme.of(context).primaryColorDark.withOpacity(0.2),
          height: 1,
          margin: const EdgeInsets.symmetric(vertical: 15),
          width: context.width-10,
        ),
      ],
    );
  }

  Widget hirerView(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
          hirerIiFormationWidget("Bio", user!.description),
          if(user!.businessName!=null)
            hirerIiFormationWidget("Business", user!.businessName!),
          if(user!.industry!=null)
            hirerIiFormationWidget("Industry", user!.industry??""),
          hirerIiFormationWidget("Location", "${user!.city!}, ${user!.state!}"),
          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
        ],
      ),
    );
  }

  Widget hirerIiFormationWidget(String title, String description){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: montserratBold.copyWith(
            fontSize: 17,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
        SizedBox(
          width: context.width-30,
          child: Row(
            children: [
              Flexible(
                child: Text(
                  description,
                  style: montserratRegular.copyWith(
                    fontSize: 17,
                    color: Theme.of(context).primaryColorDark,
                  ),
                )
              ),
            ],
          ),
        ),
        const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
      ],
    );
  }

  Widget drawerWidget(){
    return Container(
      color: Theme.of(context).primaryColorLight,
      width: context.width * 0.6,
      height: context.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),
          drawerButton(
            iconData: MaterialCommunityIcons.account_edit,
            title: AppString.editProfile,
            onPressed: (){
              onEditProfilePressed();
            },
          ),
          drawerButton(
            iconData: MaterialCommunityIcons.shield_alert,
            title: AppString.privacyPolicy,
            onPressed: (){
              Get.to(()=> const WebViewScreen(url: AppString.privacyPolicyUrl, title: AppString.privacyPolicy,));
            },
          ),
          drawerButton(
            iconData: MaterialCommunityIcons.shield_alert,
            title: AppString.termsOfUse,
            onPressed: (){
              Get.to(()=> const WebViewScreen(url: AppString.termsOfUseUrl, title: AppString.termsOfUse,));
            },
          ),
          drawerButton(
            iconData: MaterialIcons.feedback,
            title: AppString.feedBack,
            onPressed: (){
              Get.to(()=> const WebViewScreen(url: AppString.feedBackUrl, title: AppString.feedBack,));
            },
          ),
          drawerButton(
            iconData: MaterialCommunityIcons.logout,
            title: AppString.logout,
            onPressed: (){
              showPopUpAlert(
                popupObject: PopupObject(
                  title: "Confirm logout",
                  body: "Are you sure you want to logout?",
                  buttonText: null,
                  onYesPressed: (){
                    Get.find<AuthController>().logout();
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget drawerButton({required IconData iconData,required String title, required void Function() onPressed}){
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: Theme.of(context).primaryColorDark,
              size: 26,
            ),
            const SizedBox(width: 10,),
            Text(
              title,
              style: montserratRegular.copyWith(
                color: Theme.of(context).primaryColorDark,
                fontSize: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void>onEditProfilePressed()async{
    await Get.to(()=> user!.isFreelancer ? const FreeLancerRegisterUpdateScreen() : const HirerRegisterUpdateScreen());
    user = Get.find<AuthController>().getLoginUserData()!;
    setState(() {});
  }

  Future getUserProfileData()async{
    Map<String, dynamic> response = await (widget.userId == null ? Get.find<AuthController>().getUserProfile() : Get.find<AuthController>().getOtherUserProfile(widget.userId!));
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      Map<String, dynamic> result = response[API_RESPONSE.SUCCESS];
      user = User.fromJson(result['data']);
      if(!user!.isFreelancer && widget.isMyProfile){
        otherUsersSavedPosts = List<Post>.from(result['saved_posts'].map((e) => Post.fromJson(e))).toList();
      }else{
        myPostedVideosList = List<Post>.from(result['posts'].map((e) => Post.fromJson(e))).toList();
      }
    }
    setState(() {
      isProfileFetching = false;
    });
  }

  Widget prefixWidget(String assetPath, {double ?height, double ?width}){
    return Container(
        width: 20,
        height: 20,
        // margin: const EdgeInsets.only(bottom: 5),
        alignment: Alignment.center,
        child: Image.asset(assetPath,width: width ?? 13, height: height ?? 13,fit: BoxFit.cover,));
  }

}

class InfoWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  const InfoWidget({Key? key, required this.icon, required this.title, required this.description,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width-10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 26,
              height: 26,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(5),
              child: Icon(icon,size: 16,color: Theme.of(context).primaryColorLight,),
            ),
            const SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: montserratMedium.copyWith(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 17,
                  ),
                ),
                SizedBox(
                  width: context.width * 0.83,
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          description,
                          maxLines: 6,
                          textAlign: TextAlign.start,
                          style: montserratRegular.copyWith(
                            color: Theme.of(context).primaryColorDark,
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

