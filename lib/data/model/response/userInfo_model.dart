import 'document_model.dart';

class UserInfoModel {
  String name;
  String email;
  String password;
  String profilePic;
  String type;
  String phone;
  String address;
  String tokenType;
  String expireAt;
  String accessToken;
  int totalShift;
  int cancelledShift;
  int documentExpiring;
  String expiryMessage;
  String nextShiftMessage;
  List<DocumentModel> documents;
  bool isVerified;
  int expireIn;
  int allowedRadius;
  int allowedTime;

  UserInfoModel(
      {
        required this.name,
        required this.email,
        required this.tokenType,
        required this.expireAt,
        required this.accessToken,
        required this.isVerified,
        required this.type,
        required this.expireIn,
        required this.address,
        required this.phone,
        required this.profilePic,
        required this.password,
        required this.totalShift,
        required this.cancelledShift,
        required this.expiryMessage,
        required this.documents,
        required this.documentExpiring,
        required this.nextShiftMessage,
        required this.allowedRadius,
        required this.allowedTime,
      });
//
  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      name : json['name'],
      email : json['email'],
      tokenType : json['token_type']??"",
      expireAt : json['expires_at']??"",
      accessToken : json['access_token']??"",
      isVerified : json['email_verified_at']!= null,
      type : json['type']??"",
      phone : json['phone']??"",
      address : json['address']??"",
      password : json['password']??"",
      totalShift : json['total_shift']??0,
      cancelledShift : json['cancelled_shift']??0,
      documentExpiring : json['document_expiring']??0,
      expiryMessage : json['expiry_message']??"",
      nextShiftMessage : json['next_shift_message']??"",
      profilePic : json['profile']??"",
      documents : json['documents']!=null?List<DocumentModel>.from(json['documents'].map((model)=> DocumentModel.fromJson(model))):[],
      expireIn : json['expires_in']?? 0,
      allowedRadius: json['allowed_radius']??100,
      allowedTime: json['allowed_time']??10
    );
  }
//
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['token_type'] = tokenType;
    data['access_token'] = accessToken;
    data['type'] = type;
    data['expireIn'] = expireIn;
    data['phone'] = phone;
    data['address'] = address;
    data['password'] = password;
    data['total_shift'] = totalShift;
    data['cancelled_shift'] = cancelledShift;
    data['document_expiring'] = documentExpiring;
    data['expiry_message'] = expiryMessage;
    data['profile'] = profilePic;
    data['allowed_time'] = allowedTime;
    data['allowed_radius'] = allowedRadius;
    data['email_verified_at'] = isVerified?"05-10-2022":null;
    return data;
  }
}
