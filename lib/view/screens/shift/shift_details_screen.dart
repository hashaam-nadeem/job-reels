import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:workerapp/controller/bottom_bar_controller.dart';
import 'package:workerapp/controller/shift_controller.dart';
import 'package:workerapp/data/model/response/document_model.dart';
import 'package:workerapp/data/model/response/shift_model.dart';
import 'package:workerapp/utils/app_images.dart';
import 'package:workerapp/utils/color_constants.dart';
import 'package:workerapp/utils/dimensions.dart';
import 'package:workerapp/utils/styles.dart';
import 'package:workerapp/view/base/custom_app_bar.dart';
import 'package:workerapp/view/base/custom_button.dart';
import 'package:workerapp/view/base/custom_snackbar.dart';
import 'package:workerapp/view/screens/shift/widgets/profile_widget_portion.dart';
import 'package:workerapp/view/screens/shift/widgets/time_line_widget.dart';
import '../../../controller/auth_controller.dart';
import '../../../data/api/Api_Handler/api_error_response.dart';
import '../../../utils/app_strings.dart';
import 'package:focused_menu/focused_menu.dart';

class ShiftDetailsScreen extends StatefulWidget {
  const ShiftDetailsScreen({Key? key,}) : super(key: key);

  @override
  ShiftDetailsScreenState createState() => ShiftDetailsScreenState();
}

class ShiftDetailsScreenState extends State<ShiftDetailsScreen> {
  ShiftModel? shiftModel;
  bool timeComplete=false;
  bool shiftNotes=false;
  String code=Get.find<BottomBarController>().shiftCode!=null?Get.find<BottomBarController>().shiftCode!:"";
  @override
  void initState() {
      Get.find<ShiftController>().fetchShiftDetail(code: code).then((value){
        if(value.containsKey(API_RESPONSE.SUCCESS)){
          shiftModel=ShiftModel.fromJson(value[API_RESPONSE.SUCCESS]['data']);
          setState((){});
        }
      });
    Timer.periodic(const Duration(seconds: 15), (timer) {
          timeComplete=true;
         if(mounted){
           setState((){});
         }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackGroundColor,
      appBar: CustomAppBar(
        title: AppString.shiftDetails,
        leading: IconButton(
          onPressed: (){

          },
          iconSize: 20,
          icon: const Icon(Icons.menu,color: Colors.white,),
        ),
        trailing: [
          // IconButton(
          //   onPressed: (){},
          //   icon: const Icon(Icons.more_vert,color: Colors.white,),
          // ),
          FocusedMenuHolder(
            menuBoxDecoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(15.0))),
            openWithTap: true,
              menuItems: [
                FocusedMenuItem(// D// ISABLED THIS ITEM
                  onPressed: (){
                    Get.find<BottomBarController>().changeTabIndex(3,isShowsSelected: false,clientsId:shiftModel!.clientId);
                     // Get.toNamed(RouteHelper.getClientDetailRoute());
                  },
                    title: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text("Client Details",style: TextStyle(fontSize: 18),),
                    ),
                ),
              ],
            onPressed: (){},
            child: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(Icons.more_vert,color: Colors.white,),
            ),
          ),

        ],
      ),
      body: SafeArea(
          child: GetBuilder<ShiftController>(builder: (shiftController) {
            return shiftController.isDataFetching&&shiftModel.isNull
                ?const Center(child: CircularProgressIndicator(),)
                : Container(
              width:context.width,
              height: context.height,
              color: AppColor.scaffoldBackGroundColor,
              child: GetBuilder<AuthController>(builder: (authController) {
                DateTime startDate = DateFormat("hh:mma").parse(shiftModel!.breakDetailModel!=null? "${shiftModel!.breakDetailModel!.startTime}PM" :"");
                DateTime endDate = DateFormat("hh:mma").parse(shiftModel!.breakDetailModel!=null?"${shiftModel!.breakDetailModel!.endTime}PM":"");
                Duration diff = endDate.difference(startDate);
                int hour=00;
                int minust=00;
                final List<String> durations = diff.toString().split(':');
                    if(int.parse(durations[0]) > 0){
                      hour=int.parse(durations[0]);
                    }
                if(int.parse(durations[1]) > 0){
                  minust=int.parse(durations[1]);
                }
                // print("diff........>${diff}");
                return ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      ProfileWidgetPortion(onclick: timeComplete,shiftModel:shiftModel,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_DEFAULT),
                        child: Column(
                          children: [
                            CustomTimeLineWidget(
                              tileNumber: 1,
                              tileTitle: 'Job Description',
                              tileChildWidget: Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(top: 8,),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFE4E6F1),)
                                ),
                                child: Text(
                                  shiftModel!.jobDescription,
                                  style: montserratRegular.copyWith(
                                    color: const Color(0xFF6B7094),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            CustomTimeLineWidget(
                              tileNumber: 2,
                              isFirst: false,
                              isLast: false,
                              tileTitle: 'Task List',
                              tileChildWidget: Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(top: 8,),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shiftModel!.taskList,
                                      style: montserratRegular.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            CustomTimeLineWidget(
                              tileNumber: 3,
                              isFirst: false,
                              isLast: false,
                              tileTitle: 'Important Documents',
                              tileChildWidget: Container(
                                margin: const EdgeInsets.only(top: 8,),
                                height: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: shiftModel!.documentModel.length,
                                      itemBuilder: (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: SizedBox(
                                          width: double.infinity,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: (){
                                                        downloadFileDialog( documentModel: shiftModel!.documentModel[index]);
                                                      },
                                                      child: Container(
                                                        padding: const EdgeInsets.all(13),
                                                        decoration: BoxDecoration(
                                                            color: const Color(0xFFE4E6F1),
                                                            borderRadius: BorderRadius.circular(7)
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Image.asset(Images.pdf,width: 16,height: 18,),
                                                            const SizedBox(width: 8,),
                                                            Text(
                                                              shiftModel!.documentModel[index].fileName,
                                                              style: montserratRegular.copyWith(
                                                                fontSize: 9,
                                                                color: const Color(0xFF6B7094),
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              ' ${shiftModel!.documentModel[index].fileSize} kb',
                                                              style: montserratRegular.copyWith(
                                                                fontSize: 14,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                      children: [
                                                        Text(
                                                          'downloaded at  ${shiftModel!.documentModel[index].dateTime}',
                                                          style: montserratRegular.copyWith(
                                                            fontSize: 10,
                                                            color: const Color(0xFF6B7094),
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 20,),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(width: 10,),
                                              Image.asset(Images.circleTick,width: 16,height: 18,),
                                            ],
                                          ),
                                        ),
                                      );
                                    },),
                                    // SizedBox(
                                    //   width: double.infinity,
                                    //   child: Row(
                                    //     children: [
                                    //       Expanded(
                                    //         child: Column(
                                    //           children: [
                                    //             InkWell(
                                    //               onTap: (){
                                    //                 downloadFileDialog(fileName: "Daily Care Plan.pdf");
                                    //               },
                                    //               child: Container(
                                    //                 padding: const EdgeInsets.all(13),
                                    //                 decoration: BoxDecoration(
                                    //                     color: const Color(0xFFE4E6F1),
                                    //                     borderRadius: BorderRadius.circular(7)
                                    //                 ),
                                    //                 child: Row(
                                    //                   children: [
                                    //                     Image.asset(Images.pdf,width: 16,height: 18,),
                                    //                     const SizedBox(width: 8,),
                                    //                     Text(
                                    //                       'Daily Care Plan.pdf',
                                    //                       style: montserratRegular.copyWith(
                                    //                         fontSize: 14,
                                    //                         color: const Color(0xFF6B7094),
                                    //                         fontWeight: FontWeight.w500,
                                    //                       ),
                                    //                     ),
                                    //                     const Spacer(),
                                    //                     Text(
                                    //                       ' 957 kb',
                                    //                       style: montserratRegular.copyWith(
                                    //                         fontSize: 14,
                                    //                         fontWeight: FontWeight.w500,
                                    //                       ),
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               ),
                                    //             ),
                                    //             Row(
                                    //               mainAxisAlignment: MainAxisAlignment.end,
                                    //               children: [
                                    //                 Text(
                                    //                   'not read yet',
                                    //                   style: montserratRegular.copyWith(
                                    //                     fontSize: 10,
                                    //                     color: const Color(0xFF6B7094),
                                    //                     fontWeight: FontWeight.w400,
                                    //                   ),
                                    //                 ),
                                    //                 const SizedBox(width: 20,),
                                    //               ],
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       ),
                                    //       const SizedBox(width: 26,),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),

                            CustomTimeLineWidget(
                              tileNumber: 4,
                              tileTitle: 'Break Details :',
                              isFirst: false,
                              isLast: true,
                              tileChildWidget: Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(top: 8,),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: const Color(0xFFE4E6F1),)
                                ),
                                child: Text(
                                  'You will need to take your break for ${hour > 0? hour.toString():""} ${hour > 0? "hour":""}${minust > 0? hour.toString():""} ${minust > 0? "minutes":""} from ${shiftModel!.breakDetailModel!=null?shiftModel!.breakDetailModel!.startTime:""} - ${shiftModel!.breakDetailModel!=null? shiftModel!.breakDetailModel!.endTime:""}. This break will be ${shiftModel!.breakDetailModel!=null? shiftModel!.breakDetailModel!.status:""}.',
                                  style: montserratRegular.copyWith(
                                    color: const Color(0xFF6B7094),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                GetBuilder<BottomBarController>(builder: (bottomBarController){
                  return CustomButton(
                    onPressed: timeComplete && shiftModel!=null
                        ?(){
                      // shiftController.updateStatus(code: shiftModel!.code, status: "In progress",).then((value) {
                      //   if(value.containsKey(API_RESPONSE.SUCCESS)){
                      //     bottomBarController.changeMainScreenBottomNavIndex(3);
                      //     bottomBarController.changeTabIndex(1,shiftModels: shiftModel!,);
                      //     setState((){});
                      //   }
                      // });
                      if(shiftModel!.status!="Completed"){
                        shiftController.clockIn(code: shiftModel!.code,).then((value) {
                          if(value.containsKey(API_RESPONSE.SUCCESS)){
                            bottomBarController.changeMainScreenBottomNavIndex(3);
                            bottomBarController.changeTabIndex(1,shiftModels: shiftModel!,);
                            setState((){});
                          }
                        });
                      }else{
                        showCustomSnackBar("Shift has been completed");
                      }
                    }
                        :(){},
                    icon: shiftModel!.status!="Completed"? Image.asset(Images.clockIn,width: 20, height: 20,): null,
                    iconAtStart: false,
                    width: 220,
                    color: timeComplete? const Color(0xff65DACC):const Color(0xFF6A7580),
                    buttonText: shiftModel!.status!="Completed"? 'Clock In' : "Shift Completed",
                    radius: 12,
                  );
                }),
                            timeComplete?const SizedBox(height: 10,):Text(
                              "Clock in not available until 10 minutes before shift",
                              textAlign: TextAlign.center,
                              style: montserratBold.copyWith(
                                color: const Color(0xFF6B7094),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                );
              }),
            );
          }),
      )
    );
  }

  Future<void>downloadFileDialog({ required DocumentModel documentModel})async{
    await Get.dialog(
        Dialog(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF000000).withOpacity(0.65),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                  blurStyle: BlurStyle.normal,
                ),
              ],
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "File Download Alert",
                  textAlign: TextAlign.center,
                  style: montserratMedium.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),
                Text(
                  "You are trying to download file :  ${documentModel.fileName}\n\nOnce you download it wil be recorded as  you have read and understood the document. Your supervisor will be notified of it as well.  ",
                  textAlign: TextAlign.center,
                  style: montserratRegular.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF737373),
                  ),
                ),
                const SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),
                CustomButton(
                  onPressed: (){
                    Get.find<ShiftController>().downloadImage(id: documentModel.id, fileName: documentModel.fileName);
                  },
                  radius: 37,
                  width: 230,
                  color: const Color(0xFF23A6F0),
                  buttonText: "Accept and Download",
                ),
              ],
            ),
          ),
        ),
      useSafeArea: false,
    );
  }
}