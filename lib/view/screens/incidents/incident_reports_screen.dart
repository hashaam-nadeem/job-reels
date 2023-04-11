import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workerapp/controller/auth_controller.dart';
import 'package:workerapp/utils/app_strings.dart';
import 'package:workerapp/utils/color_constants.dart';
import 'package:workerapp/utils/dimensions.dart';
import 'package:workerapp/utils/styles.dart';
import 'package:workerapp/view/base/custom_app_bar.dart';
import 'package:workerapp/view/screens/shift/widgets/profile_widget_portion.dart';

class IncidentReportsScreen extends StatefulWidget {
  const IncidentReportsScreen({Key? key}) : super(key: key);

  @override
  State<IncidentReportsScreen> createState() => _IncidentReportsScreenState();
}

class _IncidentReportsScreenState extends State<IncidentReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackGroundColor,
      appBar: CustomAppBar(
        title: AppString.incidentReports,
        leading: IconButton(
          onPressed: (){

          },
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
            child: GetBuilder<AuthController>(builder: (authController) {
              return ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    const ProfileWidgetPortion(currentIndex: 0,isMyProfile: true,),
                    Column(
                      children: [
                        const SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),
                        ListView.builder(
                            itemCount: 4,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (BuildContext listViewContext,int index){
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: const Color(0xFFD0D8E8),width: 0.5),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 1.5),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 75,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: const Color(0xFF000000),),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '28\nJuly',
                                          textAlign: TextAlign.center,
                                          style: montserratMedium.copyWith(fontWeight: FontWeight.w700,fontSize: 20,color: Color(0xFF1F4172)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT,),
                                    Expanded(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Client : Adam Guacamole',
                                            style: montserratRegular.copyWith(fontWeight: FontWeight.w600,fontSize: 18,color: Color(0xFF4B3E5F)),
                                          ),
                                          const SizedBox(height: 10,),
                                          Flexible(
                                            child: Text(
                                              'went with Adam to the mall and a car crashed into company vehicle',
                                              style: montserratRegular.copyWith(fontWeight: FontWeight.w400,fontSize: 16,color: Color(0xFF06225A)),
                                            ),
                                          ),
                                          const SizedBox(height: 10,),
                                          Flexible(
                                            child: Text(
                                              'Submitted on 30 July 2022, 1030 AM',
                                              style: montserratRegular.copyWith(fontWeight: FontWeight.w400,fontSize: 14,color: Color(0xFF6A7580)),
                                            ),
                                          ),

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                        ),
                        const SizedBox(height: 15,),
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
                        const SizedBox(height: 15,),
                      ],
                    ),
                  ]
              );
            }),
          )),
    );
  }
}
