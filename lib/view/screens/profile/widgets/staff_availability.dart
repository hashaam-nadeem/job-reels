import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workerapp/utils/app_images.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../controller/auth_controller.dart';
import '../../../../controller/shift_controller.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/color_constants.dart';
import '../../../../utils/styles.dart';
import '../../../base/custom_app_bar.dart';
import '../../../base/custom_button.dart';
import '../../../base/custom_snackbar.dart';
import '../../shift/widgets/profile_widget_portion.dart';
import '../utils/staff_availability_model.dart';

class StaffAvailability extends StatefulWidget {
  const StaffAvailability({Key? key}) : super(key: key);

  @override
  State<StaffAvailability> createState() => _StaffAvailabilityState();
}

class _StaffAvailabilityState extends State<StaffAvailability> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStartDay;
  DateTime? _rangeEndDay;
  bool _disableToday = false;
  bool avalibiltyStatus=true;
  DateFormat format = DateFormat("yyyy-MM-dd");
  int _currentPage = 1;

  final RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      _disableToday = false;
    });
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime? focusedDay) {
    setState(() {
      _rangeStartDay = start;
      _rangeEndDay = end;
      _focusedDay = focusedDay ?? _focusedDay;
      _disableToday = true;
    });
  }
  Widget _buildRangeHighlight(BuildContext context, DateTime day, DateTime? focusedDay) {
    // Return an empty container if the range start and end dates are not set
    if (_rangeStartDay == null || _rangeEndDay == null) {
      return Container();
    }

    // Determine the start and end dates of the range
    DateTime rangeStart = _rangeStartDay!;
    DateTime rangeEnd = _rangeEndDay!;
    if (rangeStart.isAfter(rangeEnd)) {
      rangeStart = _rangeEndDay!;
      rangeEnd = _rangeStartDay!;
    }

    // Check if the current day is within the range
    if (day.isAfter(rangeStart) && day.isBefore(rangeEnd)) {
      // Return a light colored container if the current day is within the range
      return Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blue[100],
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '${day.day}',
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      );
    } else if (day.isAtSameMomentAs(rangeStart) || day.isAtSameMomentAs(rangeEnd)) {
      // Return a dark colored container if the current day is the range start or end date
      return  Container();
    } else {
      // Return an empty container if the current day is not within the range
      return Container();
    }
  }
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<ShiftController>().fetchAvailibility(page:1);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackGroundColor,
      appBar: CustomAppBar(
        title: AppString.staffAvailability,
        leading: IconButton(
          onPressed: (){},
          iconSize: 20,
          icon: const Icon(Icons.menu,color: Colors.white,),
        ),
        trailing: [
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.more_vert,color: Colors.white,),
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          width:context.width,
          height: context.height,
          color: AppColor.scaffoldBackGroundColor,
          child:GetBuilder<AuthController>(builder: (authController) {
            return ListView(
               physics: const BouncingScrollPhysics(),
              children:   [
              const ProfileWidgetPortion(isShiftNote: true, currentIndex:0,isMyProfile: true,),
               SizedBox(
                 child: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: Column(
                     children: [
                       Container(
                         padding: const EdgeInsets.all(8),
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.circular(10),
                             color: Colors.black.withOpacity(.8)

                         ),
                         child: TableCalendar(
                           focusedDay: _focusedDay,
                           selectedDayPredicate: (DateTime day) {
                             return isSameDay(_selectedDay, day);
                           },
                           rangeStartDay: _rangeStartDay,
                           rangeEndDay: _rangeEndDay,
                           rangeSelectionMode: _rangeSelectionMode,
                           onDaySelected: _onDaySelected,
                           onRangeSelected: _onRangeSelected,
                           calendarFormat: _calendarFormat,
                           headerStyle: const HeaderStyle(
                               titleTextStyle: TextStyle(fontSize: 15, color: Color(0xffFFFFFF), fontWeight: FontWeight.w700),
                               titleCentered:true,
                               formatButtonVisible:false,
                               formatButtonShowsNext:false,
                               formatButtonDecoration:BoxDecoration(
                                 color: Color(0xffB5BEC6),
                               )
                           ),
                           daysOfWeekStyle:const DaysOfWeekStyle(

                             weekdayStyle:TextStyle(fontSize:12, color: Color(0xffB5BEC6), fontWeight: FontWeight.w700 ),
                             weekendStyle:TextStyle(fontSize:12, color: Color(0xffB5BEC6), fontWeight: FontWeight.w700 ),
                           ),
                           calendarStyle: CalendarStyle(
                             todayTextStyle: const TextStyle(fontSize:16, color: Color(0xffFFFFFF), fontWeight: FontWeight.w700, ),
                             outsideTextStyle:TextStyle(fontSize:14, color: Colors.white.withOpacity(.8), fontWeight: FontWeight.w700 ),
                             defaultTextStyle:const TextStyle(fontSize:16, color: Color(0xffFFFFFF), fontWeight: FontWeight.w700 ),
                             weekendTextStyle:const TextStyle(fontSize:16, color: Color(0xffFFFFFF), fontWeight: FontWeight.w700 ),

                             // selectedDecoration: BoxDecoration(
                             //   color: const Color(0xff0FA958),
                             //   shape: BoxShape.circle,
                             //   border: Border.all(color: Colors.white),
                             //   boxShadow: [
                             //     BoxShadow(
                             //       color: Colors.grey.withOpacity(0.5),
                             //       spreadRadius: 2,
                             //       blurRadius: 5,
                             //       offset: const Offset(0, 3),
                             //     ),
                             //   ],
                             //   // Set opacity to 0.0 if another range is selected
                             // ),
                             todayDecoration: BoxDecoration(
                                 color: _rangeStartDay != null? const Color(0xff0FA958).withOpacity(0.0):const Color(0xff0FA958),
                               shape: BoxShape.circle,
                             ),
                           ),
                           firstDay: DateTime.utc(2010,10,20),
                           lastDay: DateTime.utc(2040,10,20),
                           calendarBuilders: CalendarBuilders(
                             rangeHighlightBuilder: (context, day, focusedDay) =>
                                 _buildRangeHighlight(context, day, null),
                           ),
                           //focusedDay: DateTime.now(),
                         ),
                       ),
                       const SizedBox(height: 30,),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                         Text(
                           "Availability",
                           style: montserratMedium.copyWith(fontSize:15, color: Colors.black),
                         ),
                         Padding(
                           padding: const EdgeInsets.only(right: 15),
                           child: Row(
                             children: [
                               FlutterSwitch(
                                   activeColor:Colors.blue.withOpacity(.8),
                                   padding:2,
                                   width: 40,
                                   height: 17,
                                   toggleSize:20,
                                   value: avalibiltyStatus,
                                   onToggle: (val) async {
                                       setState(() {
                                         avalibiltyStatus = val;
                                         print("avalibiltyStatus.....................$avalibiltyStatus");
                                       });
                                   }
                               ),
                             ],
                           ),
                         ),
                       ],),
                       const SizedBox(height: 15,),
                       GetBuilder<ShiftController>(builder: (shiftController){
                         return  CustomButton(
                           onPressed:(){
                             if(_rangeStartDay!=null&&_rangeEndDay!=null){
                               String startDate=DateFormat("yyyy-MM-dd").format(_rangeStartDay!);
                               String endDate=DateFormat("yyyy-MM-dd").format(_rangeEndDay!);
                               int availability= avalibiltyStatus?1:0;
                               shiftController.addAvailability(startDate: startDate, endDate: endDate, availability: availability);
                             }else{
                               showCustomSnackBar(
                                 "Select Date range",
                                 isError: true,
                               );
                             }
                           },
                           icon: Image.asset(Images.forwardIcon,width: 30, height: 30,),
                           iconAtStart: false,
                           width: 150,
                           color: const Color(0xff65DACC),
                           buttonText: 'Save',
                           radius: 50,
                         );
                       }),

                       const SizedBox(height: 5,),
                       GetBuilder<ShiftController>(builder: (shiftController){
                         return Column(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             shiftController.isPageFetchingData
                                 ? Container(
                                     height: 200,
                                     width: double.infinity,
                                     alignment: Alignment.center,
                                     child: const CircularProgressIndicator(),
                                   )
                                 : shiftController.shiftAvailabilityModel.isNotEmpty
                             ? ListView.builder(
                             shrinkWrap: true,
                             physics: const BouncingScrollPhysics(),
                             itemCount: shiftController.shiftAvailabilityModel.length,
                             itemBuilder: (context,index){
                               var startDate = format.parse(shiftController.shiftAvailabilityModel[index].startDate);
                               var endDate = format.parse(shiftController.shiftAvailabilityModel[index].endDate);
                               String startDateFormattedDate=DateFormat.yMMMMEEEEd().format(startDate);
                               String endDateFormattedDate=DateFormat.yMMMMEEEEd().format(endDate);
                               return Padding(
                                 padding: const EdgeInsets.only(left: 5,top: 10,right: 5,bottom: 5),
                                 child: Container(
                                   height: 100,
                                   width: double.infinity,
                                   decoration: const BoxDecoration(
                                     // boxShadow: [
                                     //   BoxShadow(
                                     //     color: Color(0x50000000),
                                     //     offset: Offset(0,4),
                                     //     blurRadius: 4,
                                     //     spreadRadius: 0,
                                     //     blurStyle: BlurStyle.inner,
                                     //   ),
                                     // ]
                                   ),
                                   child: Row(
                                     children: [
                                       VerticalDivider(
                                         thickness: 9,
                                         width: 9,
                                         color: staffAvailabilityList[index].color,
                                       ),
                                       Expanded(
                                           child: Container(
                                             color: Colors.white,
                                             padding: const EdgeInsets.symmetric(horizontal: 15),
                                             child: Padding(
                                               padding: const EdgeInsets.only(left: 5,right: 10,bottom: 25,top: 15),
                                               child: Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                 mainAxisAlignment: MainAxisAlignment.start,
                                                 children: [

                                                   Text(
                                                     "$startDateFormattedDate to $endDateFormattedDate",
                                                     style: montserratRegular.copyWith(fontSize: 16,fontWeight: FontWeight.w400,color:  Colors.black),
                                                   ),
                                                   const Spacer(),
                                                   Row(
                                                     mainAxisSize: MainAxisSize.min,
                                                     children: [
                                                       Text(
                                                         shiftController.shiftAvailabilityModel[index].availability==1? "Available for Holiday":"Unavailable for Holiday",
                                                         style: montserratRegular.copyWith(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black.withOpacity(.6)),
                                                       ),
                                                       const Spacer(),
                                                       Text(
                                                         shiftController.shiftAvailabilityModel[index].status,
                                                         style: montserratRegular.copyWith(
                                                           fontSize: 12,
                                                           fontWeight: FontWeight.w700,
                                                           color: shiftController.shiftAvailabilityModel[index].status=="Approved"? const Color(0xFF1554F6):shiftController.shiftAvailabilityModel[index].status=="Declined"?const Color(0xFFFF1D89):const Color(0xFF0A0000),
                                                         ),
                                                       ),
                                                     ],
                                                   ),
                                                 ],
                                               ),
                                             ),
                                           )
                                       ),
                                     ],
                                   ),
                                 ),
                               );
                             })
                             :const SizedBox(),
                             const SizedBox(height: 15,),
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Container(
                                 width: 350,
                                 height: 45,
                                 alignment: Alignment.center,
                                 decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(7),
                                     border: Border.all(color: const Color(0xFFBDBDBD)),
                                     color: Colors.white
                                 ),
                                 child: Row(
                                   children: [
                                     ClipRRect(
                                       clipBehavior: Clip.antiAlias,
                                       borderRadius: const BorderRadius.only(topLeft: Radius.circular(7),bottomLeft: Radius.circular(7)),
                                       child: Container(
                                         color: const Color(0xFFF3F3F3),
                                         child: TextButton(
                                             onPressed: (){
                                               fetchPageData(shiftController, 1);
                                             },
                                             child: Text(
                                               'First',
                                               style: montserratRegular.copyWith(fontSize: 16,fontWeight: FontWeight.w700,color: const Color(0xFFBDBDBD)),
                                             )
                                         ),
                                       ),
                                     ),
                                     Expanded(
                                       child: InkWell(
                                         onTap: (){
                                           fetchPageData(shiftController, 1);
                                         },
                                         child: Container(
                                             color: _currentPage==1 ? const Color(0xFF23A6F0): const Color(0xFFFFFFFF),
                                             alignment: Alignment.center,
                                             child: const Text('1')),
                                       ),
                                     ),
                                     Expanded(
                                       child: InkWell(
                                         onTap: (){
                                           fetchPageData(shiftController, 2);
                                         },
                                         child: Container(
                                             color: _currentPage==2 ? const Color(0xFF23A6F0): const Color(0xFFFFFFFF),
                                             alignment: Alignment.center,
                                             child: const Text('2')),
                                       ),
                                     ),
                                     const VerticalDivider(),
                                     Expanded(
                                       child: InkWell(
                                         onTap: (){
                                           fetchPageData(shiftController, 3);
                                         },
                                         child: Container(
                                             color: _currentPage==3 ? const Color(0xFF23A6F0): const Color(0xFFFFFFFF),
                                             alignment: Alignment.center,
                                             child: const Text('3')),
                                       ),
                                     ),
                                     const VerticalDivider(),
                                     ClipRRect(
                                       clipBehavior: Clip.antiAlias,
                                       borderRadius: const BorderRadius.only(topRight: Radius.circular(7),bottomRight: Radius.circular(7)),
                                       child: Container(
                                         color: const Color(0xFFFFFFFF),
                                         child: TextButton(
                                             onPressed: (){},
                                             child: Text(
                                               'Next',
                                               // const Color(0xFF23A6F0)
                                               style: montserratRegular.copyWith(fontSize: 16,fontWeight: FontWeight.w700,color: const Color(0xFFBDBDBD)),
                                             )
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                               ),
                             ),
                           ],
                         );
                       }),

                     ],
                   ),
                 ),
               ),
                const SizedBox(height: 8,),
              ]);
          }),
        ),
      ),
    );
  }

  void fetchPageData(ShiftController shiftController, int page){
    setState(() {
      _currentPage = page;
    });
    shiftController.fetchAvailibility(page: page);
  }

}
