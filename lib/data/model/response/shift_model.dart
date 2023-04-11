import 'package:workerapp/data/model/response/document_model.dart';
import 'package:workerapp/data/model/response/participantTag_model.dart';

import 'break_detail_model.dart';

class ShiftModel {
  String code;
  String name;
  String address;
  String startTime;
  String endTime;
  String startDate;
  String endDate;
  String logInTime;
  String logOuTime;
  String profile;
  String status;
  int totalHours;
  List<ParticipantTag> participantTag;
  BreakDetailModel? breakDetailModel;
  String jobDescription;
  String taskList;
  String note;
  List<DocumentModel> documentModel;
  // bool ?hasAnyIssue;
  // bool ?isCompleted;


  ShiftModel(
      {
        required this.code,
        required this.name,
        required this.startTime,
        required this.endTime,
        required this.startDate,
        required this.endDate,
        required this.logInTime,
        required this.logOuTime,
        required this.profile,
        required this.address,
        required this.status,
        required this.totalHours,
        required this.participantTag,
        required this.breakDetailModel,
        required this.jobDescription,
        required this.taskList,
        required this.note,
        required this.documentModel,
        // this.hasAnyIssue,
        // this.isCompleted,
      });
//
  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    Map<String,dynamic>? breakDetail = json['break_details'];
    return ShiftModel(
      code : json['code'],
      name : json['name'],
      startTime : json['start_time'],
      endTime : json['end_time']??"",
      startDate : json['start_date']??"",
      endDate : json['end_date']??"",
      logInTime : json['login_at']??"",
      logOuTime : json['logout_at']??"",
      profile : json['profile']??"",
      address : json['address']??"",
      status : json['status']??"",
      totalHours : json['total_hour'] ?? 0,
      jobDescription : json['job_description']??"",
      taskList : json['task_list']??"",
      note : json['note']??"",
      breakDetailModel :breakDetail!=null? BreakDetailModel.fromJson(breakDetail):null,
      participantTag : json['participant_tags']!=null?List<ParticipantTag>.from(json['participant_tags'].map((model)=> ParticipantTag.fromJson(model))):[],
      documentModel : json['documents']!=null?List<DocumentModel>.from(json['documents'].map((model)=> DocumentModel.fromJson(model))):[],
    );
  }
//
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['name'] = name;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['login_at'] = logInTime;
    data['logout_at'] = logOuTime;
    data['address'] = address;
    data['profile'] = profile;
    data['status'] = status;
    data['status'] = totalHours;
    data['job_description'] = jobDescription;
    data['task_list'] = taskList;
    data['note'] = note;
    return data;
  }
}
