import 'package:workerapp/data/model/response/document_model.dart';
import 'package:workerapp/data/model/response/participantTag_model.dart';

import 'break_detail_model.dart';

class ClientModel {

  String name;
  String address;
  String alert;
  List<ParticipantTag> participantTag;
  // BreakDetailModel? breakDetailModel;
  // String jobDescription;
  // String taskList;
  // String note;
  // List<DocumentModel> documentModel;
  // bool ?hasAnyIssue;
  // bool ?isCompleted;


  ClientModel(
      {

        required this.name,
        required this.address,
        required this.alert,
        required this.participantTag,
        // required this.breakDetailModel,
        // required this.jobDescription,
        // required this.taskList,
        // required this.note,
        // required this.documentModel,
        // this.hasAnyIssue,
        // this.isCompleted,
      });
//
  factory ClientModel.fromJson(Map<String, dynamic> json) {
    Map<String,dynamic>? breakDetail = json['break_details'];
    return ClientModel(
      name : json['name'],
      address : json['address']??"",
      alert : json['alert']??"",
      participantTag : json['participant_tags']!=null?List<ParticipantTag>.from(json['participant_tags'].map((model)=> ParticipantTag.fromJson(model))):[],
      // status : json['status']??"",
      // totalHours : json['total_hour'] ?? 0,
      // jobDescription : json['job_description']??"",
      // taskList : json['task_list']??"",
      // note : json['note']??"",
      // breakDetailModel :breakDetail!=null? BreakDetailModel.fromJson(breakDetail):null,
       // documentModel : json['documents']!=null?List<DocumentModel>.from(json['documents'].map((model)=> DocumentModel.fromJson(model))):[],
    );
  }
//

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['alert'] = alert;
    data['participant_tags'] = participantTag;
    return data;
  }
}
