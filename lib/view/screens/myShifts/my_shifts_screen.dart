import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:workerapp/CustomPackages/RangeDatePicker/datepicker.dart';
import 'package:workerapp/CustomPackages/customWeekPicker/calendar_timeline.dart';
import 'package:workerapp/Utils/app_constants.dart';
import 'package:workerapp/controller/shift_controller.dart';
import 'package:workerapp/utils/color_constants.dart';
import 'package:workerapp/view/base/custom_app_bar.dart';
import 'package:workerapp/view/screens/drawer/drawer_screen.dart';
import 'package:workerapp/view/screens/profile/utils/shift_model.dart';
import 'package:workerapp/view/screens/profile/widgets/shifts_widget.dart';

import '../../../utils/styles.dart';

class MyShiftsScreen extends StatefulWidget {
  const MyShiftsScreen({Key? key}) : super(key: key);

  @override
  State<MyShiftsScreen> createState() => _MyShiftsScreenState();
}

class _MyShiftsScreenState extends State<MyShiftsScreen> {
  String selectedMonthYear = 'June 2022';
  bool isAppbarExpanded = false;
  DateTime _pickerMonth = DateTime.now();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DateRangePickerController _dateRangePickerController = DateRangePickerController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<ShiftController>().fetchShiftByDate(_pickerMonth.toString().split(" ").first);
      Get.find<ShiftController>().fetchShift();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColor.scaffoldBackGroundColor,
      drawer: const AppDrawer(),
      appBar: CustomExpandableAppBar(
          appbarTitle: "${AppConstant.MonthsInYear[_pickerMonth.month-1]} ${_pickerMonth.year}",
          leading: IconButton(
            onPressed: (){
              _scaffoldKey.currentState?.openDrawer();
            },
            iconSize: 20,
            icon: const Icon(Icons.menu,color: Colors.white,),
          ),
          isExpanded: isAppbarExpanded,
          expandedWidgets: [],
          onTap: (){
            setState((){
              isAppbarExpanded = !isAppbarExpanded;
            });
          }
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              width:context.width,
              height: context.height,
              color: AppColor.scaffoldBackGroundColor,
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: GetBuilder<ShiftController>(builder: (shiftController){
                  return  Column(

                    children: [
                      Container(
                        // height: 100,
                        width: context.width,
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        color: Colors.transparent,
                        child: CalendarTimeline(
                          initialDate: _pickerMonth,
                          firstDate: DateTime(_pickerMonth.year, _pickerMonth.month , 0),
                          lastDate: DateTime(_pickerMonth.year, _pickerMonth.month + 1, 0),
                          onlyViewWeekDayAndDate: true,
                          onDateSelected: (date){
                            _pickerMonth = date;
                            setState((){
                              shiftController.fetchShiftByDate(_pickerMonth.toString().split(" ").first);
                            });
                          },
                          leftMargin: 5,
                          activeDayColor: Colors.white,
                          dayNameColor: const Color(0xFFA19797),
                          activeBackgroundDayColor: const Color(0xFF2CB8E4).withOpacity(0.69),
                          locale: 'en_ISO',
                        ),
                        // child: CalendarWeek(
                        //   controller: CalendarWeekController(),
                        //   showMonth: false,
                        //   onDatePressed: (DateTime datetime) {
                        //     // Do something
                        //   },
                        //   minDate: DateTime(_pickerMonth.year, _pickerMonth.month , 0),
                        //   maxDate: DateTime(_pickerMonth.year, _pickerMonth.month + 1, 0),
                        //   monthViewBuilder: (DateTime time) => Align(
                        //     alignment: FractionalOffset.center,
                        //     child: Container(
                        //         margin: const EdgeInsets.symmetric(vertical: 4),
                        //         child: Text(
                        //           DateFormat.yMMMM().format(time),
                        //           overflow: TextOverflow.ellipsis,
                        //           textAlign: TextAlign.center,
                        //           style: TextStyle(
                        //               color: Colors.blue, fontWeight: FontWeight.w600),
                        //         ),
                        //     ),
                        //   ),
                        // ),


                        ///

                        // child: SfDateRangePicker(
                        //   initialSelectedRange: PickerDateRange(_pickerMonth, _pickerMonth),
                        //   allowViewNavigation: true,
                        //   headerHeight: 30,
                        //   enablePastDates: true,
                        //   controller: _dateRangePickerController,
                        //   navigationDirection: DateRangePickerNavigationDirection.vertical,
                        //   view: DateRangePickerView.month,
                        //   selectionShape: DateRangePickerSelectionShape.rectangle,
                        //   backgroundColor: Colors.grey.shade100,
                        //   selectionMode: DateRangePickerSelectionMode.single,
                        //   showNavigationArrow: true,
                        //   toggleDaySelection: false,
                        //   onSelectionChanged: (DateRangePickerSelectionChangedArgs ?selectedDateRange){
                        //     if(selectedDateRange!=null){
                        //       DateTime pickedData = selectedDateRange.value as DateTime;
                        //       _pickerMonth = pickedData;
                        //       isAppbarExpanded = false;
                        //       setState((){});
                        //     }
                        //   },
                        // ),
                      ),
                      shiftController.isDataFetching&&shiftController.shiftListsByDate.isEmpty
                          ?ListView(
                        shrinkWrap: true,
                        children: [
                          shiftLoadingWidget(),
                          shiftLoadingWidget(),
                          shiftLoadingWidget(),
                        ],
                      )
                          : shiftController.shiftListsByDate.isNotEmpty?
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: shiftController.shiftListsByDate.length,
                          shrinkWrap: true,
                          itemBuilder:(BuildContext context, int index){
                            return ShiftTimeDetailsRow(shitTimeDetailsModel: shitTimeDetailsList[index], shift: shiftController.shiftListsByDate[index],);
                          }
                      )
                          :Padding(
                            padding: const EdgeInsets.only(top: 200,bottom: 200),
                            child: Center(
                            child: Text(
                              "No shift found",
                              style: montserratRegular.copyWith(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black.withOpacity(.5)),
                            )),
                          ),
                      const SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 25),
                            decoration: const BoxDecoration(
                              color: Color(0xFF65DACC),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: (){},
                              iconSize: 30,
                              icon: const Icon(Icons.add,color: Colors.white,),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10,),
                    ],
                  );
                }),
              ),
            ),
          ),
          isAppbarExpanded
              ? Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: context.height*.4,
                  width: 100,
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SfDateRangePicker(
                    initialSelectedRange: PickerDateRange(_pickerMonth, _pickerMonth),
                    allowViewNavigation: false,
                    headerHeight: 30,
                    enablePastDates: true,
                    controller: _dateRangePickerController,
                    view: DateRangePickerView.year,
                    selectionShape: DateRangePickerSelectionShape.rectangle,
                    backgroundColor: Colors.grey.shade100,
                    selectionMode: DateRangePickerSelectionMode.single,
                    showNavigationArrow: true,
                    toggleDaySelection: false,
                    onSelectionChanged: (DateRangePickerSelectionChangedArgs ?selectedDateRange){
                      if(selectedDateRange!=null){
                        DateTime pickedData = selectedDateRange.value as DateTime;
                        _pickerMonth = pickedData;
                        isAppbarExpanded = false;
                        setState((){});
                      }
                    },
                  ),
                ),
              )
              :const SizedBox()
        ],
      ),
    );
  }
  Widget shiftLoadingWidget(){
    return Padding(
      padding: const EdgeInsets.only(left: 12,right: 12,top: 10),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(11),
        ),
        height: 150,
        child: Shimmer.fromColors(
          period: const Duration(milliseconds: 1500),
          direction: ShimmerDirection.ltr,
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade200,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
      ),
    );
  }
}
