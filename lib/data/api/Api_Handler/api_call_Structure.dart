import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as ApiClient;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:glow_solar/controller/car_controller.dart';
import 'package:glow_solar/data/api/api_checker.dart';
import 'package:glow_solar/util/app_constants.dart';
import 'package:glow_solar/util/app_credentials.dart';
import 'package:glow_solar/util/app_strings.dart';
import 'package:glow_solar/view/base/custom_snackbar.dart';
import 'package:glow_solar/view/base/loading_widget.dart';
import '../../../controller/auth_controller.dart';
import '../../../helper/route_helper.dart';
import '../../model/response/car_model.dart';
import 'api_constants.dart';
import 'api_error_response.dart';


class API_STRUCTURE {
  final String apiUrl;
  dynamic body;
  final bool isWantSuccessMessage;
  final String apiRequestMethod;
  String? contentType;

  API_STRUCTURE({
    this.body,
    required this.apiUrl,
    required this.apiRequestMethod,
    this.isWantSuccessMessage = false,
    this.contentType,
  });

  Future<Map<String, dynamic>> requestAPI({bool isShowLoading = false,bool isCheckAuthorization=true}) async {
    String api = "";
    if(isShowLoading){
      ApiLoader.show();
    }
    try {
      api = AppConstants.BASE_URL + apiUrl;
      Map<String, String> header = {};
      if(contentType != null){
        header.addAll({
          "Content-Type": contentType!
        });
      }
      if(Get.find<AuthController>().authRepo.isLoggedIn()){
        header.addAll({
        "Authorization": "${Get.find<AuthController>().authRepo.getAuthTokenType()} ${Get.find<AuthController>().authRepo.getAuthToken()}"
        });
      }
      header.addAll({
        "deviceType": Platform.isAndroid?'Android':"iOS",
        "Accept": "application/json",
      });
      ApiClient.Dio dio = ApiClient.Dio();
      ApiClient.Options options = ApiClient.Options(
        followRedirects: false,
        headers: header,
        /// Enable for testing complete status
        // validateStatus: (int ?status){
        //   return (status??500)<600;
        // }
      );
      ApiClient.Response<dynamic> response = apiRequestMethod == API_REQUEST_METHOD.GET
          ? await dio.get(api, options: options)
          : apiRequestMethod == API_REQUEST_METHOD.POST
              ? await dio.post(api, data: body, options: options)
              /// Else for Delete Method
              :  apiRequestMethod == API_REQUEST_METHOD.DELETE
          ? await dio.delete(api, options: options)
      :await dio.put(api, data: body, options: options);
      debugPrint('$api response:[${response.statusCode}]----> $response');
      debugPrint('body  ${body?.fields}');
      if (isShowLoading){
        ApiLoader.hide();
      }
      if(response.statusCode==200){
        if(response.data["server_maintenance"] ?? false){
          Get.offAllNamed(RouteHelper.getUpdateAndMaintenance(isUpdate: false));
          return  {API_RESPONSE.EXCEPTION: AppString.maintenance};
        }else if(response.data["app_update"]??false){
          Get.offAllNamed(RouteHelper.getUpdateAndMaintenance(isUpdate: true));
          return  {API_RESPONSE.EXCEPTION: AppString.updated};
        }
      }
      if(isCheckAuthorization){
        ApiChecker.checkUnAuthorization(response);
      }
      Map<String, dynamic> responseResult = {};
      if(response.statusCode!=null){
        responseResult = apiResponseHandling(response);
      }else{
        responseResult = {
          API_RESPONSE.ERROR: "Something went wrong"
        };
      }
        return responseResult;

    } on SocketException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Internet Connection Error",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.SOCKET};
    } on HttpException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Internet Connection Error",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.HTTP};
    } on FormatException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Server Bad response",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.FORMAT};
    } on ApiClient.DioError catch (e) {
      Map<String, dynamic> exception={};
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        e.message,
        isError: true,
      );
      switch (e.type) {
        case ApiClient.DioErrorType.connectTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Connection timeout"};
          break;
        case ApiClient.DioErrorType.sendTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Sent timeout"};
          break;
        case ApiClient.DioErrorType.receiveTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Receive timeout"};
          break;
        case ApiClient.DioErrorType.response:
            exception =  {API_RESPONSE.EXCEPTION: "Server error"};
          break;
        case ApiClient.DioErrorType.cancel:
          showCustomSnackBar(
            "Request cancelled",
            isError: true,
          );
          exception =  {API_RESPONSE.EXCEPTION: "Cancel"};
          break;
        case
        ApiClient.DioErrorType.other:
          String error = e.error.toString().contains("SocketException")
              ?"Internet Connection Error"
              :API_EXCEPTION.UNKNOWN;
          showCustomSnackBar(
            error,
            isError: true,
          );
          exception = {API_RESPONSE.EXCEPTION: error};
          break;
      }
      return exception;
    } catch (error) {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        error.toString().contains("SocketException")
            ? "Internet Connection Error"
            : error.toString(),
          isError: true,
      );
      return error.toString().contains("SocketException")
          ? {API_RESPONSE.EXCEPTION: "Internet Connection Error"}
          : {API_RESPONSE.EXCEPTION: API_EXCEPTION.UNKNOWN};
    }
  }

  Future<Map<String, dynamic>> smartCarAccessToken({bool isShowLoading = false,bool isCheckAuthorization=true}) async {
    String api = "";
    if(isShowLoading){
      ApiLoader.show();
    }
    // try {
      api = AppConstants.AUTH_SMARTCAR_BASE_URL + apiUrl;
      Map<String, String> header = {};
      if(contentType != null){
        header.addAll({
          "Content-Type": contentType!
        });
      }
      if(Get.find<AuthController>().authRepo.isLoggedIn()){
        header.addAll({
          "Authorization": "Basic ezk1MzA0YjE3LTAzOGMtNDlmNS05NmUxLTJmMWI2NGZlMjMzMH06ezgwNmM4NjNmLTI2ODctNDM0Ny1iY2EzLWMzZjAyNzE3NjVhNH0="
        });
      }
      // header.addAll({
      //   "deviceType": Platform.isAndroid?'Android':"iOS",
      //   "Accept": "application/json",
      // });
      ApiClient.Dio dio = ApiClient.Dio();
      ApiClient.Options options = ApiClient.Options(
          followRedirects: false,
          headers: header,
          /// Enable for testing complete status
          validateStatus: (int ?status){
            return (status??500)<600;
          }
      );
      ApiClient.Response<dynamic> response = apiRequestMethod == API_REQUEST_METHOD.GET
          ? await dio.get(api, options: options)
          : apiRequestMethod == API_REQUEST_METHOD.POST
          ? await dio.post(api, data: body, options: options)
      /// Else for Delete Method
          :  apiRequestMethod == API_REQUEST_METHOD.DELETE
          ? await dio.delete(api, options: options)
          :await dio.put(api, data: body, options: options);
      debugPrint('$api response:[${response.statusCode}]----> $response');
      if (isShowLoading){
        ApiLoader.hide();
      }
      if(response.statusCode==200){
        if(response.data["server_maintenance"]??false){
          Get.offAllNamed(RouteHelper.getUpdateAndMaintenance(isUpdate: false));
          return  {API_RESPONSE.EXCEPTION: AppString.maintenance};
        }else if(response.data["app_update"]??false){
          Get.offAllNamed(RouteHelper.getUpdateAndMaintenance(isUpdate: true));
          return  {API_RESPONSE.EXCEPTION: AppString.updated};
        }
      }
      if(isCheckAuthorization){
        ApiChecker.checkUnAuthorization(response);
      }
      Map<String, dynamic> responseResult = {};
      if(response.statusCode!=null){
        responseResult = apiResponseHandling(response);
      }else{
        responseResult = {
          API_RESPONSE.ERROR: "Something went wrong"
        };
      }
      return responseResult;

    // } on SocketException {
    //   if (isShowLoading){
    //     ApiLoader.hide();
    //   }
    //   showCustomSnackBar(
    //     "Internet Connection Error",
    //     isError: true,
    //   );
    //   return {API_RESPONSE.EXCEPTION: API_EXCEPTION.SOCKET};
    // } on HttpException {
    //   if (isShowLoading){
    //     ApiLoader.hide();
    //   }
    //   showCustomSnackBar(
    //     "Internet Connection Error",
    //     isError: true,
    //   );
    //   return {API_RESPONSE.EXCEPTION: API_EXCEPTION.HTTP};
    // } on FormatException {
    //   if (isShowLoading){
    //     ApiLoader.hide();
    //   }
    //   showCustomSnackBar(
    //     "Server Bad response",
    //     isError: true,
    //   );
    //   return {API_RESPONSE.EXCEPTION: API_EXCEPTION.FORMAT};
    // } on ApiClient.DioError catch (e) {
    //   Map<String, dynamic> exception={};
    //   if (isShowLoading){
    //     ApiLoader.hide();
    //   }
    //   showCustomSnackBar(
    //     e.message,
    //     isError: true,
    //   );
    //   switch (e.type) {
    //     case ApiClient.DioErrorType.connectTimeout:
    //       exception =  {API_RESPONSE.EXCEPTION: "Connection timeout"};
    //       break;
    //     case ApiClient.DioErrorType.sendTimeout:
    //       exception =  {API_RESPONSE.EXCEPTION: "Sent timeout"};
    //       break;
    //     case ApiClient.DioErrorType.receiveTimeout:
    //       exception =  {API_RESPONSE.EXCEPTION: "Receive timeout"};
    //       break;
    //     case ApiClient.DioErrorType.response:
    //       exception =  {API_RESPONSE.EXCEPTION: "Server error"};
    //       break;
    //     case ApiClient.DioErrorType.cancel:
    //       showCustomSnackBar(
    //         "Request cancelled",
    //         isError: true,
    //       );
    //       exception =  {API_RESPONSE.EXCEPTION: "Cancel"};
    //       break;
    //     case
    //     ApiClient.DioErrorType.other:
    //       String error = e.error.toString().contains("SocketException")
    //           ?"Internet Connection Error"
    //           :API_EXCEPTION.UNKNOWN;
    //       showCustomSnackBar(
    //         error,
    //         isError: true,
    //       );
    //       exception = {API_RESPONSE.EXCEPTION: error};
    //       break;
    //   }
    //   return exception;
    // } catch (error) {
    //   if (isShowLoading){
    //     ApiLoader.hide();
    //   }
    //   showCustomSnackBar(
    //     error.toString().contains("SocketException")
    //         ? "Internet Connection Error"
    //         : error.toString(),
    //     isError: true,
    //   );
    //   return error.toString().contains("SocketException")
    //       ? {API_RESPONSE.EXCEPTION: "Internet Connection Error"}
    //       : {API_RESPONSE.EXCEPTION: API_EXCEPTION.UNKNOWN};
    // }
  }

  Future<Map<String, dynamic>> smartCarRequestAPI({required String accessToken, bool isShowLoading = false,bool isCheckAuthorization=true,}) async {
    String api = "";
    if(isShowLoading){
      ApiLoader.show();
    }
    try {
      api = AppConstants.SMARTCAR_API_BASE_URL + apiUrl;
      Map<String, String> header = {};

      if(contentType != null){
        header.addAll({
          //"Content-Type": "application/x-www-form-urlencoded"
        });
      }
      header.addAll({
        "Authorization": "Bearer $accessToken "
      });
      ApiClient.Dio dio = ApiClient.Dio();
      ApiClient.Options options = ApiClient.Options(
          followRedirects: false,
          headers: header,
          contentType:contentType??"application/json",
          /// Enable for testing complete status
          validateStatus: (int ?status){
            return (status??500)<600;
          }
      );
      ApiClient.Response<dynamic> response = apiRequestMethod == API_REQUEST_METHOD.GET
          ? await dio.get(api, options: options,)
          : apiRequestMethod == API_REQUEST_METHOD.POST
          ? await dio.post(api, data: body, options: options, )
      /// Else for Delete Method
          :  apiRequestMethod == API_REQUEST_METHOD.DELETE
          ? await dio.delete(api, options: options)
          :await dio.put(api, data: body, options: options);
      debugPrint('$api response:[${response.statusCode}]----> $response');
      if (isShowLoading){
        ApiLoader.hide();
      }
      if(isCheckAuthorization){
        //ApiChecker.checkUnAuthorization(response);
      }
      Map<String, dynamic> responseResult = {};
      if(response.statusCode!=null){
        responseResult = smartCarApiResponseHandling(response:response,);
      }else{
        responseResult = {
          API_RESPONSE.ERROR: "Something went wrong"
        };
      }
      return responseResult;

    } on SocketException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      // showCustomSnackBar(
      //   "Internet Connection Error",
      //   isError: true,
      // );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.SOCKET};
    } on HttpException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      // showCustomSnackBar(
      //   "Internet Connection Error",
      //   isError: true,
      // );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.HTTP};
    } on FormatException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      // showCustomSnackBar(
      //   "Server Bad response",
      //   isError: true,
      // );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.FORMAT};
    } on ApiClient.DioError catch (e) {
      Map<String, dynamic> exception={};
      if (isShowLoading){
        ApiLoader.hide();
      }
      // showCustomSnackBar(
      //   e.message,
      //   isError: true,
      // );
      switch (e.type) {
        case ApiClient.DioErrorType.connectTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Connection timeout"};
          break;
        case ApiClient.DioErrorType.sendTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Sent timeout"};
          break;
        case ApiClient.DioErrorType.receiveTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Receive timeout"};
          break;
        case ApiClient.DioErrorType.response:
          exception =  {API_RESPONSE.EXCEPTION: "Server error"};
          break;
        case ApiClient.DioErrorType.cancel:
        // showCustomSnackBar(
        //   "Request cancelled",
        //   isError: true,
        // );
          exception =  {API_RESPONSE.EXCEPTION: "Cancel"};
          break;
        case
        ApiClient.DioErrorType.other:
          String error = e.error.toString().contains("SocketException")
              ?"Internet Connection Error"
              :API_EXCEPTION.UNKNOWN;
          // showCustomSnackBar(
          //   error,
          //   isError: true,
          // );
          exception = {API_RESPONSE.EXCEPTION: error};
          break;
      }
      return exception;
    } catch (error) {
      if (isShowLoading){
        ApiLoader.hide();
      }
      // showCustomSnackBar(
      //   error.toString().contains("SocketException")
      //       ? "Internet Connection Error"
      //       : error.toString(),
      //   isError: true,
      // );
      return error.toString().contains("SocketException")
          ? {API_RESPONSE.EXCEPTION: "Internet Connection Error"}
          : {API_RESPONSE.EXCEPTION: API_EXCEPTION.UNKNOWN};
    }
  }

  Future<Map<String, dynamic>> requestChargerAPI({bool isShowLoading = false,}) async {
    String api = "";
    if(isShowLoading){
      ApiLoader.show();
    }

    try {
      api = AppConstants.FETCH_CHARGER_Api + apiUrl;
      Map<String, String> header = {};
        header.addAll({
          "Content-Type": "application/x-www-form-urlencoded;charset=utf-8"
        });

      ApiClient.Dio dio = ApiClient.Dio();
      ApiClient.Options options = ApiClient.Options(
        followRedirects: false,
        headers: header,
        /// Enable for testing complete status
        // validateStatus: (int ?status){
        //   return (status??500)<600;
        // }
      );
      debugPrint("api:-> $api");
      debugPrint("body:-> ${body.fields}");
      ApiClient.Response<dynamic> response = apiRequestMethod == API_REQUEST_METHOD.GET
          ? await dio.get(api, options: options)
          : apiRequestMethod == API_REQUEST_METHOD.POST
          ? await dio.post(api, data: body, options: options)
      /// Else for Delete Method
          :  apiRequestMethod == API_REQUEST_METHOD.DELETE
          ? await dio.delete(api, options: options)
          :await dio.put(api, data: body, options: options);
      debugPrint('response----> $response');
      if (isShowLoading){
        ApiLoader.hide();
      }
      Map<String, dynamic> responseResult = {};
      if(response.statusCode!=null){
        responseResult = chargerResponseHandling(response);
      }else{
        responseResult = {
          API_RESPONSE.ERROR: "Something went wrong"
        };
      }
      return responseResult;

    } on SocketException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Internet Connection Error",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.SOCKET};
    } on HttpException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Internet Connection Error",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.HTTP};
    } on FormatException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Server Bad response",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.FORMAT};
    } on ApiClient.DioError catch (e) {
      Map<String, dynamic> exception={};
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        e.message,
        isError: true,
      );
      switch (e.type) {
        case ApiClient.DioErrorType.connectTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Connection timeout"};
          break;
        case ApiClient.DioErrorType.sendTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Sent timeout"};
          break;
        case ApiClient.DioErrorType.receiveTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Receive timeout"};
          break;
        case ApiClient.DioErrorType.response:
          exception =  {API_RESPONSE.EXCEPTION: "Server error"};
          break;
        case ApiClient.DioErrorType.cancel:
          showCustomSnackBar(
            "Request cancelled",
            isError: true,
          );
          exception =  {API_RESPONSE.EXCEPTION: "Cancel"};
          break;
        case
        ApiClient.DioErrorType.other:
          String error = e.error.toString().contains("SocketException")
              ?"Internet Connection Error"
              :API_EXCEPTION.UNKNOWN;
          showCustomSnackBar(
            error,
            isError: true,
          );
          exception = {API_RESPONSE.EXCEPTION: error};
          break;
      }
      return exception;
    } catch (error) {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        error.toString().contains("SocketException")
            ? "Internet Connection Error"
            : error.toString(),
        isError: true,
      );
      return error.toString().contains("SocketException")
          ? {API_RESPONSE.EXCEPTION: "Internet Connection Error"}
          : {API_RESPONSE.EXCEPTION: API_EXCEPTION.UNKNOWN};
    }
  }

  Future<Map<String, dynamic>> requestSolarEdgeAPI({bool isShowLoading = false,}) async {
    String api = "";
    if(isShowLoading){
      ApiLoader.show();
    }

    try {
      api = AppConstants.SOLAR_EDGE_BASE_URL + apiUrl;
      ApiClient.Dio dio = ApiClient.Dio();
      ApiClient.Options options = ApiClient.Options(
          followRedirects: false,
          /// Enable for testing complete status
          validateStatus: (int ?status){
            return (status??500)<500;
          }
      );
      debugPrint("api:-> $api");
      ApiClient.Response<dynamic> response = apiRequestMethod == API_REQUEST_METHOD.GET
          ? await dio.get(api, options: options)
          : apiRequestMethod == API_REQUEST_METHOD.POST
          ? await dio.post(api, data: body, options: options)
      /// Else for Delete Method
          :  apiRequestMethod == API_REQUEST_METHOD.DELETE
          ? await dio.delete(api, options: options)
          :await dio.put(api, data: body, options: options);
      debugPrint('response----> $response');
      if (isShowLoading){
        ApiLoader.hide();
      }
      Map<String, dynamic> responseResult = {};
      if(response.statusCode!=null){
        responseResult = solarEdgeApiResponseHandling(response);
      }else{
        responseResult = {
          API_RESPONSE.ERROR: "Something went wrong"
        };
      }
      return responseResult;

    } on SocketException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Internet Connection Error",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.SOCKET};
    } on HttpException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Internet Connection Error",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.HTTP};
    } on FormatException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Server Bad response",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.FORMAT};
    } on ApiClient.DioError catch (e) {
      Map<String, dynamic> exception={};
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        e.message,
        isError: true,
      );
      switch (e.type) {
        case ApiClient.DioErrorType.connectTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Connection timeout"};
          break;
        case ApiClient.DioErrorType.sendTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Sent timeout"};
          break;
        case ApiClient.DioErrorType.receiveTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Receive timeout"};
          break;
        case ApiClient.DioErrorType.response:
          exception =  {API_RESPONSE.EXCEPTION: "Server error"};
          break;
        case ApiClient.DioErrorType.cancel:
          showCustomSnackBar(
            "Request cancelled",
            isError: true,
          );
          exception =  {API_RESPONSE.EXCEPTION: "Cancel"};
          break;
        case
        ApiClient.DioErrorType.other:
          String error = e.error.toString().contains("SocketException")
              ?"Internet Connection Error"
              :API_EXCEPTION.UNKNOWN;
          showCustomSnackBar(
            error,
            isError: true,
          );
          exception = {API_RESPONSE.EXCEPTION: error};
          break;
      }
      return exception;
    } catch (error) {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        error.toString().contains("SocketException")
            ? "Internet Connection Error"
            : error.toString(),
        isError: true,
      );
      return error.toString().contains("SocketException")
          ? {API_RESPONSE.EXCEPTION: "Internet Connection Error"}
          : {API_RESPONSE.EXCEPTION: API_EXCEPTION.UNKNOWN};
    }
  }

  Future<Map<String, dynamic>> requestCustomAPI({bool isShowLoading = false,}) async {
    if(isShowLoading){
      ApiLoader.show();
    }
    try {
      Map<String, String> header = {};
      if(contentType != null){
        header.addAll({
          "Content-Type": contentType!
        });
      }
      if(Get.find<AuthController>().authRepo.isLoggedIn()){
        header.addAll({
          "Authorization": "${Get.find<AuthController>().authRepo.getAuthTokenType()} ${Get.find<AuthController>().authRepo.getAuthToken()}"
        });
      }
      header.addAll({
        "deviceType": Platform.isAndroid?'Android':"iOS",
        "Accept": "application/json",
      });
      debugPrint("api:-> $apiUrl");
      debugPrint("body:-> $body");
      debugPrint("header:-> $header");
      ApiClient.Dio dio = ApiClient.Dio();
      ApiClient.Options options = ApiClient.Options(
          followRedirects: false,
          headers: header,
          /// Enable for testing complete status
          validateStatus: (int ?status){
            return (status??500)<500||status==2008;
          }
      );
      ApiClient.Response<dynamic> response = apiRequestMethod == API_REQUEST_METHOD.GET
          ? await dio.get(apiUrl, options: options)
          : apiRequestMethod == API_REQUEST_METHOD.POST
          ? await dio.post(apiUrl, data: body, options: options)
      /// Else for Put Method
          : await dio.put(apiUrl, data: body, options: options);
      debugPrint('response----> $response');
      if (isShowLoading){
        ApiLoader.hide();
      }
      Map<String, dynamic> responseResult = {};
      if(response.statusCode!=null){
        responseResult = apiResponseHandling(response);
      }else{
        responseResult = {
          API_RESPONSE.ERROR: "Something went wrong"
        };
      }
      return responseResult;

    } on SocketException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Internet Connection Error",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.SOCKET};
    } on HttpException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Internet Connection Error",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.HTTP};
    } on FormatException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Server Bad response",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.FORMAT};
    } on ApiClient.DioError catch (e) {
      Map<String, dynamic> exception={};
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        e.message,
        isError: true,
      );
      switch (e.type) {
        case ApiClient.DioErrorType.connectTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Connection timeout"};
          break;
        case ApiClient.DioErrorType.sendTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Sent timeout"};
          break;
        case ApiClient.DioErrorType.receiveTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Receive timeout"};
          break;
        case ApiClient.DioErrorType.response:
          exception =  {API_RESPONSE.EXCEPTION: "Server error"};
          break;
        case ApiClient.DioErrorType.cancel:
          showCustomSnackBar(
            "Request cancelled",
            isError: true,
          );
          exception =  {API_RESPONSE.EXCEPTION: "Cancel"};
          break;
        case
        ApiClient.DioErrorType.other:
          String error = e.error.toString().contains("SocketException")
              ?"Internet Connection Error"
              :API_EXCEPTION.UNKNOWN;
          showCustomSnackBar(
            error,
            isError: true,
          );
          exception = {API_RESPONSE.EXCEPTION: error};
          break;
      }
      return exception;
    } catch (error) {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        error.toString().contains("SocketException")
            ? "Internet Connection Error"
            : error.toString(),
        isError: true,
      );
      return error.toString().contains("SocketException")
          ? {API_RESPONSE.EXCEPTION: "Internet Connection Error"}
          : {API_RESPONSE.EXCEPTION: API_EXCEPTION.UNKNOWN};
    }
  }

  Future<Map<String, dynamic>> requestStripeApi({bool isShowLoading = false,}) async {
    String api = "";
    if(isShowLoading){
      ApiLoader.show();
    }

    try {
      api =  apiUrl;
      ApiClient.Dio dio = ApiClient.Dio();
      var userPass = '${Uri.encodeFull(AppCredentials.STRIPE_TESTING_KEY)}:';
      Map<String, String> header = {};
        header.addAll({
          "Content-Type": "application/x-www-form-urlencoded",

          "Authorization": "Basic ${base64Encode(ascii.encode(userPass))}"
        });
      ApiClient.Options options = ApiClient.Options(
        followRedirects: false,
        headers: header,
        /// Enable for testing complete status
        // validateStatus: (int ?status){
        //   return (status??500)<600;
        // }
      );
      debugPrint("api:-> $api");
      ApiClient.Response<dynamic> response = apiRequestMethod == API_REQUEST_METHOD.GET
          ? await dio.get(api, options: options)
          : apiRequestMethod == API_REQUEST_METHOD.POST
          ? await dio.post(api, data: body, options: options)
      /// Else for Delete Method
          :  apiRequestMethod == API_REQUEST_METHOD.DELETE
          ? await dio.delete(api, options: options)
          :await dio.put(api, data: body, options: options);
      debugPrint('response----> $response');
      if (isShowLoading){
        ApiLoader.hide();
      }
      Map<String, dynamic> responseResult = {};
      if(response.statusCode!=null){
        responseResult = solarEdgeApiResponseHandling(response);
      }else{
        responseResult = {
          API_RESPONSE.ERROR: "Something went wrong"
        };
      }
      return responseResult;

    } on SocketException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Internet Connection Error",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.SOCKET};
    } on HttpException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Internet Connection Error",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.HTTP};
    } on FormatException {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        "Server Bad response",
        isError: true,
      );
      return {API_RESPONSE.EXCEPTION: API_EXCEPTION.FORMAT};
    } on ApiClient.DioError catch (e) {
      Map<String, dynamic> exception={};
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        e.message,
        isError: true,
      );
      switch (e.type) {
        case ApiClient.DioErrorType.connectTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Connection timeout"};
          break;
        case ApiClient.DioErrorType.sendTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Sent timeout"};
          break;
        case ApiClient.DioErrorType.receiveTimeout:
          exception =  {API_RESPONSE.EXCEPTION: "Receive timeout"};
          break;
        case ApiClient.DioErrorType.response:
          exception =  {API_RESPONSE.EXCEPTION: "Server error"};
          break;
        case ApiClient.DioErrorType.cancel:
          showCustomSnackBar(
            "Request cancelled",
            isError: true,
          );
          exception =  {API_RESPONSE.EXCEPTION: "Cancel"};
          break;
        case
        ApiClient.DioErrorType.other:
          String error = e.error.toString().contains("SocketException")
              ?"Internet Connection Error"
              :API_EXCEPTION.UNKNOWN;
          showCustomSnackBar(
            error,
            isError: true,
          );
          exception = {API_RESPONSE.EXCEPTION: error};
          break;
      }
      return exception;
    } catch (error) {
      if (isShowLoading){
        ApiLoader.hide();
      }
      showCustomSnackBar(
        error.toString().contains("SocketException")
            ? "Internet Connection Error"
            : error.toString(),
        isError: true,
      );
      return error.toString().contains("SocketException")
          ? {API_RESPONSE.EXCEPTION: "Internet Connection Error"}
          : {API_RESPONSE.EXCEPTION: API_EXCEPTION.UNKNOWN};
    }
  }

  apiResponseHandling(ApiClient.Response response) {
    if (response.statusCode! >= 200 && response.statusCode !< 220) {
      if (isWantSuccessMessage) {
        // showCustomSnackBar(
        //   response.data["message"],
        //isError: false,
        // );
      }
      return {API_RESPONSE.SUCCESS: response.data};
    } else {
      String error='';
      try{
        showCustomSnackBar(
          response.data["message"]??"",
          isError: true,
        );
      }catch(e){
        debugPrint("Exception:-> $e");
      }
      error = API_RESPONSE.GetErrorResponse(response.statusCode!) ?? "Unknown Status Response";
      return {API_RESPONSE.ERROR: error};
    }
  }

  solarEdgeApiResponseHandling(ApiClient.Response response) {
    if (response.statusCode! >= 200 && response.statusCode !< 220) {
      if (isWantSuccessMessage) {
        // showCustomSnackBar(
        //   jsonDecode(response.data)["msg"],
        // isError: false,
        // );
      }
      return {API_RESPONSE.SUCCESS: response.data};
    }else if(response.statusCode==403) {
      String error = "${response.data['String']??''}".split(":").first;
      showCustomSnackBar(
        error.contains('Invalid token')?"Access key is invalid":error.contains('authorized')?"You are ${error.split("is").last} this solar":error,
        isError: true,
      );
      error = "Unauthorized";
      return {API_RESPONSE.ERROR: error};
    } else {
      String error='';
      showCustomSnackBar(
        "${response.data['String']??''}".split(":").first,
        isError: true,
      );
      return {API_RESPONSE.ERROR: error};
    }
  }

  chargerResponseHandling(ApiClient.Response response) {
    debugPrint("data:-> ${response.data}");
    if (jsonDecode(response.data)["code"] == "1") {
      if (isWantSuccessMessage) {
        // showCustomSnackBar(
        //   jsonDecode(response.data)["msg"],
        //   isError: false,
        // );
      }
      return {API_RESPONSE.SUCCESS: response.data};
    } else {
      String error = jsonDecode(response.data)["msg"];
      showCustomSnackBar(
        error,
        isError: true,
      );
      return {API_RESPONSE.ERROR: error};
    }
  }

  smartCarApiResponseHandling({required ApiClient.Response response,}) {
    if (response.statusCode! >= 200 && response.statusCode !< 220) {
      if (isWantSuccessMessage) {
        // showCustomSnackBar(
        //   response.data["message"],
        //isError: false,
        // );
      }
      return {API_RESPONSE.SUCCESS: response.data};
    }  else{

      // error = API_RESPONSE.GetErrorResponse(response.statusCode!) ?? "Unknown Status Response";
      //return {API_RESPONSE.ERROR: error};
    }
  }

}