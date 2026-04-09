import 'package:jobreels/data/model/response/social_media_links.dart';

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
  String fullTime;
  String? hourlyRate;
  String? skillsExperience;
  List<String> skillsAssessment;
  SocialLinks socialLinks;
  String? verificationLevel;
  String? dateOfBirth;
  int? age;
  String? gender;
  String yearsExperience;
  int? verificationScore;
  String? jobTitle;

  Freelancer({
    this.userId,
    this.photo,
    this.photoOfGovtId,
    this.photoOfGovtIdBack,
    this.photoWithGovtId,
    this.bills,
    this.portfolioWebsite,
    this.description,
    this.salaryRequirements,
    required this.fullTime,
    this.hourlyRate,
    this.skillsExperience,
    List<String> ?skillsAssessment,
    required this.socialLinks,
    this.verificationLevel,
    this.dateOfBirth,
    this.age,
    this.gender,
    required this.yearsExperience,
    this.verificationScore,
    this.jobTitle,
  }): skillsAssessment = skillsAssessment??<String>[] ;

  factory Freelancer.fromJson(Map<String, dynamic> json) {
    return Freelancer(
      userId : json['user_id'],
      photo : json['photo'],
      photoOfGovtId : json['photo_of_govt_id'],
      photoOfGovtIdBack : json['photo_of_govt_id_back'],
      photoWithGovtId : json['photo_with_govt_id'],
      bills : json['bills'],
      portfolioWebsite : json['portfolio_website'],
      description : json['description'],
      salaryRequirements : json['salary_requirements'],
      fullTime : json['full_time']??'Any',
      hourlyRate : json['hourly_rate'],
      skillsExperience : json['skills_experience'],
      skillsAssessment : json['skills_assessment'].cast<String>(),
      socialLinks: SocialLinks.fromJson(json),
      verificationLevel : json['verification_level'],
      dateOfBirth : json['date_of_birth'],
      age : json['age'],
      gender : json['gender'],
      yearsExperience : json['years_experience']??"",
      verificationScore : json['verification_score'],
      jobTitle : json['job_title'],
    );
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
    data['upwork'] = socialLinks.upwork?.url;
    data['fiverr'] = socialLinks.fiverr?.url;
    data['linkedin'] = socialLinks.linkedIn?.url;
    data['instagram'] = socialLinks.instagram?.url;
    data['facebook'] = socialLinks.facebook?.url;
    data['youtube'] = socialLinks.youtube?.url;
    data['tiktok'] = socialLinks.tiktok?.url;
    data['twitter'] = socialLinks.twitter?.url;
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