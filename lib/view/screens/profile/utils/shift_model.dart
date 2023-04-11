import 'package:workerapp/utils/app_images.dart';

class ShitTimeDetailsModel{
  final String date;
  final String month;
  final String shiftTime;
  final String loginTime;
  final String ?logoutTime;
  final String shiftName;
  final String shiftAddress;
  final List<String> shiftMembersProfilePicList;
  bool ?hasAnyIssue;
  bool ?isCompleted;

  ShitTimeDetailsModel({
    required this.date,
    required this.month,
    required this.shiftTime,
    required this.loginTime,
    required this.logoutTime,
    required this.shiftName,
    required this.shiftAddress,
    required this.shiftMembersProfilePicList,
    this.hasAnyIssue,
    this.isCompleted,
  });
}

List<ShitTimeDetailsModel> shitTimeDetailsList=[
  ShitTimeDetailsModel(date: "6", month: "Jun", shiftTime: "6:30 AM - 8:30 AM", loginTime: "6:30 AM", logoutTime: "8:30 AM", shiftName: "Ms. Alix Tamayo", shiftAddress: "1 Queen Street, Campbelltown, NSW, 2560", shiftMembersProfilePicList: [Images.defaultProfile2],isCompleted: true),
  ShitTimeDetailsModel(date: "10", month: "Jun", shiftTime: "6:30 AM - 8:30 AM", loginTime: "6:30 AM", logoutTime: null, shiftName: "Granville Group Home", shiftAddress: "1 Queen Street, Campbelltown, NSW, 2560", shiftMembersProfilePicList: [Images.defaultProfile,Images.defaultProfile2,Images.defaultProfile2,Images.defaultProfile2,],hasAnyIssue: true),
  ShitTimeDetailsModel(date: "11", month: "Jun", shiftTime: "6:30 AM - 8:30 AM", loginTime: "6:30 AM", logoutTime: "8:30 AM", shiftName: "Ms. Alix Tamayo", shiftAddress: "1 Queen Street, Campbelltown, NSW, 2560", shiftMembersProfilePicList: [Images.defaultProfile2],isCompleted: true),
  ShitTimeDetailsModel(date: "12", month: "Jun", shiftTime: "6:30 AM - 8:30 AM", loginTime: "6:30 AM", logoutTime: null, shiftName: "Granville Group Home", shiftAddress: "1 Queen Street, Campbelltown, NSW, 2560", shiftMembersProfilePicList: [Images.defaultProfile,Images.defaultProfile2,],hasAnyIssue: true),
];