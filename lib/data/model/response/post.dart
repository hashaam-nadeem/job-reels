import 'dart:io';

import 'package:jobreels/data/model/response/social_media_links.dart';
import 'package:jobreels/data/model/response/user.dart';
import 'package:jobreels/helper/helper.dart';
import 'package:jobreels/util/app_constants.dart';
import 'package:video_player/video_player.dart';

class Post {
  int? id;
  int? userId;
  String title;
  String description;
  String? portfolio;
  String? skill;
  List<String> skills;
  SocialLinks socialLinks;
  String thumbnail;
  Future<File?> thumbnailFuture;
  Future<File> videoFuture;
  String video;
  String? status;
  String? statusDescription;
  bool isActive;
  bool isFeatured;
  bool isApprovedByAdmin;
  bool userSaved;
  bool userFollowed;
  int totalLikes;
  int totalSaves;
  User? user;
  Duration videoPlayDuration;

  Post({
    this.id,
    this.userId,
    required this.title,
    this.description='',
    this.portfolio,
    this.videoPlayDuration = const Duration(seconds: 0),
    this.skill,
    List<String> ?skills,
    required this.socialLinks,
    required this.thumbnail,
    required this.thumbnailFuture,
    required this.videoFuture,
    required this.video,
    this.status,
    this.statusDescription,
    this.isActive = false,
    this.isFeatured = false,
    this.isApprovedByAdmin = false,
    this.userSaved = false,
    this.userFollowed = false,
    this.totalLikes = 0,
    this.totalSaves = 0,
    this.user
  }): skills = skills??<String>[];

  factory Post.fromJson(Map<String, dynamic> json) {
    String thumbnail = json['thumbnail'];
    String video = json['video'];
    Future<File?> imgFuture = getDownloadedFile(imageUrl: thumbnail,);
    Future<File> videoFuture = cacheManager.getSingleFile(video, key: video);
    return Post(
      id : json['id'],
      userId : json['user_id'],
      title : json['title']??"",
      description : json['description']??"",
      portfolio : json['portfolio'],
      skill : json['skill'],
      skills : (json['skills']??[]).cast<String>(),
      socialLinks:  SocialLinks.fromJson(json)??SocialLinks(upwork: SocialMedia(name:"" ,url: ""), fiverr: SocialMedia(name:"" ,url: ""), linkedIn: SocialMedia(name:"" ,url: ""), instagram: SocialMedia(name:"" ,url: ""), facebook: SocialMedia(name:"" ,url: ""), youtube: SocialMedia(name:"" ,url: ""), tiktok: SocialMedia(name:"" ,url: ""), twitter: SocialMedia(name:"" ,url: "")),
      thumbnail : thumbnail,
      thumbnailFuture : imgFuture,
      videoFuture : videoFuture,
      video : json['video'],
      status : json['status'],
      statusDescription : json['status_description'],
      isActive : json['active']==1,
      isFeatured : json['is_featured']==1,
      isApprovedByAdmin : json['is_approved_by_admin']==1,
      userSaved : json['user_saved'],
      userFollowed : json['user_followed'],
      totalLikes : json['total_likes'],
      totalSaves : json['total_saves'],
      user : json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['portfolio'] = portfolio;
    data['skill'] = skill;
    data['skills'] = skills;
    data['upwork'] = socialLinks.upwork;
    data['fiverr'] = socialLinks.fiverr;
    data['linkedin'] = socialLinks.linkedIn;
    data['instagram'] = socialLinks.instagram;
    data['facebook'] = socialLinks.facebook;
    data['youtube'] = socialLinks.youtube;
    data['tiktok'] = socialLinks.tiktok;
    data['twitter'] = socialLinks.twitter;
    data['thumbnail'] = thumbnail;
    data['video'] = video;
    data['status'] = status;
    data['status_description'] = statusDescription;
    data['active'] = isActive;
    data['is_featured'] = isFeatured;
    data['is_approved_by_admin'] = isApprovedByAdmin;
    data['user_saved'] = userSaved;
    data['user_followed'] = userFollowed;
    data['total_likes'] = totalLikes;
    data['total_saves'] = totalSaves;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}