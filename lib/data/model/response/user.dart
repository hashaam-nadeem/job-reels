class Data {
  int? id;
  bool? selfPost;
  int? userId;
  String? title;
  String? description;
  String? portfolio;
  String? skill;
  List<String>? skills;
  String? upwork;
  String? fiverr;
  String? linkedin;
  String? instagram;
  String? facebook;
  String? youtube;
  String? tiktok;
  String? twitter;
  String? thumbnail;
  String? video;
  String? status;
  String? statusDescription;
  int? active;
  int? isFeatured;
  int? isApprovedByAdmin;
  bool? userLiked;
  bool? userSaved;
  bool? userFollowed;
  int? totalLikes;
  int? totalSaves;
  int? totalComments;
  User? user;

  Data(
      {this.id,
        this.selfPost,
        this.userId,
        this.title,
        this.description,
        this.portfolio,
        this.skill,
        this.skills,
        this.upwork,
        this.fiverr,
        this.linkedin,
        this.instagram,
        this.facebook,
        this.youtube,
        this.tiktok,
        this.twitter,
        this.thumbnail,
        this.video,
        this.status,
        this.statusDescription,
        this.active,
        this.isFeatured,
        this.isApprovedByAdmin,
        this.userLiked,
        this.userSaved,
        this.userFollowed,
        this.totalLikes,
        this.totalSaves,
        this.totalComments,
        this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    selfPost = json['self_post'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    portfolio = json['portfolio'];
    skill = json['skill'];
    skills = json['skills'].cast<String>();
    upwork = json['upwork'];
    fiverr = json['fiverr'];
    linkedin = json['linkedin'];
    instagram = json['instagram'];
    facebook = json['facebook'];
    youtube = json['youtube'];
    tiktok = json['tiktok'];
    twitter = json['twitter'];
    thumbnail = json['thumbnail'];
    video = json['video'];
    status = json['status'];
    statusDescription = json['status_description'];
    active = json['active'];
    isFeatured = json['is_featured'];
    isApprovedByAdmin = json['is_approved_by_admin'];
    userLiked = json['user_liked'];
    userSaved = json['user_saved'];
    userFollowed = json['user_followed'];
    totalLikes = json['total_likes'];
    totalSaves = json['total_saves'];
    totalComments = json['total_comments'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['self_post'] = selfPost;
    data['user_id'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['portfolio'] = portfolio;
    data['skill'] = skill;
    data['skills'] = skills;
    data['upwork'] = upwork;
    data['fiverr'] = fiverr;
    data['linkedin'] = linkedin;
    data['instagram'] = instagram;
    data['facebook'] = facebook;
    data['youtube'] = youtube;
    data['tiktok'] = tiktok;
    data['twitter'] = twitter;
    data['thumbnail'] = thumbnail;
    data['video'] = video;
    data['status'] = status;
    data['status_description'] = statusDescription;
    data['active'] = active;
    data['is_featured'] = isFeatured;
    data['is_approved_by_admin'] = isApprovedByAdmin;
    data['user_liked'] = userLiked;
    data['user_saved'] = userSaved;
    data['user_followed'] = userFollowed;
    data['total_likes'] = totalLikes;
    data['total_saves'] = totalSaves;
    data['total_comments'] = totalComments;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? uuid;
  Null? description;
  Null? businessName;
  String? firstName;
  String? lastName;
  Null? username;
  String? email;
  String? phone;
  String? state;
  String? city;
  String? address;
  Null? zipCode;
  Null? industry;
  Null? employeeId;
  int? active;
  String? profilePicture;
  int? activePublisher;
  String? type;
  int? totalFollowings;
  int? totalFollowers;
  bool? userFollowed;
  int? totalLikes;
  Freelancer? freelancer;
  String? createdAt;
  String? updatedAt;
  bool? isSubscribed;
  Null? trialEndsAt;
  Null? currentSubscription;

  User(
      {this.id,
        this.uuid,
        this.description,
        this.businessName,
        this.firstName,
        this.lastName,
        this.username,
        this.email,
        this.phone,
        this.state,
        this.city,
        this.address,
        this.zipCode,
        this.industry,
        this.employeeId,
        this.active,
        this.profilePicture,
        this.activePublisher,
        this.type,
        this.totalFollowings,
        this.totalFollowers,
        this.userFollowed,
        this.totalLikes,
        this.freelancer,
        this.createdAt,
        this.updatedAt,
        this.isSubscribed,
        this.trialEndsAt,
        this.currentSubscription});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    description = json['description'];
    businessName = json['business_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    zipCode = json['zip_code'];
    industry = json['industry'];
    employeeId = json['employee_id'];
    active = json['active'];
    profilePicture = json['profile_picture'];
    activePublisher = json['active_publisher'];
    type = json['type'];
    totalFollowings = json['total_followings'];
    totalFollowers = json['total_followers'];
    userFollowed = json['user_followed'];
    totalLikes = json['total_likes'];
    freelancer = json['freelancer'] != null
        ? Freelancer.fromJson(json['freelancer'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isSubscribed = json['is_subscribed'];
    trialEndsAt = json['trial_ends_at'];
    currentSubscription = json['current_subscription'];
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
    data['active'] = active;
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_subscribed'] = isSubscribed;
    data['trial_ends_at'] = trialEndsAt;
    data['current_subscription'] = currentSubscription;
    return data;
  }
}

class Freelancer {
  int? userId;
  String? photo;
  String? photoOfGovtId;
  String? photoOfGovtIdBack;
  String? photoWithGovtId;
  String? bills;
  String? portfolioWebsite;
  String? description;
  String? salaryRequirements;
  String? fullTime;
  Null? hourlyRate;
  String? skillsExperience;
  List<String>? skillsAssessment;
  String? upwork;
  String? fiverr;
  String? linkedin;
  String? instagram;
  String? facebook;
  String? youtube;
  String? tiktok;
  String? twitter;
  String? verificationLevel;
  String? dateOfBirth;
  int? age;
  String? gender;
  String? yearsExperience;
  int? verificationScore;
  String? jobTitle;

  Freelancer(
      {this.userId,
        this.photo,
        this.photoOfGovtId,
        this.photoOfGovtIdBack,
        this.photoWithGovtId,
        this.bills,
        this.portfolioWebsite,
        this.description,
        this.salaryRequirements,
        this.fullTime,
        this.hourlyRate,
        this.skillsExperience,
        this.skillsAssessment,
        this.upwork,
        this.fiverr,
        this.linkedin,
        this.instagram,
        this.facebook,
        this.youtube,
        this.tiktok,
        this.twitter,
        this.verificationLevel,
        this.dateOfBirth,
        this.age,
        this.gender,
        this.yearsExperience,
        this.verificationScore,
        this.jobTitle});

  Freelancer.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    photo = json['photo'];
    photoOfGovtId = json['photo_of_govt_id'];
    photoOfGovtIdBack = json['photo_of_govt_id_back'];
    photoWithGovtId = json['photo_with_govt_id'];
    bills = json['bills'];
    portfolioWebsite = json['portfolio_website'];
    description = json['description'];
    salaryRequirements = json['salary_requirements'];
    fullTime = json['full_time'];
    hourlyRate = json['hourly_rate'];
    skillsExperience = json['skills_experience'];
    skillsAssessment = json['skills_assessment'].cast<String>();
    upwork = json['upwork'];
    fiverr = json['fiverr'];
    linkedin = json['linkedin'];
    instagram = json['instagram'];
    facebook = json['facebook'];
    youtube = json['youtube'];
    tiktok = json['tiktok'];
    twitter = json['twitter'];
    verificationLevel = json['verification_level'];
    dateOfBirth = json['date_of_birth'];
    age = json['age'];
    gender = json['gender'];
    yearsExperience = json['years_experience'];
    verificationScore = json['verification_score'];
    jobTitle = json['job_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['photo'] = photo;
    data['photo_of_govt_id'] = photoOfGovtId;
    data['photo_of_govt_id_back'] = photoOfGovtIdBack;
    data['photo_with_govt_id'] = photoWithGovtId;
    data['bills'] = bills;
    data['portfolio_website'] = portfolioWebsite;
    data['description'] = description;
    data['salary_requirements'] = salaryRequirements;
    data['full_time'] = fullTime;
    data['hourly_rate'] = hourlyRate;
    data['skills_experience'] = skillsExperience;
    data['skills_assessment'] = skillsAssessment;
    data['upwork'] = upwork;
    data['fiverr'] = fiverr;
    data['linkedin'] = linkedin;
    data['instagram'] = instagram;
    data['facebook'] = facebook;
    data['youtube'] = youtube;
    data['tiktok'] = tiktok;
    data['twitter'] = twitter;
    data['verification_level'] = verificationLevel;
    data['date_of_birth'] = dateOfBirth;
    data['age'] = age;
    data['gender'] = gender;
    data['years_experience'] = yearsExperience;
    data['verification_score'] = verificationScore;
    data['job_title'] = jobTitle;
    return data;
  }
}
class Autogenerated {
  String? message;
  List<Data>? data;

  Autogenerated({this.message, this.data});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  bool? selfPost;
  int? userId;
  String? title;
  String? description;
  String? portfolio;
  String? skill;
  List<String>? skills;
  String? upwork;
  String? fiverr;
  String? linkedin;
  String? instagram;
  String? facebook;
  String? youtube;
  String? tiktok;
  String? twitter;
  String? thumbnail;
  String? video;
  String? status;
  String? statusDescription;
  int? active;
  int? isFeatured;
  int? isApprovedByAdmin;
  bool? userLiked;
  bool? userSaved;
  bool? userFollowed;
  int? totalLikes;
  int? totalSaves;
  int? totalComments;
  User? user;

  Data(
      {this.id,
        this.selfPost,
        this.userId,
        this.title,
        this.description,
        this.portfolio,
        this.skill,
        this.skills,
        this.upwork,
        this.fiverr,
        this.linkedin,
        this.instagram,
        this.facebook,
        this.youtube,
        this.tiktok,
        this.twitter,
        this.thumbnail,
        this.video,
        this.status,
        this.statusDescription,
        this.active,
        this.isFeatured,
        this.isApprovedByAdmin,
        this.userLiked,
        this.userSaved,
        this.userFollowed,
        this.totalLikes,
        this.totalSaves,
        this.totalComments,
        this.user});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    selfPost = json['self_post'];
    userId = json['user_id'];
    title = json['title'];
    description = json['description'];
    portfolio = json['portfolio'];
    skill = json['skill'];
    skills = json['skills'].cast<String>();
    upwork = json['upwork'];
    fiverr = json['fiverr'];
    linkedin = json['linkedin'];
    instagram = json['instagram'];
    facebook = json['facebook'];
    youtube = json['youtube'];
    tiktok = json['tiktok'];
    twitter = json['twitter'];
    thumbnail = json['thumbnail'];
    video = json['video'];
    status = json['status'];
    statusDescription = json['status_description'];
    active = json['active'];
    isFeatured = json['is_featured'];
    isApprovedByAdmin = json['is_approved_by_admin'];
    userLiked = json['user_liked'];
    userSaved = json['user_saved'];
    userFollowed = json['user_followed'];
    totalLikes = json['total_likes'];
    totalSaves = json['total_saves'];
    totalComments = json['total_comments'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['self_post'] = selfPost;
    data['user_id'] = userId;
    data['title'] = title;
    data['description'] = description;
    data['portfolio'] = portfolio;
    data['skill'] = skill;
    data['skills'] = skills;
    data['upwork'] = upwork;
    data['fiverr'] = fiverr;
    data['linkedin'] = linkedin;
    data['instagram'] = instagram;
    data['facebook'] = facebook;
    data['youtube'] = youtube;
    data['tiktok'] = tiktok;
    data['twitter'] = twitter;
    data['thumbnail'] = thumbnail;
    data['video'] = video;
    data['status'] = status;
    data['status_description'] = statusDescription;
    data['active'] = active;
    data['is_featured'] = isFeatured;
    data['is_approved_by_admin'] = isApprovedByAdmin;
    data['user_liked'] = userLiked;
    data['user_saved'] = userSaved;
    data['user_followed'] = userFollowed;
    data['total_likes'] = totalLikes;
    data['total_saves'] = totalSaves;
    data['total_comments'] = totalComments;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? uuid;
  Null? description;
  Null? businessName;
  String? firstName;
  String? lastName;
  Null? username;
  String? email;
  String? phone;
  String? state;
  String? city;
  String? address;
  Null? zipCode;
  Null? industry;
  Null? employeeId;
  int? active;
  String? profilePicture;
  int? activePublisher;
  String? type;
  int? totalFollowings;
  int? totalFollowers;
  bool? userFollowed;
  int? totalLikes;
  Freelancer? freelancer;
  String? createdAt;
  String? updatedAt;
  bool? isSubscribed;
  Null? trialEndsAt;
  Null? currentSubscription;

  User(
      {this.id,
        this.uuid,
        this.description,
        this.businessName,
        this.firstName,
        this.lastName,
        this.username,
        this.email,
        this.phone,
        this.state,
        this.city,
        this.address,
        this.zipCode,
        this.industry,
        this.employeeId,
        this.active,
        this.profilePicture,
        this.activePublisher,
        this.type,
        this.totalFollowings,
        this.totalFollowers,
        this.userFollowed,
        this.totalLikes,
        this.freelancer,
        this.createdAt,
        this.updatedAt,
        this.isSubscribed,
        this.trialEndsAt,
        this.currentSubscription});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    description = json['description'];
    businessName = json['business_name'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    state = json['state'];
    city = json['city'];
    address = json['address'];
    zipCode = json['zip_code'];
    industry = json['industry'];
    employeeId = json['employee_id'];
    active = json['active'];
    profilePicture = json['profile_picture'];
    activePublisher = json['active_publisher'];
    type = json['type'];
    totalFollowings = json['total_followings'];
    totalFollowers = json['total_followers'];
    userFollowed = json['user_followed'];
    totalLikes = json['total_likes'];
    freelancer = json['freelancer'] != null
        ? Freelancer.fromJson(json['freelancer'])
        : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isSubscribed = json['is_subscribed'];
    trialEndsAt = json['trial_ends_at'];
    currentSubscription = json['current_subscription'];
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
    data['active'] = active;
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
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_subscribed'] = isSubscribed;
    data['trial_ends_at'] = trialEndsAt;
    data['current_subscription'] = currentSubscription;
    return data;
  }
}

class Freelancer {
  int? userId;
  String? photo;
  String? photoOfGovtId;
  String? photoOfGovtIdBack;
  String? photoWithGovtId;
  String? bills;
  String? portfolioWebsite;
  String? description;
  String? salaryRequirements;
  String? fullTime;
  String? hourlyRate;
  String? skillsExperience;
  List<String>? skillsAssessment;
  String? upwork;
  String? fiverr;
  String? linkedin;
  String? instagram;
  String? facebook;
  String? youtube;
  String? tiktok;
  String? twitter;
  String? verificationLevel;
  String? dateOfBirth;
  int? age;
  String? gender;
  String? yearsExperience;
  int? verificationScore;
  String? jobTitle;

  Freelancer(
      {this.userId,
        this.photo,
        this.photoOfGovtId,
        this.photoOfGovtIdBack,
        this.photoWithGovtId,
        this.bills,
        this.portfolioWebsite,
        this.description,
        this.salaryRequirements,
        this.fullTime,
        this.hourlyRate,
        this.skillsExperience,
        this.skillsAssessment,
        this.upwork,
        this.fiverr,
        this.linkedin,
        this.instagram,
        this.facebook,
        this.youtube,
        this.tiktok,
        this.twitter,
        this.verificationLevel,
        this.dateOfBirth,
        this.age,
        this.gender,
        this.yearsExperience,
        this.verificationScore,
        this.jobTitle});

  Freelancer.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    photo = json['photo'];
    photoOfGovtId = json['photo_of_govt_id'];
    photoOfGovtIdBack = json['photo_of_govt_id_back'];
    photoWithGovtId = json['photo_with_govt_id'];
    bills = json['bills'];
    portfolioWebsite = json['portfolio_website'];
    description = json['description'];
    salaryRequirements = json['salary_requirements'];
    fullTime = json['full_time'];
    hourlyRate = json['hourly_rate'];
    skillsExperience = json['skills_experience'];
    skillsAssessment = json['skills_assessment'].cast<String>();
    upwork = json['upwork'];
    fiverr = json['fiverr'];
    linkedin = json['linkedin'];
    instagram = json['instagram'];
    facebook = json['facebook'];
    youtube = json['youtube'];
    tiktok = json['tiktok'];
    twitter = json['twitter'];
    verificationLevel = json['verification_level'];
    dateOfBirth = json['date_of_birth'];
    age = json['age'];
    gender = json['gender'];
    yearsExperience = json['years_experience'];
    verificationScore = json['verification_score'];
    jobTitle = json['job_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['photo'] = photo;
    data['photo_of_govt_id'] = photoOfGovtId;
    data['photo_of_govt_id_back'] = photoOfGovtIdBack;
    data['photo_with_govt_id'] = photoWithGovtId;
    data['bills'] = bills;
    data['portfolio_website'] = portfolioWebsite;
    data['description'] = description;
    data['salary_requirements'] = salaryRequirements;
    data['full_time'] = fullTime;
    data['hourly_rate'] = hourlyRate;
    data['skills_experience'] = skillsExperience;
    data['skills_assessment'] = skillsAssessment;
    data['upwork'] = upwork;
    data['fiverr'] = fiverr;
    data['linkedin'] = linkedin;
    data['instagram'] = instagram;
    data['facebook'] = facebook;
    data['youtube'] = youtube;
    data['tiktok'] = tiktok;
    data['twitter'] = twitter;
    data['verification_level'] = verificationLevel;
    data['date_of_birth'] = dateOfBirth;
    data['age'] = age;
    data['gender'] = gender;
    data['years_experience'] = yearsExperience;
    data['verification_score'] = verificationScore;
    data['job_title'] = jobTitle;
    return data;
  }
}