import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:painter/painter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:workerapp/controller/shift_controller.dart';
import 'package:workerapp/view/screens/shift/widgets/profile_widget_portion.dart';
import 'package:workerapp/view/screens/shift/widgets/time_line_widget.dart';
import '../../../controller/bottom_bar_controller.dart';
import '../../../data/api/Api_Handler/api_error_response.dart';
import '../../../data/model/response/shift_model.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/color_constants.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/styles.dart';
import '../../base/custom_app_bar.dart';
import '../../base/custom_button.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'dart:ui' as ui;
import '../../base/custom_text_field.dart';

class ShiftNotesScreen extends StatefulWidget {
   const ShiftNotesScreen({Key? key,}) : super(key: key);
  @override
  State<ShiftNotesScreen> createState() => _ShiftNotesScreenState();
}

class _ShiftNotesScreenState extends State<ShiftNotesScreen> {
  ShiftModel? shiftModel=Get.find<BottomBarController>().shiftModel;
  final TextEditingController _odometerStart = TextEditingController();
  final TextEditingController _odometerEnd = TextEditingController();
  PainterController controller = PainterController();
   PainterController _controller = _newController();
  bool chargerStatus=true;
  bool vehicleStatus=true;
  GlobalKey previewContainer =  GlobalKey();
  String imagePath="";

  @override
  void initState() {
    super.initState();
  }
  static PainterController _newController() {
    PainterController controller = PainterController();
    controller.thickness = 5.0;
    controller.backgroundColor = Colors.white;
    return controller;
  }

  final _formKey = GlobalKey<FormState>();
  bool isClockOut=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackGroundColor,
      appBar: CustomAppBar(
        title: AppString.shiftNotes,
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
          child: GetBuilder<ShiftController>(builder: (shiftController) {
            return shiftModel!=null?ListView(
              physics: const BouncingScrollPhysics(),
              children:  [
                 ProfileWidgetPortion(isShiftNote: true, currentIndex:0,shiftModel: shiftModel!,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:Dimensions.PADDING_SIZE_DEFAULT),
                  child: Column(
                    children: [
                      CustomTimeLineWidget(
                        circleColor: const Color(0xff1DCA94),
                        tileNumber: 1,
                        tileTitle: 'Task List',
                        iconImage: Image.asset(Images.circleTick,scale: 3,),
                        tileChildWidget: Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(top: 8,),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      padding: const EdgeInsets.only(bottom: 10),
                                      decoration:  BoxDecoration(
                                          color:  Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white.withOpacity(.3))
                                      ),
                                      child: const Center(child: Text(".",style: TextStyle(fontSize: 18,color: Colors.black),)),
                                    ),
                                    const SizedBox(width: 10,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Take client for outing in your vehicle',
                                          style: montserratRegular.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 7,),
                                        Text(
                                          'by 10:00 on Jan 11 2022',
                                          style: montserratRegular.copyWith(
                                            color: Colors.black.withOpacity(.3),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      //padding: const EdgeInsets.only(bottom: 10),
                                      decoration:  BoxDecoration(
                                          color:  const Color(0xff642EFF),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white.withOpacity(.3))
                                      ),
                                      child: Center(child: Image.asset(Images.right, scale: 3,)),
                                    ),
                                    const SizedBox(width: 10,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Update Illustration',
                                          style: montserratRegular.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 7,),
                                        Text(
                                          'by 10:00 on Jan 11 2022',
                                          style: montserratRegular.copyWith(
                                            color: Colors.black.withOpacity(.3),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10,),
                                Row(
                                  children: [
                                    Container(
                                      height: 30,
                                      width: 30,
                                      padding: const EdgeInsets.only(bottom: 10),
                                      decoration:  BoxDecoration(
                                          color:  Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white.withOpacity(.3))
                                      ),
                                      child: const Center(child: Text(".",style: TextStyle(fontSize: 18,color: Colors.black),)),
                                    ),
                                    const SizedBox(width: 10,),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Design Landing',
                                          style: montserratRegular.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 7,),
                                        Text(
                                          'by 10:00 on Jan 11 2022',
                                          style: montserratRegular.copyWith(
                                            color: Colors.black.withOpacity(.3),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )
                          // Text(
                          //   'Lorem ipsum is simply dummy text of the printing and typesetting industry.',
                          //   style: montserratRegular.copyWith(
                          //     color: const Color(0xFF6B7094),
                          //     fontSize: 14,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // ),
                        ),
                      ),
                      CustomTimeLineWidget(
                        tileNumber: 2,
                        iconImage: Image.asset(Images.circleTick,scale: 3,),
                        isFirst: false,
                        isLast: false,
                        tileTitle: 'Shift Notes',
                        tileChildWidget: Container(
                          height: 100,
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(top: 8,),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.5),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFFE4E6F1),)
                          ),
                          child: Text(
                            'Lorem ipsum is simply dummy text of the printing and typesetting industry.',
                            style: montserratRegular.copyWith(
                              color: const Color(0xFF6B7094),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      CustomTimeLineWidget(
                        tileNumber: 3,
                        isFirst: false,
                        isLast: false,
                        tileTitle: 'Upload Photos',
                        tileChildWidget: Container(
                          height: 120,
                          margin: const EdgeInsets.only(top: 8,),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: shiftModel!.documentModel.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              InkWell(
                                                onTap: (){
                                                  //downloadFileDialog(fileName: "Eating Plan.pdf");
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
                                                      Expanded(
                                                        flex: 20,
                                                        child: Text(
                                                          shiftModel!.documentModel[index].fileName,
                                                          maxLines: 1,
                                                          style: montserratRegular.copyWith(
                                                            fontSize: 12,
                                                            color: const Color(0xFF6B7094),
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10,),
                                                      shiftModel!.documentModel[index].isDownload?Image.asset(Images.circleTick,width: 14,height: 18,):const SizedBox(),
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
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'read on 2 Feb 2022 11:35hrs',
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
                                        Image.asset(Images.minus,width: 18,height: 18,),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 7,),
                                  // SizedBox(
                                  //   width: double.infinity,
                                  //   child: Row(
                                  //     children: [
                                  //       Expanded(
                                  //         child: Column(
                                  //           children: [
                                  //             InkWell(
                                  //               onTap: (){
                                  //                 // downloadFileDialog(fileName: "Daily Care Plan.pdf");
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
                                  //                       'screenshot_219857884.jpeg',
                                  //                       style: montserratRegular.copyWith(
                                  //                         fontSize: 12,
                                  //                         color: const Color(0xFF6B7094),
                                  //                         fontWeight: FontWeight.w500,
                                  //                       ),
                                  //                     ),
                                  //                     const SizedBox(width: 10,),
                                  //                     Image.asset(Images.circleTick,width: 14,height: 18,),
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
                                  //
                                  //           ],
                                  //         ),
                                  //       ),
                                  //       const SizedBox(width: 10,),
                                  //       Image.asset(Images.minus,width: 18,height: 18,),
                                  //
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                      CustomTimeLineWidget(
                        tileNumber: 4,
                        tileTitle: 'Travel / Transport Details',
                        isFirst: false,
                        isLast: false,
                        tileChildWidget: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'OdometerStart',
                                          style: montserratRegular.copyWith(
                                            color: const Color(0xFF6B7094),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),),
                                        CustomInputTextField(
                                          controller: _odometerStart,
                                          keyboardType: TextInputType.number,
                                          // focusNode: _toFocus,
                                          isPassword: false,
                                          context: context,
                                          hintText: AppString.text,
                                          height: 50,
                                          width: 100,
                                          backGroundColor:Colors.transparent,
                                          contextPadding: 8,
                                          // fillColor: Colors.transparent,
                                           fontSize: 12,
                                          borderColor: Colors.grey.withOpacity(.3),
                                          //prefixIcon: Image.asset(Images.profile,scale: 28,color: Colors.white,),
                                          // prefixIcon:   Padding(
                                          //   padding: const EdgeInsets.all(10.0),
                                          //   child: Container(
                                          //     height: 20,
                                          //     width: 20,
                                          //     decoration: const BoxDecoration(
                                          //       shape: BoxShape.circle,
                                          //       color: Color(0xff757575),
                                          //     ),
                                          //     child: Center(
                                          //       child: Text(
                                          //         "D",
                                          //         style: varelaRoundRegular.copyWith(
                                          //           fontSize:8,
                                          //           color: Colors.black,
                                          //         ),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          // validator: (inputData) {
                                          //   return inputData!.trim().isEmpty
                                          //       ? ErrorMessage.nameEmptyError
                                          //       : inputData.length > 250
                                          //       ? "ErrorMessage.emailMaxLengthError"
                                          //       : null;
                                          // },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15,),
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'OdometerEnd',
                                          style: montserratRegular.copyWith(
                                            color: const Color(0xFF6B7094),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                          ),),
                                        CustomInputTextField(
                                          controller: _odometerEnd,
                                          keyboardType: TextInputType.number,
                                          // focusNode: _toFocus,
                                          isPassword: false,
                                          context: context,
                                          hintText: AppString.text,
                                          height: 50,
                                          width: 100,
                                          backGroundColor:Colors.transparent,
                                          contextPadding: 8,
                                          fontSize: 12,
                                          borderColor: Colors.grey.withOpacity(.3),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15,),
                              Row(children: [
                                Expanded(
                                  flex:3,
                                  child: Text(
                                    "Used Own vehicle",
                                    style: montserratRegular.copyWith(
                                      color: const Color(0xFF160042),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                // const Spacer(),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 0),
                                    child: Row(
                                      children: [
                                        FlutterSwitch(
                                            activeColor:const Color(0xff0FA958),
                                            padding:2,
                                            width: 40,
                                            height: 17,
                                            toggleSize:20,
                                            value: vehicleStatus,
                                            onToggle: (val) async {
                                              setState(() {
                                                vehicleStatus = val;
                                              });
                                            }
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],),
                              const SizedBox(height: 20,),
                            ],
                          ),
                        ),
                      ),
                      CustomTimeLineWidget(
                        tileNumber: 5,
                        iconImage: Image.asset(Images.circleClose,scale: 3,),
                        isFirst: false,
                        isLast: false,
                        tileTitle: 'Client Signature :',
                        tileChildWidget: Center(
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _controller = _newController();
                                });
                              },

                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RepaintBoundary(
                                  key: previewContainer,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: AspectRatio(
                                        aspectRatio: 16/9,
                                        child:  Painter(_controller)),
                                  ),
                                ),
                              ),
                            )
                        ),
                      ),
                      const SizedBox(height: 20,),
                      CustomTimeLineWidget(
                        tileNumber: 6,
                        isFirst: false,
                        isLast: true,
                        tileTitle: 'Reportable Incidents ?',
                        titleRowWidget:  Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: FlutterSwitch(
                              activeColor:const Color(0xff0FA958),
                              padding:2,
                              width: 40,
                              height: 17,
                              toggleSize:20,
                              value: chargerStatus,
                              onToggle: (val) async {
                                setState(() {
                                  chargerStatus = val;
                                });
                              }
                          ),
                        ),
                        tileChildWidget: const SizedBox(),
                      ),
                      const SizedBox(height: 20,),
                      CustomButton(
                        onPressed:() async {
                          _takeScreenshot();
                          Future.delayed(const Duration(milliseconds: 500),(){
                            updateShiftStatus(shiftController,shiftModel!);
                            shiftController.clockOut(code: shiftModel!.code);
                          });
                        },
                        icon: Image.asset(Images.forwardIcon,width: 30, height: 25,),
                        iconAtStart: false,
                        width: 180,
                        color: const Color(0xff65DACC),
                        buttonText: 'CLOCK OUT',
                        radius: 25,
                      ),
                      const SizedBox(height: 20,),
                    ],
                  ),
                ),
              ],
            ):const SizedBox();
          })
      ),
      ),
    );
  }

  void _takeScreenshot() async {
    RenderRepaintBoundary boundary = previewContainer.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final directory = (await getApplicationDocumentsDirectory()).path;
    imagePath=directory;
  }

 void updateShiftStatus(ShiftController shiftController, ShiftModel shiftModel){
    String code = shiftModel.code;
    String status="Completed";
    String odometerStart=_odometerStart.text.trim();
    String odometerEnd=_odometerEnd.text.trim();
    int vehicleUse=vehicleStatus?0:1;
    String path=imagePath;
    shiftController.updateShiftStatus(code,status,odometerStart,odometerEnd,vehicleUse,path).then((value) {
      if(value.containsKey(API_RESPONSE.SUCCESS)){
        Get.find<BottomBarController>().changeTabIndex(2);
        Get.find<BottomBarController>().changeMainScreenBottomNavIndex(3);
        setState((){});
      }
    });
 }
}
