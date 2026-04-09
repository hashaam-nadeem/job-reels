import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glow_solar/data/model/response/notification_model.dart';
import 'package:glow_solar/util/app_strings.dart';
import 'package:intl/intl.dart';
import '../../../../controller/auth_controller.dart';
import '../../../../controller/notification_controller.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/app_constants.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';
import '../../../base/custom_button.dart';
import '../../charger controller/widgets/request_charger_item_widget.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class NotificationControllerItemWidget extends StatefulWidget {
  final int notificationsId;
  const NotificationControllerItemWidget({Key? key, required this.notificationsId}) : super(key: key);
  @override
  State<NotificationControllerItemWidget> createState() => _NotificationControllerItemWidgetState();
}

class _NotificationControllerItemWidgetState extends State<NotificationControllerItemWidget> {
  var now =  DateTime.now();
  var formatter =  DateFormat.yMMMMd('en_US').add_jm();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationController>(builder: (notificationController){
      Notifications? notifications = notificationController.getNotificationWithId( id: widget.notificationsId);
      return  GestureDetector(
        onTap: notifications!=null?(){
          showDetail(notifications);
          notificationController.getNotificationReadStatus(status: true, id:notifications.id );
        }:(){},
        child: Slidable(
          key: ValueKey(widget.notificationsId),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            dismissible: DismissiblePane(onDismissed: () {
        notificationController.deleteSolar(id: widget.notificationsId);
            }),
            children:  [
              SlidableAction(
                backgroundColor: const Color(0xFFFE4B00),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
                borderRadius: BorderRadius.circular(11),
                onPressed: (BuildContext context) {
                  notificationController.deleteSolar(id: widget.notificationsId);
                 // notificationController.removeNotification( id:widget.notificationsId,);
                },
              ),
            ],
          ),
          child: notifications!=null?Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
              // color: Theme.of(context).backgroundColor,
              color: notifications.isRead
                  ? Theme.of(context).backgroundColor
                  : Theme.of(context).primaryColor.withOpacity(0.2) ,
              borderRadius: BorderRadius.circular(11),
            ),
            padding: const EdgeInsets.only(left:10,right: 15,top: 12,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                NotificationText(label: notifications.title, size: 16,fontWeight:FontWeight.w500,),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            NotificationText(label: "${AppString.chargingAmount}:",size: 12,color: Theme.of(context).primaryColorDark,),
                            NotificationText(label: notifications.chargerRequest!.getPayment? "\$ ${notifications.chargerRequest!.amount}":"Free",size: 12,color: Theme.of(context).primaryColorDark.withOpacity(0.5),),
                          ],
                        ),
                        NotificationText(label: getProductTime(notifications.time),size: 12,fontWeight:FontWeight.w400,),
                        //NotificationText(label: DateFormat.yMMMMd('en_US').add_jm().format(DateTime.parse(notifications.time)),size: 12,fontWeight:FontWeight.w400,),
                      ],
                    ),
                    const Spacer(),
                    Get.find<AuthController>().isLoginUser(userId: notifications.chargerRequest!.user.id) && (notifications.chargerRequest!.getPayment && notifications.chargerRequest!.paymentStatus==0&&notifications.chargerRequest!.status==1)
                        ? Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: CustomButton(
                        height: 40,
                        width: 110,
                        onPressed: () {
                          Get.toNamed(RouteHelper.getPaymentRoute(notificationId: widget.notificationsId));
                          notificationController.getNotificationReadStatus(status: true, id:notifications.id );
                        },
                        buttonText: "Pay now",
                      ),
                    ):const SizedBox()
                  ],
                ),
                const SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),
              ],
            ),
          ):const SizedBox(),
        ),
      );
    });
  }

  void showDetail(Notifications notifications){
    if(notifications.chargerRequest!=null){
      /// Open Request Dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.padding),
            ),
            elevation: 0,
            contentPadding: const EdgeInsets.all(0),
            insetPadding: const EdgeInsets.all(0),
            actionsPadding: const EdgeInsets.all(0),
            buttonPadding: const EdgeInsets.all(0),
            titlePadding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
            backgroundColor: Colors.transparent,
            title: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(AppConstants.padding),
                  boxShadow: const [
                    BoxShadow(color: Colors.black, offset: Offset(0, 1), blurRadius: 6),
                  ]
              ),
              child: RequestChargerItemWidget(
                chargerRequest: notifications.chargerRequest!,
                isFromDialog: true,
              ),
            ),
          );
        },
      );
    }
  }

  String getProductTime(String notificationTime){
    String time = '';
    DateTime currentDateTime = DateTime.now();
    int currentMilliSecondsSinceEpoch = currentDateTime.millisecondsSinceEpoch;
    DateTime postTime = DateTime.parse(notificationTime).toLocal();
    int postMilliSecondsSinceEpoch = postTime.millisecondsSinceEpoch;
    double secondsBefore = ((currentMilliSecondsSinceEpoch-postMilliSecondsSinceEpoch)/1000);
    int minutesBefore = secondsBefore~/60;
    int hoursBefore = minutesBefore~/60;
    int daysBefore = hoursBefore~/24;
    int weeksBefore = daysBefore~/7;
    int monthsBefore = weeksBefore~/5;
    int yearsBefore = monthsBefore~/12;
    if(secondsBefore<10){
      time = 'a moment ago';
    }if(secondsBefore<60){
      time = 'few seconds ago';
    }else if(minutesBefore<60){
      time = '$minutesBefore minute${minutesBefore>1?"s":""} ago';
    }else if(hoursBefore<24){
      time = '$hoursBefore hour${hoursBefore>1?"s":""} ago';
    }else if(daysBefore<7){
      time = '$daysBefore day${daysBefore>1?"s":""} ago';
    }else if(weeksBefore<5){
      time = '$weeksBefore week${weeksBefore>1?"s":""} ago';
    }else if(monthsBefore<12){
      time = '$monthsBefore month${monthsBefore>1?"s":""} ago';
    }else {
      time = '$yearsBefore year${yearsBefore>1?"s":""} ago';
    }
    return time;
  }
}

class NotificationText extends StatelessWidget {
  final double? size;
  final String label;
  final FontWeight? fontWeight;
  final Color? color;
  const NotificationText({
    Key? key,  this.size, required this.label, this.fontWeight, this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7,top: 7,bottom: 7),
      child:
      Text(
        label,
        style: varelaRoundRegular.copyWith(
            fontSize: size ?? 15,
            color: color??Theme.of(context).primaryColorDark,
            fontWeight:fontWeight ?? FontWeight.w500
        ),
      ),
    );
  }


}
