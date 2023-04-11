class UserInfoModel {
  String name;
  String email;
  String password;
  String type;
  String phone;
  String address;
  String tokenType;
  String expireAt;
  String accessToken;
  bool isVerified;
  int expireIn;

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
        required this.password,
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
      expireIn : json['expires_in']?? 0,

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
    data['email_verified_at'] = isVerified?"05-10-2022":null;
    return data;
  }
}
