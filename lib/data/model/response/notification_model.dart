import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:glow_solar/data/model/response/request_model.dart';

class Notifications {
  int id;
  String title;
  String time;
  bool isRead;
  ChargerRequest ?chargerRequest;

  Notifications({
    required this.id,
    required this.title,
    required this.chargerRequest,
    required this.time,
    required this.isRead,
  });

  factory Notifications.fromLocalJson(json) {
    Map<String,dynamic> ? chargingRequest = json['charging_request'];
    return Notifications(
      id:json['id'],
      title:json['message']??"",
      time:json['created_at']??"",
      isRead:json['read_status']==1,
      chargerRequest: chargingRequest!=null? ChargerRequest.fromLocalJson(chargingRequest):null,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['message'] = title;
    data['created_at'] = time;
    data['additional_data'] = chargerRequest;
    data['read_status'] = isRead?1:0;
    return data;
  }

}