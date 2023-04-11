import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workerapp/utils/app_images.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/color_constants.dart';
import '../../../../utils/styles.dart';
import '../../../base/custom_app_bar.dart';
import '../../../base/custom_button.dart';
import '../../shift/widgets/profile_widget_portion.dart';
import '../utils/staff_availability_model.dart';

class StaffAvailability extends StatefulWidget {
  const StaffAvailability({Key? key}) : super(key: key);

  @override
  State<StaffAvailability> createState() => _StaffAvailabilityState();
}

class _StaffAvailabilityState extends State<StaffAvailability> {
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
                             todayTextStyle: const TextStyle(fontSize:16, color: Color(0xffFFFFFF), fontWeight: FontWeight.w700 ),
                             outsideTextStyle:TextStyle(fontSize:14, color: Colors.white.withOpacity(.8), fontWeight: FontWeight.w700 ),
                             defaultTextStyle:const TextStyle(fontSize:16, color: Color(0xffFFFFFF), fontWeight: FontWeight.w700 ),
                             weekendTextStyle:const TextStyle(fontSize:16, color: Color(0xffFFFFFF), fontWeight: FontWeight.w700 ),
                             selectedDecoration:const BoxDecoration(color: Color(0xff0FA958)),
                             todayDecoration:const BoxDecoration(color: Color(0xff0FA958),shape: BoxShape.circle),
                           ),
                           firstDay: DateTime.utc(2010,10,20),
                           lastDay: DateTime.utc(2040,10,20),
                           focusedDay: DateTime.now(),
                         ),
                       ),
                       const SizedBox(height: 15,),
                       CustomButton(
                         onPressed:(){},
                         // timeComplete
                         //     ?(){Get.toNamed(RouteHelper.getShiftNotes());}
                         //     :(){},
                         icon: Image.asset(Images.forwardIcon,width: 30, height: 30,),
                         iconAtStart: false,
                         width: 150,
                         color: const Color(0xff65DACC),
                         buttonText: 'Save',
                         radius: 50,
                       ),
                       const SizedBox(height: 5,),
                       ListView.builder(
                           shrinkWrap: true,
                           physics: const BouncingScrollPhysics(),
                           itemCount: staffAvailabilityList.length,
                           itemBuilder: (context,index){
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
                                                   staffAvailabilityList[index].description,
                                                   style: montserratRegular.copyWith(fontSize: 16,fontWeight: FontWeight.w400,color:  Colors.black),
                                                 ),
                                                 const Spacer(),
                                                 Row(
                                                   mainAxisSize: MainAxisSize.min,
                                                   children: [
                                                     Text(
                                                       "Unavailable for Holiday",
                                                       style: montserratRegular.copyWith(fontSize: 14,fontWeight: FontWeight.w400,color: Colors.black.withOpacity(.6)),
                                                     ),
                                                     const Spacer(),
                                                     Text(
                                                       staffAvailabilityList[index].response,
                                                       style: montserratRegular.copyWith(
                                                         fontSize: 12,
                                                         fontWeight: FontWeight.w700,
                                                         color: staffAvailabilityList[index].response=="Approved"? const Color(0xFF1554F6):staffAvailabilityList[index].response=="Declined"?const Color(0xFFFF1D89):const Color(0xFF0A0000),
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
                           }),
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
                                       onPressed: (){},
                                       child: Text(
                                         'First',
                                         style: montserratRegular.copyWith(fontSize: 16,fontWeight: FontWeight.w700,color: const Color(0xFFBDBDBD)),
                                       )
                                   ),
                                 ),
                               ),
                               Expanded(
                                 child: Container(
                                     color: const Color(0xFFFFFFFF),
                                     alignment: Alignment.center,
                                     child: const Text('1')),
                               ),
                               Expanded(
                                 child: Container(
                                     color: const Color(0xFF23A6F0),
                                     alignment: Alignment.center,
                                     child: const Text('2')),
                               ),
                               const VerticalDivider(),
                               Expanded(
                                 child: Container(
                                     color: const Color(0xFFFFFFFF),
                                     alignment: Alignment.center,
                                     child: const Text('3')),
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
                                         style: montserratRegular.copyWith(fontSize: 16,fontWeight: FontWeight.w700,color: const Color(0xFF23A6F0)),
                                       )
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
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
}
