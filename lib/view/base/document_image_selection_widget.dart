import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:jobreels/view/base/CustomImagePicker/Utils/utils.dart';
import 'package:jobreels/view/base/ImageView.dart';
import 'package:jobreels/view/base/custom_image.dart';

import '../../util/dimensions.dart';
import '../../util/styles.dart';

class DocumentImageSelector extends StatelessWidget {
  final XFile ?documentImage;
  final String ?networkDocumentImagePath;
  final String title;
  final String hint;
  final String instructions;
  final Function(XFile file)onImageSelection;
  final bool pickImageFromGalleryAlso;
  const DocumentImageSelector({Key? key, required this.title,required this.pickImageFromGalleryAlso, required this.hint, required this.instructions, required this.documentImage, required this.networkDocumentImagePath, required this.onImageSelection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String hintText = "${hint.isNotEmpty ? "$hint p":"P"}hoto";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(title.isNotEmpty)
          InfoWidget(instructions: instructions, title: title),
        if(title.isNotEmpty)
          const SizedBox(height: 5,),
        InkWell(
          onTap: ()async{
            File ?selectedImage =  await getImage(pickImageFromGalleryAlso);
            if(selectedImage!=null){
              onImageSelection(XFile(selectedImage.path));
            }
          },
          child: Container(
            width: context.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.BORDER_RADIUS),
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  documentImage==null && networkDocumentImagePath==null ? "Select $hintText":"$hintText selected",
                  style: montserratRegular.copyWith(fontSize: 16, color: Theme.of(context).primaryColor,),
                ),
                Icon(Icons.camera_alt, color: Theme.of(context).primaryColor,)
              ],
            ),
          ),
        ),
        if(documentImage!=null||networkDocumentImagePath!=null)
          Container(
            height: 150,
            width: context.width,
            margin: const EdgeInsets.symmetric(vertical: Dimensions.RADIUS_DEFAULT),
            child: documentImage!=null
                ? Image.file(File(documentImage!.path),height: 150, width: context.width, fit: BoxFit.cover,)
                : CustomImage(image: networkDocumentImagePath!, isProfileImage: false,height: 150, width: context.width, key: Key(networkDocumentImagePath!),)

          ),
        // if(errorMessage.isNotEmpty)
        //   Row(
        //     children: [
        //       Flexible(
        //         child: Padding(
        //           padding: const EdgeInsets.all(8.0),
        //           child: Text(
        //             errorMessage,
        //             textAlign: TextAlign.start,
        //             style: montserratRegular.copyWith(
        //               color: Theme.of(context).errorColor,
        //               fontSize: 14,
        //               fontStyle: FontStyle.italic,
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
      ],
    );
  }
}

class InfoWidget extends StatefulWidget {
  final String instructions;
  final String title;
  const InfoWidget({Key? key, required this.instructions, required this.title}) : super(key: key);

  @override
  State<InfoWidget> createState() => _InfoWidgetState();
}

class _InfoWidgetState extends State<InfoWidget> {
  bool isShowInfo = false;
  Color blackShadeColor = const Color(0xFF333333);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: montserratRegular.copyWith(fontSize: 17, color: Theme.of(context).primaryColor,),
              ),
            ),
            InkWell(
              onTap: (){
                setState(() {
                  isShowInfo = !isShowInfo;
                });
              },
              radius: 50,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                height: 18,
                width: 18,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Icon(Entypo.info_with_circle, color: blackShadeColor,size: 18,),
              ),
            )
          ],
        ),
        if(isShowInfo)
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            decoration: BoxDecoration(
              color: blackShadeColor,
              borderRadius: BorderRadius.circular(3)
            ),
            child: Text(
              widget.instructions,
              maxLines: 10,
              style: montserratRegular.copyWith(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}

