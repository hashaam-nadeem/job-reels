import 'package:flutter/material.dart';
import 'package:jobreels/data/model/response/social_media_links.dart';
import 'package:jobreels/util/images.dart';

import '../../util/app_strings.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';
import 'my_text_field.dart';

class SocialMediaLinksFields extends StatefulWidget {
  TextEditingController upworkTextController;
  TextEditingController fiverrTextController;
  TextEditingController linkedInTextController;
  TextEditingController instagramTextController;
  TextEditingController facebookTextController;
  TextEditingController youtubeTextController;
  TextEditingController tiktokTextController;
  TextEditingController twitterTextController;
  SocialMediaLinksFields({
    Key? key,
    required this.upworkTextController,
    required this.fiverrTextController,
    required this.linkedInTextController,
    required this.instagramTextController,
    required this.facebookTextController,
    required this.youtubeTextController,
    required this.tiktokTextController,
    required this.twitterTextController,
  }) : super(key: key);

  @override
  State<SocialMediaLinksFields> createState() => _SocialMediaLinksFieldsState();
}

class _SocialMediaLinksFieldsState extends State<SocialMediaLinksFields> {
  FocusNode upworkFocusNode = FocusNode();
  FocusNode fiverrFocusNode = FocusNode();
  FocusNode linkedInFocusNode = FocusNode();
  FocusNode instagramFocusNode = FocusNode();
  FocusNode facebookFocusNode = FocusNode();
  FocusNode youtubeFocusNode = FocusNode();
  FocusNode tiktokFocusNode = FocusNode();
  FocusNode twitterFocusNode = FocusNode();
  
  @override
  Widget build(BuildContext context) {
    SocialLinks socialLinks = SocialLinks.defaultObject();
    return Column(
      children: [
        /// Upwork TextField
        linkWidget(imagePath: Images.upwork, title: socialLinks.upwork.name, textEditingController: widget.upworkTextController, focusNode: upworkFocusNode, nextFocusNode: fiverrFocusNode, backgroundColor: Colors.green),

        /// Fiverr TextField
        linkWidget(imagePath: Images.fiverr, title: socialLinks.fiverr.name, textEditingController: widget.fiverrTextController, focusNode: fiverrFocusNode, nextFocusNode: linkedInFocusNode, backgroundColor: Colors.green),

        /// LinkedIn TextField
        linkWidget(imagePath: Images.linkedIn, title: socialLinks.linkedIn.name, textEditingController: widget.linkedInTextController, focusNode: linkedInFocusNode, nextFocusNode: instagramFocusNode, backgroundColor: null, height: 30, width: 30),

        /// Instagram TextField
        linkWidget(isSocialMedia: true, imagePath: Images.instagram, title: socialLinks.instagram.name, textEditingController: widget.instagramTextController, focusNode: instagramFocusNode, nextFocusNode: facebookFocusNode, backgroundColor: null, height: 30, width: 30),

        /// Facebook TextField
        linkWidget(isSocialMedia: true, imagePath: Images.facebook, title: socialLinks.facebook.name, textEditingController: widget.facebookTextController, focusNode: facebookFocusNode, nextFocusNode: youtubeFocusNode, backgroundColor: null, height: 30, width: 30),

        /// Youtube TextField
        linkWidget(isSocialMedia: true, imagePath: Images.youtube, title: socialLinks.youtube.name, textEditingController: widget.youtubeTextController, focusNode: youtubeFocusNode, nextFocusNode: tiktokFocusNode, backgroundColor: null, height: 30, width: 30),

        /// Tiktok TextField
        linkWidget(isSocialMedia: true, imagePath: Images.tiktok, title: socialLinks.tiktok.name, textEditingController: widget.tiktokTextController, focusNode: tiktokFocusNode, nextFocusNode: twitterFocusNode, backgroundColor: Colors.black),

        /// Twitter TextField
        linkWidget(isSocialMedia: true, imagePath: Images.twitter, title: socialLinks.twitter.name, textEditingController: widget.twitterTextController, focusNode: twitterFocusNode, nextFocusNode: null, backgroundColor: const Color(0XFF1DA1F2)),
      ],
    );
  }

  Widget linkWidget({bool isSocialMedia = false, required String  imagePath, required String title, required TextEditingController textEditingController, required FocusNode focusNode, required FocusNode? nextFocusNode, required Color ?backgroundColor, double ?height, double ?width}){
    return Column(
      children: [
        /// TextField
        Row(
          children: [
            prefixWidget(imagePath, backgroundColor, width: width, height: height),
            Text('  (Optional)', style: montserratRegular.copyWith(fontSize: 16), overflow: TextOverflow.ellipsis, maxLines: 1,),
          ],
        ),
        CustomInputTextField(
          controller: textEditingController,
          focusNode: focusNode,
          isPassword: false,
          context: context,
          hintText: isSocialMedia ? '$title Username' : 'URL of $title profile page',
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          onFieldSubmit: (value){
            nextFocusNode?.requestFocus();
            return value;
          },
        ),
        const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
      ],
    );
  }

  Widget prefixWidget(String assetPath, Color ?backgroundColor, {double ?height, double ?width}){
    return Container(
        width: 30,
        height: 30,
        margin: const EdgeInsets.only(bottom: 5),
        alignment: Alignment.center,
        decoration:backgroundColor!=null
            ?  BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(5)
            )
            : BoxDecoration(
              borderRadius: BorderRadius.circular(5)
            ),
        child: Image.asset(assetPath,width: width ?? 20, height: height ?? 20,fit: BoxFit.cover,color: backgroundColor!=null ? Colors.white : null,));
  }

}
