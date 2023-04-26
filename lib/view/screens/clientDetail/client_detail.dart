import 'dart:convert';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:workerapp/controller/bottom_bar_controller.dart';
import 'package:workerapp/controller/client_controller.dart';
import 'package:workerapp/data/model/response/client_model.dart';
import 'package:workerapp/view/screens/clientDetail/widget/shift_notes.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/shift_controller.dart';
import '../../../data/api/Api_Handler/api_error_response.dart';
import '../../../data/model/response/participantTag_model.dart';
import '../../../utils/app_images.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/color_constants.dart';
import '../../../utils/styles.dart';
import '../../base/custom_app_bar.dart';
import '../profile/widgets/documnet_widget.dart';
import '../profile/widgets/shifts_widget.dart';
import '../shift/widgets/profile_widget_portion.dart';

class ClientDetails extends StatefulWidget {
  const ClientDetails({Key? key}) : super(key: key);

  @override
  State<ClientDetails> createState() => _ClientDetailsState();
}

class _ClientDetailsState extends State<ClientDetails> {

  ClientModel? clientModel;
  int currentTabIndex = 0;
  List<Widget>tabBarWidgetList = <Widget>[
     DocumentWidget(isAdd: false,clientId: Get.find<BottomBarController>().clientId,),
    ShiftNotes(clientId: Get.find<BottomBarController>().clientId,),
  ];
late List<ParticipantTag> participantTag;
  int clientId=Get.find<BottomBarController>().clientId ?? 0;
  @override
  void initState() {
    Get.find<ClientController>().fetchClientDetail(clientsId: clientId).then((value){
      if(value.containsKey(API_RESPONSE.SUCCESS)){
        clientModel=ClientModel.fromJson(value[API_RESPONSE.SUCCESS]['data']);
        // participantTag=List<ParticipantTag>.from(ParticipantTag.fromJson(value[API_RESPONSE.SUCCESS]['participant_tags']).map((model)=> ParticipantTag.fromJson(model)));
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
        title: AppString.clientDetails,
        leading: IconButton(
          onPressed: (){
          },
          iconSize: 20,
          icon: const Icon(Icons.menu,color: Colors.white,),
        ),
      ),
      body: SafeArea(
          child: Container(
              width:context.width,
              height: context.height,
              color: AppColor.scaffoldBackGroundColor,
              child: GetBuilder<AuthController>(builder: (authController) {
                return Column(
                // physics: const BouncingScrollPhysics(),
                children:  [
                  clientModel!=null? ProfileWidgetPortion(clientModel:clientModel!,onclick:false,wantTimeScheduleWidget:false):const SizedBox(),
                  clientModel!=null?Material(
                    elevation: 5,
                    child: Container(
                      width: double.infinity,
                      color: const Color(0xFFFFECDC),
                      padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 15),
                      child: Row(
                        children: [
                          Image.asset(Images.alert,height: 26,width: 30,),
                          const SizedBox(width: 20,),
                          Expanded(
                            child: Text(
                              clientModel!.alert,
                              style: montserratMedium.copyWith(fontSize: 14,color: const Color(0xFFE77C40),fontWeight: FontWeight.w500,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ):const SizedBox(),
                  const SizedBox(height: 20,),
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [
                  //       Expanded(
                  //         flex:1,
                  //         child: clientModel!=null?Image.asset(Images.profile):Image.network(
                  //           clientModel!.name,
                  //         ),
                  //       ),
                  //       const SizedBox(width: 10,),
                  //       Expanded(
                  //         flex: 3,
                  //         child: Padding(
                  //           padding: const EdgeInsets.only(top: 12.0),
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Text(
                  //                 clientModel!=null?clientModel!.name:"Ms. Alix Tamayo Witherspoon",
                  //                 style: montserratMedium.copyWith(fontSize: 19,color: Colors.black),),
                  //               const SizedBox(height: 10,),
                  //              Row(
                  //                 crossAxisAlignment: CrossAxisAlignment.start,
                  //                 children: [
                  //                   Image.asset(
                  //                     Images.location,
                  //                     color: const Color(0xFFFC2E00),
                  //                     width: 22,
                  //                     height: 33,
                  //                   ),
                  //                   const SizedBox(width: 12,),
                  //                   Text(
                  //                       clientModel!=null?clientModel!.address:"Unit 3, 171 - 179 Queen Street Campbelltown, NSW. 2560 ",
                  //                       style: montserratMedium.copyWith(fontSize: 12,color: const Color(0xFF1270B0),height: 1.5)
                  //                   ),
                  //                   const Spacer(),
                  //                 ],
                  //               ),
                  //
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  NeumorphicToggle(
                    style: const NeumorphicToggleStyle(
                      depth: 200,
                      backgroundColor: Colors.white,
                    ),
                    selectedIndex: currentTabIndex,
                    onChanged: (value){
                      currentTabIndex = value;
                      setState((){});
                    },
                    height: 50,
                    children: [
                      ToggleElement(
                        background: menuWidgetButton(text: 'Documents',image: Images.grid,isSelected: currentTabIndex==0),
                        foreground: menuWidgetButton(text: 'Documents',image: Images.grid,isSelected: currentTabIndex==0),
                      ),
                      ToggleElement(
                        background: menuWidgetButton(text: 'Shift Notes',image: Images.vector,isSelected: currentTabIndex==1),
                        foreground: menuWidgetButton(text: 'Shift Notes',image: Images.vector,isSelected: currentTabIndex==1),
                      ),
                    ],
                    thumb: Neumorphic(
                      style: const NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        color: Colors.white,
                        depth: -200,
                      ),
                      child: Container(
                        color: const Color(0xFFEFF6FF),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                      ),
                    ),),
                  const SizedBox(height: 10,),
                  Expanded(
                      child: Scrollbar(
                        child: ListView(
                          children: [
                            tabBarWidgetList[currentTabIndex],
                          ],
                        ),
                      )
                  ),
                ]
                );
    }
      ),),),
    );
  }
  Widget menuWidgetButton({required String image, required String text,bool isSelected = false}){
    return Center(
      child: Neumorphic(
        style: const NeumorphicStyle(
          shape: NeumorphicShape.convex,
          color: Colors.transparent,
          surfaceIntensity: 0,
          depth: 00,
        ),
        drawSurfaceAboveChild:false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              image,
              height: 16,
              width: 16,
              color: isSelected ?const Color(0xFF1554F6): const Color(0xFF3C3E45),
            ),
            const SizedBox(width: 5,),
            Text(
              text,
              style: isSelected? montserratSemiBold.copyWith(fontSize: 12):montserratRegular.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
