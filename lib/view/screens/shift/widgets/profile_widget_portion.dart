import 'package:flutter/material.dart';
import 'package:workerapp/data/model/response/shift_model.dart';
import 'package:workerapp/utils/app_images.dart';
import 'package:workerapp/utils/app_strings.dart';
import 'package:workerapp/utils/color_constants.dart';
import 'package:workerapp/utils/dimensions.dart';
import '../../../../utils/styles.dart';

class ProfileWidgetPortion extends StatelessWidget {

  final bool isMyProfile;
  final int currentIndex;
  final bool? onclick;
  final bool? isShiftNote;
  final bool? isAddressRequired;
  final bool wantTimeScheduleWidget;
  final ShiftModel? shiftModel;


  const ProfileWidgetPortion({Key? key, this.isMyProfile=false, this.currentIndex=1,  this.onclick=false, this.wantTimeScheduleWidget=true, this.isShiftNote=false,this.isAddressRequired=true, this.shiftModel,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          /// Image and address portion
          SizedBox(
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex:1,
                  child: shiftModel!=null?Image.network(
                      shiftModel!.profile,
                  ):Image.asset(Images.profile),
                ),
                const SizedBox(width: 10,),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shiftModel!=null? shiftModel!.name:"Ms. Alix Tamayo Witherspoon",
                        style: montserratMedium.copyWith(fontSize: 19,color: Colors.black),),
                      const SizedBox(height: 10,),
                      isAddressRequired!
                          ?Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            Images.location,
                            color: const Color(0xFFFC2E00),
                            width: 22,
                            height: 33,
                          ),
                          const SizedBox(width: 12,),
                          Text(
                              shiftModel!=null? shiftModel!.address:"Unit 3, 171 - 179 Queen Street Campbelltown, NSW. 2560 ",
                            style: montserratMedium.copyWith(fontSize: 12,color: const Color(0xFF1270B0),height: 1.5)
                          ),
                          const Spacer(),
                          isMyProfile
                              ? InkWell(
                                onTap: (){},
                                radius: 100,
                                child: Container(
                                  height: 25,
                                  width: 25,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF008DA6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(child: Icon(Icons.edit, color: Colors.white,size: 14,)),
                                ),
                              )
                              :const SizedBox(),
                        ],
                      )
                          : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                        children: [
                            Text(
                              "11 Jan 2022      10:00 AM - 12:30 PM",
                              style: montserratRegular.copyWith(
                                 color: Colors.black.withOpacity(.3),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),),
                        ],
                      ),
                          ),

                    ],
                  ),
                ),
              ],
            ),
          ),
          /// further info portion
          const SizedBox(height: 10,),
         wantTimeScheduleWidget? SizedBox(
            width: isMyProfile ? 0: double.infinity,
            height: isMyProfile ? 0:null,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: Column(
                      children:  [
                        TimeScheduleWidget(scheduledTime: shiftModel!=null?shiftModel!.startDate:"11 Jan 2022", imagePath: Images.calendarMonth),
                        Row(
                          children: [
                            TimeScheduleWidget(scheduledTime: shiftModel!=null?shiftModel!.startTime:"10:00", imagePath: Images.clockImage),
                            TimeScheduleWidget(scheduledTime: '--    ${shiftModel!=null?shiftModel!.endTime:"12:00"}',),
                          ],
                        ),
                        const TimeScheduleWidget(scheduledTime: '30 mints 11:30 - 12:00', imagePath: Images.coffee),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children:  [
                      const AllocatedProcessingWidget(containerText: 'Allocated'),
                      isShiftNote!
                          ? Padding(
                        padding: const EdgeInsets.only(left: 10,right: 10,top: 8,bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(Images.baseLine,scale: 3,),
                            Image.asset(Images.alertRed,scale: 3,),
                            Image.asset(Images.help,scale: 3,),
                          ],
                        ),
                      )
                          :const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ):const SizedBox(),
          SizedBox(height: isMyProfile ? 0: 10,),
          isMyProfile
                ? SizedBox(
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
            )
                : onclick!
              ? const SizedBox()
              : SizedBox(
            width: double.infinity,
            child: Wrap(
              children: const [
                ChipTileTextWidget(title: "Austism"),
                ChipTileTextWidget(title: "Prada Willi"),
                ChipTileTextWidget(title: "Aspergers"),
                ChipTileTextWidget(title: "Depression"),
                ChipTileTextWidget(title: "Anxiety"),
              ],
            ),
          ),
          shiftModel!=null?
          isShiftNote!
              ? const SizedBox()
              :SizedBox(height: isMyProfile?0:null,width: isMyProfile?0:null, child: onclick!? ExtraInfoRow(shiftModel: shiftModel!,): const WarningWidget()):const SizedBox(),
        ],
      ),
    );
  }
}

class TimeScheduleWidget extends StatelessWidget {
  final String? imagePath;
  final String scheduledTime;
  const TimeScheduleWidget({Key? key, required this.scheduledTime, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        children: [
          imagePath != null? Image.asset(
            imagePath!,
            height: 14,
            width: 13,
          )
              :const SizedBox(),
          const SizedBox(width: 10,),
          Text(
            scheduledTime,
            style: montserratMedium.copyWith(fontSize: 12,color: const Color(0xFF6B7094)),),
        ],
      ),
    );
  }
}
class AllocatedProcessingWidget extends StatelessWidget {
  final String containerText;

  const AllocatedProcessingWidget({Key? key, required this.containerText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 37,
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF11BB37),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Center(
        child: Text(
          containerText,
          style: montserratMedium.copyWith(fontSize: 16,color: Colors.white,fontWeight: FontWeight.w700,),),
      ),
    );
  }
}

class ChipTileTextWidget extends StatelessWidget {
  final String title;
  final Widget ?icon;
  final bool iconAtStart;
  final bool isError;
  const ChipTileTextWidget({Key? key, required this.title, this.icon, this.iconAtStart = true, this.isError=false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: isError? Colors.red : AppColor.primaryColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon != null&& iconAtStart ? Padding(
            padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: icon,
          ) : const SizedBox(),
          Text(
            title,
            style: montserratMedium.copyWith(fontSize: 14,color: AppColor.primaryColor,fontWeight: FontWeight.w600,),),
          icon != null&& !iconAtStart ? Padding(
            padding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            child: icon,
          ) : const SizedBox(),
        ],
      ),
    );
  }
}

class WarningWidget extends StatelessWidget {
  const WarningWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
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
                "Client has a dog, please contact the client before entering the premises.",
                style: montserratMedium.copyWith(fontSize: 14,color: const Color(0xFFE77C40),fontWeight: FontWeight.w500,),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ExtraInfoRow extends StatelessWidget {
  final ShiftModel shiftModel;
  const ExtraInfoRow({Key? key, required this.shiftModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                Images.baseLine,
                //color: const Color(0xFFFC2E00),
                scale: 2.5,
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap:true,
                  itemCount: shiftModel.participantTag.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TextWidgetWithNumber(number: "${shiftModel.participantTag[index].id.toString()}.", label: shiftModel.participantTag[index].name,);
                  },
                ),
              )
            ],
          )),
          Expanded(child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                Images.alertRed,
                //color: const Color(0xFFFC2E00),
               scale: 3,
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  TextWidgetWithNumber(number: '1.', label: "Allergic to Nuts",),
                  TextWidgetWithNumber(number: '2.', label: "Has a dog",),
                  TextWidgetWithNumber(number: '3.', label: "Ring client first",),
                ],
              )
            ],
          ))
        ],
      ),
    );
  }
}

class TextWidgetWithNumber extends StatelessWidget {
  final String number;
  final String label;
  const TextWidgetWithNumber({
    Key? key, required this.number, required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(number,style: montserratMedium.copyWith(fontSize: 14,color: Colors.lightBlueAccent),),
      Text(label,style: montserratMedium.copyWith(fontSize: 14,color: Colors.lightBlueAccent),),
    ],);
  }
}



