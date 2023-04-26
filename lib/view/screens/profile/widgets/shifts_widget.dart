import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:intl/intl.dart';
import 'package:workerapp/controller/shift_controller.dart';
import 'package:workerapp/data/model/response/shift_model.dart';
import 'package:workerapp/utils/app_images.dart';
import 'package:workerapp/utils/styles.dart';
import 'package:workerapp/view/screens/profile/utils/shift_model.dart';

import '../../../../controller/bottom_bar_controller.dart';
import '../../../../helper/route_helper.dart';

class ShiftsWidget extends StatelessWidget {

  final bool? isAdd;
  const ShiftsWidget({Key? key,  this.isAdd=true,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<ShiftController>(builder: (shiftController){
      return Column(
        children: [
          shiftController.shiftList.isNotEmpty?
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shiftController.shiftList.length,
              shrinkWrap: true,
              itemBuilder:(BuildContext context, int index){
                return ShiftTimeDetailsRow( shift: shiftController.shiftList[index],);
              }
          )
              : Padding(
            padding: const EdgeInsets.only(top: 150,bottom: 150),
                child: Center(
                child: Text(
                  "No shift found",
            style: montserratRegular.copyWith(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black.withOpacity(.5)),),),
              ),
          const SizedBox(height: 10,),
          isAdd!?Row(
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
          ):const SizedBox(),
          const SizedBox(height: 10,),
        ],
      );
    });
  }
}

class ShiftTimeDetailsRow extends StatelessWidget {
  final ShiftModel shift;
  const ShiftTimeDetailsRow({
    Key? key, required this.shift,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat format = DateFormat("yyyy-MM-dd");
    var endDate = format.parse(shift.endDate);
    return Stack(
      children: [
        GestureDetector(
          onTap: (){
            //Get.offNamed(RouteHelper.getMainScreenRoute());
            Get.find<BottomBarController>().changeMainScreenBottomNavIndex(3,isShowsSelected: true,code:shift.code);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(vertical: 5,horizontal: 5),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      endDate.day.toString(),
                      style: montserratBold.copyWith(fontSize: 15,fontWeight: FontWeight.w800,color: const Color(0xFF938D8D)),
                    ),
                    Text(
                      endDate.month.toInt()==1?"Jun":endDate.month.toInt()==2?"Feb":endDate.month.toInt()==3?"Mar":endDate.month.toInt()==4?"April":endDate.month.toInt()==5?"May":endDate.month.toInt()==6?"June":endDate.month.toInt()==7?"July":endDate.month.toInt()==8?"Aug":endDate.month.toInt()==9?"Sep":endDate.month.toInt()==10?"Oct":endDate.month.toInt()==11?"Nov":"Dec",
                      style: montserratRegular.copyWith(fontSize: 14,fontWeight: FontWeight.w400,color: const Color(0xFF938D8D)),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    height: 133,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x50000000),
                          offset: Offset(0,4),
                          blurRadius: 4,
                          spreadRadius: 0,
                          blurStyle: BlurStyle.inner,
                        ),
                      ]
                    ),
                    child: Row(
                      children: [
                        VerticalDivider(
                          thickness: 9,
                          width: 9,
                          color: shift.status=="Completed"?const Color(0xFF27DD70):shift.status=="Issue"?const Color(0xFFFC2E00):const Color(0xFF1554F6),
                        ),
                        Expanded(
                            child: Container(
                              color: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Text(
                                    "${shift.startTime} - ${shift.endTime}",
                                    style: montserratRegular.copyWith(fontSize: 12,fontWeight: FontWeight.w700,color: const Color(0xFF938D8D)),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Login/out : ",
                                        style: montserratRegular.copyWith(fontSize: 12,fontWeight: FontWeight.w700,color: Colors.black),
                                      ),
                                      Text(
                                        shift.logInTime,
                                        style: montserratRegular.copyWith(fontSize: 12,fontWeight: FontWeight.w700,color: const Color(0xFF39613D)),
                                      ),
                                      Text(
                                        "-",
                                        style: montserratRegular.copyWith(fontSize: 12,fontWeight: FontWeight.w700,color: const Color(0xFF938D8D)),
                                      ),
                                      Text(
                                        shift.logOuTime,
                                        style: montserratRegular.copyWith(fontSize: 12,fontWeight: FontWeight.w700,color: const Color(0xFFFB3003)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8,),
                                  Flexible(
                                    child: Text(
                                      shift.name,
                                      style: montserratRegular.copyWith(fontSize: 14,fontWeight: FontWeight.w700,color: const Color(0xFF06225A)),
                                    ),
                                  ),
                                  const SizedBox(height: 2,),
                                  Flexible(
                                    child: Text(
                                      shift.address,
                                      style: montserratRegular.copyWith(fontSize: 12,fontWeight: FontWeight.w300,color: const Color(0xFF06225A)),
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      // for(int index=0; index<(shitTimeDetailsModel.shiftMembersProfilePicList.length>2?2:shitTimeDetailsModel.shiftMembersProfilePicList.length);index++)
                                        Padding(
                                          padding: const EdgeInsets.only(right: 7),
                                          child: Image.network(shift.profile,height: 34,width: 33,),
                                        ),
                                      // shitTimeDetailsModel.shiftMembersProfilePicList.length>2
                                      //     ? Container(
                                      //         padding: const EdgeInsets.all(8),
                                      //         decoration: const BoxDecoration(
                                      //           color: Color(0xFF4B678E),
                                      //           shape: BoxShape.circle,
                                      //         ),
                                      //         child: Text(
                                      //           "+${shitTimeDetailsModel.shiftMembersProfilePicList.length-2}",
                                      //           style: montserratRegular.copyWith(fontSize: 13,fontWeight: FontWeight.w700,color: const Color(0xFFFFFFFF)),
                                      //         ),
                                      //       )
                                      //     : const SizedBox(),
                                      const Spacer(),
                                      Text(
                                        shift.status,
                                        style: montserratRegular.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          color: shift.status=="Completed"?const Color(0xFF27DD70):shift.status=="Issue"?const Color(0xFFFC2E00):const Color(0xFF1554F6),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                    ],
                                  ),
                                ],
                              ),
                            )
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // shitTimeDetailsModel.hasAnyIssue!=null || shitTimeDetailsModel.isCompleted!=null
        //     ? Positioned(
        //         right: 10,
        //         top: 10,
        //         child: Container(
        //           decoration: BoxDecoration(
        //               color: shitTimeDetailsModel.hasAnyIssue!=null? Colors.red:Colors.green,
        //               shape: BoxShape.circle
        //           ),
        //           padding: const EdgeInsets.all(5),
        //           child: Center(
        //             child: Image.asset(
        //               shitTimeDetailsModel.isCompleted!=null
        //                   ? Images.dollar
        //                   : Images.timeIssueClock,
        //               height: 17,
        //               width: 14,
        //               color: Colors.white,
        //             ),
        //           ),
        //         )
        //     )
        //     : const SizedBox(),
      ],
    );
  }
}
