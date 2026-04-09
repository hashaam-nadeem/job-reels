import 'package:flutter/material.dart';
import 'dart:io';

class UserSingleton {
  static final UserSingleton _singleton = UserSingleton._internal();
  UserSingleton._internal();
  static UserSingleton get instance => _singleton;
  //late UserModelTwo user;
  var token = "";
  var counter = 0;
  var navigatorKey;
  var viewId = '';
  var userId = "";
  File? videoFile;
  var userType = "company";
}
