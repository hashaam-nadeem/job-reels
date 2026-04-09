import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../response/social_media_links.dart';

class PostForm{
  int ?postId;
  String title;
  String description;
  String ?portfolio;
  String ?videoFilePath;
  List<String> listSkills;
  SocialLinks socialLinks;

  PostForm({
    this.postId,
    required this.title,
    required this.description,
    this.portfolio,
    this.videoFilePath,
    required this.listSkills,
    required this.socialLinks,
  });

  Future<FormData> toApiBody() async{
    Map<String, dynamic> data = {};
    data['title'] = title;
    data['description'] = description;
    data['portfolio'] = portfolio;
    data['upwork'] = socialLinks.upwork.url;
    data['fiverr'] = socialLinks.fiverr.url;
    data['linkedin'] = socialLinks.linkedIn.url;
    data['youtube'] = socialLinks.youtube.url;
    data['instagram'] = socialLinks.instagram.url;
    data['facebook'] = socialLinks.facebook.url;
    data['tiktok'] = socialLinks.tiktok.url;
    data['twitter'] = socialLinks.twitter.url;
    data['skill[]'] = listSkills;
    FormData formData = FormData.fromMap(data);
    MultipartFile ?multiPartFile;

    if(videoFilePath!=null){
      multiPartFile = await MultipartFile.fromFile(videoFilePath!, filename: videoFilePath!.split('/').last,);
      formData.files.addAll({
        MapEntry<String, MultipartFile>('video', multiPartFile),
      });
      MultipartFile ?thumbnailMultiPartFile;
      final Uint8List ?uint8List = await VideoThumbnail.thumbnailData(
        video: videoFilePath!,
        imageFormat: ImageFormat.JPEG,
        maxWidth: (getx.Get.context?.width ?? 300).toInt(), // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      if(uint8List!=null){

        Directory tempDir = await getTemporaryDirectory();
        String tempFilePath = '${tempDir.path}/temp_file.txt';
        final thumbnailFile = File(tempFilePath);
        thumbnailFile.writeAsBytesSync(uint8List);
        thumbnailMultiPartFile = await MultipartFile.fromFile(thumbnailFile.path, filename: thumbnailFile.path.split("/").last);
        formData.files.addAll({
          MapEntry<String, MultipartFile>('thumbnail', thumbnailMultiPartFile),
        });
      }
    }
    return formData;
  }


}