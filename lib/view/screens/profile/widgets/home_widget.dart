import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workerapp/utils/app_images.dart';
import 'package:workerapp/view/screens/shift/widgets/profile_widget_portion.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../utils/styles.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return  GetBuilder<AuthController>(builder: (authController){
      return authController.userInfoModel!=null?Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
            decoration: BoxDecoration(
                color: const Color(0xFFFFF6EF),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFFFC2E00),)
            ),
            child: Row(
              children: [
                Image.asset(
                  Images.alert,
                  height: 25,
                  width: 30,
                ),
                const SizedBox(width: 20,),
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        authController.userInfoModel!.expiryMessage,
                        maxLines: 2,
                        style: montserratMedium.copyWith(fontSize: 14,color: const Color(0xFFE77C40),fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          const SizedBox(width: 20,),
          SizedBox(
            width: context.width,
            child: Row(
              children: [
                Expanded(
                  child: HomeCard(
                    topRightCornerImage: Image.asset(
                      Images.circleTick,
                      height: 13,
                      width: 13,
                    ),
                    number: authController.userInfoModel!.totalShift.toString(),
                    numberBackground: const Color(0xFF0FA958),
                    title: "Shifts this month",
                    description: 'more from last month',
                    moreText: "+12%",
                  ),
                ),
                Expanded(
                  child: HomeCard(
                    topRightCornerImage: Image.asset(
                      Images.circleTick,
                      height: 13,
                      width: 13,
                    ),
                    number: authController.userInfoModel!.cancelledShift.toString(),
                    numberBackground: const Color(0xFFA9340F),
                    title: "Cancellations",
                    description: 'more from last month',
                    moreText: "+12%",
                  ),
                ),
                Expanded(
                  child: HomeCard(
                    topRightCornerImage: Image.asset(
                      Images.circleClose,
                      height: 13,
                      width: 13,
                    ),
                    number: authController.userInfoModel!.documentExpiring.toString(),
                    numberBackground: const Color(0xFFFB3003),
                    title: "Documents Expiring",
                    description: 'In the next 7 Days',
                    moreText: null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              children: [
                ChipTileTextWidget(title: "Diabetes",icon: Image.asset(Images.circleTick,height: 13,width: 13,),iconAtStart: false,),
                ChipTileTextWidget(title: "Manual Handling",icon: Image.asset(Images.circleTick,height: 13,width: 13,),iconAtStart: false,),
                ChipTileTextWidget(title: "First Aid",icon: Image.asset(Images.circleTick,height: 13,width: 13,),iconAtStart: false,),
                const ChipTileTextWidget(title: "CPR",icon: Icon(Icons.cancel_outlined,color: Colors.red,size: 13,),iconAtStart: false,isError: true,),
                ChipTileTextWidget(title: "Medication",icon: Image.asset(Images.circleTick,height: 13,width: 13,),iconAtStart: false,),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
            margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
            decoration: BoxDecoration(
                color: const Color(0xFFF8FAFF),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(color: const Color(0xFF23A6F0),)
            ),
            child: Row(
              children: [
                Image.asset(
                  Images.notification,
                  height: 25,
                  width: 30,
                ),
                const SizedBox(width: 20,),
                Flexible(
                  child: Text(
                    authController.userInfoModel!.nextShiftMessage,
                    maxLines: 3,
                    style: montserratMedium.copyWith(fontSize: 14,color: const Color(0xFF23A6F0),fontWeight: FontWeight.w500),
                  ),
                ),

              ],
            ),
          ),
        ],
      ):SizedBox();
    });


  }
}

class HomeCard extends StatelessWidget {
  final Widget topRightCornerImage;
  final String number;
  final Color numberBackground;
  final String title;
  final String description;
  final String ?moreText;
  const HomeCard({
    Key? key,
    required this.topRightCornerImage,
    required this.number,
    required this.numberBackground,
    required this.title,
    required this.description,
    required this.moreText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF000000).withOpacity(0.21),),
            borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            children: [
              const SizedBox(height: 5,),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                decoration: BoxDecoration(
                  color: numberBackground,
                  borderRadius: const BorderRadius.all(Radius.elliptical(100, 90)),
                ),
                child: Text(
                    number,
                  textAlign: TextAlign.center,
                  style: montserratMedium.copyWith(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.w700
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: montserratMedium.copyWith(
                    fontSize: 12,
                    color: Colors.black,
                    fontWeight: FontWeight.w700
                ),
              ),
              const SizedBox(height: 5,),
              Text.rich(
                TextSpan(
                  text: moreText??description,
                  style: montserratMedium.copyWith(
                      fontSize: 10,
                      color: moreText!=null?const Color(0xFF0FA958): const Color(0xFF6B7094),
                      fontWeight: FontWeight.w700
                  ),

                  children:moreText==null?[]: [
                    TextSpan(
                      text: " $description",
                      style: montserratMedium.copyWith(
                          fontSize: 10,
                          color: const Color(0xFF6B7094),
                          fontWeight: FontWeight.w700
                      ),
                    ),
                  ]
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Positioned(
          top: 7,
          right: 13,
          child: topRightCornerImage,
        ),
      ],
    );
  }
}

