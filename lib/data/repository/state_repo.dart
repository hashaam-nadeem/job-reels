import 'dart:convert';
import 'package:get/get.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/data/api/Api_Handler/api_call_Structure.dart';
import 'package:jobreels/data/api/Api_Handler/api_constants.dart';
import 'package:jobreels/data/model/body/post_upload.dart';
import 'package:jobreels/data/model/response/user.dart';
import 'package:jobreels/enums/country.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart' as ApiClient;
import '../../enums/report_type.dart';
import '../../util/app_constants.dart';

class StateRepo {
  final SharedPreferences sharedPreferences;
  StateRepo({required this.sharedPreferences});

  Future<Map<String,dynamic>> getStateList(Country country)async{
    API_STRUCTURE apiObject = API_STRUCTURE(
      apiUrl: "${AppConstants.getStates}${country==Country.Philippines ? country.name:""}",
      apiRequestMethod: API_REQUEST_METHOD.GET,
      isWantSuccessMessage: false,
    );
    return await apiObject.requestAPI(isShowLoading: false,isCheckAuthorization: false);
  }
}
