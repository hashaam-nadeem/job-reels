import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/controller/auth_controller.dart';

import 'freelancer.dart';

class User {
  int? id;
  String? uuid;
  String description;
  String? businessName;
  String firstName;
  String lastName;
  String? username;
  String? email;
  String? phone;
  String? state;
  String? city;
  String? address;
  String? zipCode;
  String? industry;
  String? employeeId;
  bool isActive;
  String? profilePicture;
  bool activePublisher;
  bool isFreelancer;
  String? type;
  int totalFollowings;
  int totalFollowers;
  bool userFollowed;
  int totalLikes;
  Freelancer? freelancer;
  bool isSubscribed;
  bool isVerified;
  String? currentSubscription;
  bool isEmailHide;
  bool isPhoneNumberHide;

  User({
    this.id,
    this.uuid,
    required this.description,
    this.businessName,
    this.firstName='',
    this.lastName='',
    this.username,
    this.email,
    this.phone,
    this.state,
    this.city,
    this.address,
    this.zipCode,
    this.industry,
    this.employeeId,
    this.isActive = false,
    this.profilePicture,
    this.activePublisher = false,
    this.type,
    this.isFreelancer = false,
    this.totalFollowings = 0,
    this.totalFollowers = 0,
    this.userFollowed=false,
    this.totalLikes = 0,
    this.freelancer,
    this.isEmailHide=false,
    this.isPhoneNumberHide=false,
    this.isSubscribed = false,
    this.currentSubscription,
    this.isVerified = true,
  });

  factory User.fromJson(Map<String, dynamic> json,) {
    print("isEmailHide.....${json['is_email_private']}");
    print("isPhoneNumberHide.....${json['is_phone_private']}");
    return User(
      id : json['id'],
      uuid : json['uuid'],
      description : json['description']??"",
      businessName : json['business_name'],
      firstName : json['first_name']??"",
      lastName : json['last_name']??"",
      username : json['username'],
      email : json['email'],
      phone : json['phone'],
      state : json['state'],
      city : json['city'],
      address : json['address'],
      zipCode : json['zip_code'],
      industry : json['industry'],
      employeeId : json['employee_id'],
      isActive : json['active']==1,
      profilePicture : json['profile_picture'],
      activePublisher : json['active_publisher']==1,
      type : json['type'],
      isFreelancer: json['freelancer'] != null,
      totalFollowings : json['total_followings']??0,
      totalFollowers : json['total_followers']??0,
      isEmailHide : json['is_email_private']==1,
      isPhoneNumberHide : json['is_phone_private']==1,
      userFollowed : json['user_followed']??false,
      totalLikes : json['total_likes'] ?? 0,
          freelancer : json['freelancer'] != null ? Freelancer.fromJson(json['freelancer']) : null,
      isSubscribed :  json['is_subscribed']==1,
      currentSubscription : json['current_subscription'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['uuid'] = uuid;
    data['description'] = description;
    data['business_name'] = businessName;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['username'] = username;
    data['email'] = email;
    data['phone'] = phone;
    data['state'] = state;
    data['city'] = city;
    data['address'] = address;
    data['zip_code'] = zipCode;
    data['industry'] = industry;
    data['employee_id'] = employeeId;
    data['active'] = isActive;
    data['is_email_private'] = isEmailHide?1:0;
    data['is_phone_private'] = isPhoneNumberHide?1:0;
    data['profile_picture'] = profilePicture;
    data['active_publisher'] = activePublisher;
    data['type'] = type;
    data['total_followings'] = totalFollowings;
    data['total_followers'] = totalFollowers;
    data['user_followed'] = userFollowed;
    data['total_likes'] = totalLikes;
    if (freelancer != null) {
      data['freelancer'] = freelancer!.toJson();
    }
    data['is_subscribed'] = isSubscribed;
    data['current_subscription'] = currentSubscription;
    return data;
  }
}