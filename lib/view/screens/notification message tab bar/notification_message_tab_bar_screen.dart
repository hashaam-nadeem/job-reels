import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/util/app_strings.dart';
import 'package:jobreels/util/styles.dart';
import 'package:jobreels/view/screens/chat/chat_screen.dart';
import 'package:jobreels/view/screens/chat/chat_thread_list_screen.dart';
import 'package:jobreels/view/screens/notification/widget/notification_item_widget.dart';

import '../../../controller/notification_chat_controller.dart';
import '../notification/notification_screen.dart';

class ChatNotificationTabBarScreen extends StatefulWidget {
  const ChatNotificationTabBarScreen({Key? key}) : super(key: key);

  @override
  State<ChatNotificationTabBarScreen> createState() => _ChatNotificationTabBarScreenState();
}

class _ChatNotificationTabBarScreenState extends State<ChatNotificationTabBarScreen> with SingleTickerProviderStateMixin{
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: context.width,
          child: GetBuilder(
            builder: (ChatNotificationController chatNotificationController) {
              return Column(
                children: [
                  /// Tabs
                  SizedBox(
                    height: 50,
                    width: context.width,
                    child: Material(
                      elevation: 5,
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        padding: const EdgeInsets.all(0),
                        indicatorColor: Theme.of(context).primaryColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: [
                          SizedBox(
                            width: context.width * 0.41,
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppString.messages,
                                    style: montserratBold.copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  chatNotificationController.messageCount==0?const SizedBox(): Badge.count(count: chatNotificationController.messageCount)
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: context.width * 0.41,
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppString.notifications,
                                    style: montserratBold.copyWith(
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  chatNotificationController.notificationCount==0?const SizedBox(): Badge.count(count: chatNotificationController.notificationCount)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: const [
                        ThreadListScreen(showAppBar: false,),
                        NotificationScreen(),
                      ],
                    ),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
