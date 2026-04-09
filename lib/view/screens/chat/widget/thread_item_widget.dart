import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:jobreels/controller/post_controller.dart';
import 'package:jobreels/data/model/response/notification_model.dart';
import 'package:intl/intl.dart';
import 'package:jobreels/data/model/response/post.dart';
import 'package:jobreels/helper/route_helper.dart';
import 'package:jobreels/view/screens/home/home_screen.dart';
import 'package:jobreels/view/screens/main/main_screen.dart';
import '../../../../util/styles.dart';

class NotificationControllerItemWidget extends StatefulWidget {
  final NotificationModel notification;
  const NotificationControllerItemWidget({Key? key, required this.notification}) : super(key: key);
  @override
  State<NotificationControllerItemWidget> createState() => _NotificationControllerItemWidgetState();
}

class _NotificationControllerItemWidgetState extends State<NotificationControllerItemWidget> {
  var now =  DateTime.now();
  var formatter =  DateFormat.yMMMMd('en_US').add_jm();
  @override
  Widget build(BuildContext context) {
    NotificationModel notification = widget.notification;
    return GestureDetector(
        onTap: (){
          int initialPage = 0;
          if(notification.type!="Approval"){
            List<Post> postList = Get.find<PostsController>().postList;
            if(postList.isNotEmpty){
              initialPage = postList.indexWhere((post) => post.id == notification.postId);
            }
          }
          homePageCurrentIndex = initialPage;
          Get.offAllNamed(RouteHelper.getMainScreenRoute(homeInitialPage: initialPage));
        },
        child:Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          width: context.width,
          padding: const EdgeInsets.only(right: 5,top: 12,),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFF067306),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Ionicons.notifications_outline,
                  size: 14,
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
              const SizedBox(width: 10,),
              Flexible(
                child: Text(
                  notification.notification,
                  style: montserratSemiBold.copyWith(
                    fontSize: 15,
                  ),
                )
              ),
            ],
          ),
        ),
    );
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
