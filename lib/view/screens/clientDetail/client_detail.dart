import 'dart:convert';

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';
import 'package:workerapp/controller/bottom_bar_controller.dart';
import 'package:workerapp/controller/client_controller.dart';
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
  int currentTabIndex = 0;
  List<Widget>tabBarWidgetList = <Widget>[
    const DocumentWidget(isAdd: false,),
     const ShiftNotes(),
  ];
late List<ParticipantTag> participantTag;
int clientId=Get.find<BottomBarController>().clientId ?? 0;
  @override
  void initState() {
    Get.find<ClientController>().fetchClientDetail(clientsId: clientId).then((value){
      if(value.containsKey(API_RESPONSE.SUCCESS)){
        //shiftModel=ShiftModel.fromJson(value[API_RESPONSE.SUCCESS]['data']);
        // participantTag=List<ParticipantTag>.from(ParticipantTag.fromJson(value[API_RESPONSE.SUCCESS]['participant_tags']).map((model)=> ParticipantTag.fromJson(model)));
        // participantTag = ParticipantTag.fromJson(value[API_RESPONSE.SUCCESS]['participant_tags'])!=null?List<ParticipantTag>.from(json['participant_tags'].map((model)=> ParticipantTag.fromJson(model))):[];
        // setState((){});
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
                const ProfileWidgetPortion(wantTimeScheduleWidget: false,),
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
