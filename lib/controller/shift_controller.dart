
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:workerapp/data/model/response/shift_model.dart';
import 'package:workerapp/view/base/custom_snackbar.dart';

import '../data/api/Api_Handler/api_error_response.dart';
import '../data/model/response/shift_availability_model.dart';
import '../data/repositry/shift_repo.dart';
import 'bottom_bar_controller.dart';

class ShiftController extends GetxController implements GetxService {
  final ShiftRepo shiftRepo;
  ShiftController({required this.shiftRepo});
  bool _isFetchingData = true;
  bool _isPageFetchingData = true;
  bool get isPageFetchingData => _isPageFetchingData;
  bool get isDataFetching => _isFetchingData;
  final List<ShiftModel> _shiftListByDate = [];
  final List<ShiftModel> _shiftList = [];
  List<ShiftModel> get shiftList => _shiftList;
  List<ShiftModel> get shiftListsByDate => _shiftListByDate;
  ShiftModel? _shiftModel;
  ShiftModel? get shiftModel => _shiftModel;
  List<ShiftAvailabilityModel> _shiftAvailabilityModel=[];
  List<ShiftAvailabilityModel> get shiftAvailabilityModel => _shiftAvailabilityModel;
  String? _fileName;
  String? get fileName=>_fileName;
  Future<void> fetchShiftByDate(String date) async {
    _isFetchingData = true;
    update();
    Map<String,dynamic> response = await shiftRepo.fetchShiftsByDate(date:date);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      _shiftListByDate.clear();
      List<dynamic> listCharger = response[API_RESPONSE.SUCCESS]['data'];
      for(var data in listCharger){
        _shiftListByDate.insert(0,ShiftModel.fromJson(data));
      }
    }
    _isFetchingData = false;
    update();
  }

  Future<void> fetchShift() async {
    _isFetchingData = true;
    update();
    Map<String,dynamic> response = await shiftRepo.fetchShifts();
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      _shiftList.clear();
      List<dynamic> listCharger = response[API_RESPONSE.SUCCESS]['data'];
      for(var data in listCharger){
        _shiftList.insert(0,ShiftModel.fromJson(data));
      }
    }
    _isFetchingData = false;
    update();
  }

  Future<Map<String, dynamic>> fetchShiftDetail({required String code}) async {
    _isFetchingData = true;
    update();
    Map<String,dynamic> response = await shiftRepo.fetchShiftDetails(code: code);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
       _shiftModel = ShiftModel.fromJson(response[API_RESPONSE.SUCCESS]['data']);
       print("shiftModel...........................>${_shiftModel?.code}");
      // for(var data in listCharger){
      //   _shiftList.insert(0,ShiftModel.fromJson(data));
      // }
    }
    update();
    return response;
  }

  Future<Map<String, dynamic>> downloadImage({required int id, required String fileName}) async {
    print("id....................>$id");
    _isFetchingData = true;
    _fileName=fileName;
    update();
    Map<String,dynamic> response = await shiftRepo.downloadImage(id: id);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      // _shiftModel = ShiftModel.fromJson(response[API_RESPONSE.SUCCESS]['data']);
      print("Downloaded...........................>");
      Get.back();
      showCustomSnackBar("Image Downloaded",isError: false);
    }else{
      Get.back();
      showCustomSnackBar("Image Downloaded Error",isError: true);
    }
    update();
    return response;
  }

  Future<Map<String, dynamic>> clockIn({required String code,required String lat,required String lng}) async {
    Map<String,dynamic> response = await shiftRepo.clockIn(code: code, lat: lat, lng: lng);
    return response;
  }

  Future<Map<String, dynamic>> clockOut({required String code}) async {
    Map<String,dynamic> response = await shiftRepo.clockOut(code: code);
    update();
    return response;
  }

  Future<Map<String, dynamic>> updateShiftStatus( String code, String status,String odometerStart,String odometerEnd,int vehicleUse,String path) async {
    Map<String,dynamic> response = await shiftRepo.updateShiftStatus(code: code,status:status,odometerStart:odometerStart,odometerEnd:odometerEnd,vehicleUse:vehicleUse,path:path);
    update();
    return response;
  }
  Future<Map<String, dynamic>> addAvailability({required String startDate ,required String endDate,required int availability}) async {
    _isFetchingData = true;
    update();
    Map<String,dynamic> response = await shiftRepo.addAvailability(startDate: startDate,endDate:endDate,availability:availability);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      //ShiftAvailabilityModel shiftAvailabilityModel = ShiftAvailabilityModel.fromJson(response[API_RESPONSE.SUCCESS]['data']['data']);
      print("Success");

    }
    update();
    return response;
  }

  Future<Map<String, dynamic>> fetchAvailibility({required int page}) async {
    _isPageFetchingData = true;
    update();
    Map<String,dynamic> response = await shiftRepo.fetchAvailability(page: page);
    if(response.containsKey(API_RESPONSE.SUCCESS)){
      _shiftAvailabilityModel.clear();
      List<dynamic> listAvalibility = response[API_RESPONSE.SUCCESS]['data']['data'];
      for(var data in listAvalibility){
        ShiftAvailabilityModel shift = ShiftAvailabilityModel.fromJson(data);
        _shiftAvailabilityModel.insert(0,shift);
      }
      print("_shiftAvailabilityModel...........................>$_shiftAvailabilityModel");
    }
    _isPageFetchingData = false;
    update();
    return response;
  }

}