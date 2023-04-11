import 'package:get/get.dart';
import 'package:workerapp/data/model/response/shift_model.dart';

class BottomBarController extends GetxController implements GetxService {
  int shiftScreensCurrentIndex = 0;
  String? shiftCode;
  int tabIndex=0;
  bool isShowSelected=true;
  ShiftModel? shiftModel;
  int? clientId;

  void changeMainScreenBottomNavIndex(int index,{bool isShowsSelected=true,String code="17"}){
    isShowSelected=isShowsSelected;
    tabIndex=index;
    shiftCode=code;
    update();
  }

  void changeTabIndex(int index,{bool isShowsSelected=true,ShiftModel? shiftModels,int? clientsId}){
    isShowSelected = isShowsSelected;
    shiftScreensCurrentIndex=index;
    shiftModel=shiftModels;
    clientId=clientsId;
    update();
  }

}