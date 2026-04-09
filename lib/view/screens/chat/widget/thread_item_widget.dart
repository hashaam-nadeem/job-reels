import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:jobreels/controller/post_controller.dart';
import 'package:jobreels/data/model/response/chat_thread_model.dart';
import 'package:jobreels/data/model/response/notification_model.dart';
import 'package:intl/intl.dart';
import 'package:jobreels/data/model/response/post.dart';
import 'package:jobreels/helper/helper.dart';
import 'package:jobreels/helper/route_helper.dart';
import 'package:jobreels/util/dimensions.dart';
import 'package:jobreels/view/base/custom_image.dart';
import 'package:jobreels/view/screens/chat/chat_screen.dart';
import 'package:jobreels/view/screens/home/home_screen.dart';
import 'package:jobreels/view/screens/main/main_screen.dart';
import '../../../../util/styles.dart';

class ThreadItemWidget extends StatefulWidget {
  final ChatThread thread;
  const ThreadItemWidget({Key? key, required this.thread}) : super(key: key);
  @override
  State<ThreadItemWidget> createState() => _ThreadItemWidgetState();
}

class _ThreadItemWidgetState extends State<ThreadItemWidget> {
  bool block = false;
  @override
  Widget build(BuildContext context) {
    ChatThread thread = widget.thread;
    // print("profile url: ${thread.userProfileUrl}");
    DateTime currentDate = DateTime.now();
    bool isSameDate =
        currentDate.day == (thread.lastMessage?.dateTime.day ?? false);
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(() => ChatScreen(
                  userId: thread.userId,
                  threadId: thread.id,
                  userName: thread.userName,
                ));
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.only(
              left: Dimensions.PADDING_SIZE_SMALL,
              right: Dimensions.PADDING_SIZE_SMALL,
              bottom: Dimensions.PADDING_SIZE_SMALL,
            ),
            width: context.width,
            // padding: const EdgeInsets.only(right: 5,top: 12,),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      height: 45,
                      width: 45,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CustomImage(
                            image: thread.userProfileUrl,
                            isProfileImage: true,
                            height: 45,
                            width: 45,
                          )),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: thread.unreadCount.toString() == "0" ? 0 : 12),
                      height: 8,
                      width: 8,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: thread.unreadCount.toString() == "0"
                              ? Colors.transparent
                              : Colors.red),
                    )
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          thread.userName,
                          style: montserratMedium.copyWith(
                              fontSize: 16,
                              fontWeight: thread.unreadCount.toString() == "0"
                                  ? FontWeight.normal
                                  : FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          thread.lastMessage?.message ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: montserratRegular.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                )),
                const SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Text(
                      isSameDate
                          ? chatTimeFormat.format(thread.lastMessage!.dateTime)
                          : threadDateFormat
                              .format(thread.lastMessage!.dateTime),
                      style: montserratRegular.copyWith(
                        fontSize: 14,
                      ),
                    ),
                    thread.unreadCount.toString() == "0"
                        ? Container(
                            width: 0,
                            height: 0,
                          )
                        : Text(
                            " (${thread.unreadCount.toString()} )",
                            style: montserratMedium.copyWith(
                                fontSize: 14, color: Colors.red),
                          ),
                    Row(
                      children: [
                        block == true
                            ? CircularProgressIndicator()
                            : PopupMenuButton(
                                onSelected: (value) {
                                  print("selected popup: $value");
                                  setState(() {
                                    block = true;
                                  });
                                  Future.delayed(Duration(seconds: 1), () {
                                    setState(() {
                                      block = false;
                                    });
                                  });
                                  // your logic
                                },
                                itemBuilder: (BuildContext bc) {
                                  return const [
                                    PopupMenuItem(
                                      child: Text("Block"),
                                      value: 'Block',
                                    ),
                                    PopupMenuItem(
                                      child: Text("un Block"),
                                      value: 'un Block',
                                    )
                                  ];
                                },
                              )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  String getProductTime(String notificationTime) {
    String time = '';
    DateTime currentDateTime = DateTime.now();
    int currentMilliSecondsSinceEpoch = currentDateTime.millisecondsSinceEpoch;
    DateTime postTime = DateTime.parse(notificationTime).toLocal();
    int postMilliSecondsSinceEpoch = postTime.millisecondsSinceEpoch;
    double secondsBefore =
        ((currentMilliSecondsSinceEpoch - postMilliSecondsSinceEpoch) / 1000);
    int minutesBefore = secondsBefore ~/ 60;
    int hoursBefore = minutesBefore ~/ 60;
    int daysBefore = hoursBefore ~/ 24;
    int weeksBefore = daysBefore ~/ 7;
    int monthsBefore = weeksBefore ~/ 5;
    int yearsBefore = monthsBefore ~/ 12;
    if (secondsBefore < 10) {
      time = 'a moment ago';
    }
    if (secondsBefore < 60) {
      time = 'few seconds ago';
    } else if (minutesBefore < 60) {
      time = '$minutesBefore minute${minutesBefore > 1 ? "s" : ""} ago';
    } else if (hoursBefore < 24) {
      time = '$hoursBefore hour${hoursBefore > 1 ? "s" : ""} ago';
    } else if (daysBefore < 7) {
      time = '$daysBefore day${daysBefore > 1 ? "s" : ""} ago';
    } else if (weeksBefore < 5) {
      time = '$weeksBefore week${weeksBefore > 1 ? "s" : ""} ago';
    } else if (monthsBefore < 12) {
      time = '$monthsBefore month${monthsBefore > 1 ? "s" : ""} ago';
    } else {
      time = '$yearsBefore year${yearsBefore > 1 ? "s" : ""} ago';
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
    Key? key,
    this.size,
    required this.label,
    this.fontWeight,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 7, top: 7, bottom: 7),
      child: Text(
        label,
        style: varelaRoundRegular.copyWith(
            fontSize: size ?? 15,
            color: color ?? Theme.of(context).primaryColorDark,
            fontWeight: fontWeight ?? FontWeight.w500),
      ),
    );
  }
}
