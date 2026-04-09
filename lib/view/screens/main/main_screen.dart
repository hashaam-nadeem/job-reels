import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/controller/notification_chat_controller.dart';
import 'package:jobreels/helper/helper.dart';
import 'package:jobreels/helper/route_helper.dart';
import 'package:jobreels/view/screens/chat/chat_screen.dart';
import 'package:jobreels/view/screens/chat/chat_thread_list_screen.dart';
import 'package:jobreels/view/screens/main/selection.dart';
import 'package:jobreels/view/screens/notification%20message%20tab%20bar/notification_message_tab_bar_screen.dart';
import 'package:jobreels/view/screens/profile/ProfileScreen.dart';
import 'package:jobreels/view/screens/search/search.dart';
import '../../../data/model/helpers.dart';
import '../../../data/model/response/user.dart';
import '../../../helper/notification_helper.dart';
import '../../../main.dart';
import '../../base/custom_bottom_navigation_bar.dart';
import '../../base/popup_alert.dart';
import '../VideoCreater/record_video.dart';
import '../home/home_screen.dart';

int homePageCurrentIndex = 0;

class MainScreen extends StatefulWidget {
  final int bottomNavBarIndex;
  const MainScreen({Key? key, required this.bottomNavBarIndex})
      : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  List<Widget> screensWidgets = <Widget>[];
  late PageController _pageViewController;
  int currentPage = 0;

  @override
  void initState() {
    NotificationHelper.initializeFirebaseConfiguration();
    currentPage = widget.bottomNavBarIndex;
    _pageViewController =
        PageController(initialPage: currentPage, keepPage: true);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF7a0fc1),
      ),
    );

    screensWidgets.addAll([
      HomeScreen(),
      const SearchScreen(),
    ]);

    User? user = Get.find<AuthController>().getLoginUserData();

    /// Call Socket Configurations
    if (user != null) {
      jobReelSocket.socketsConfiguration();
    }
    if (user?.isFreelancer ?? true) {
      screensWidgets.add(
        const RecordVideo(),
      );
      screensWidgets.add(
        const ChatNotificationTabBarScreen(),
      );
    } else if (Get.find<AuthController>().getLoginUserData()!.type.toString() ==
        "admin") {
      screensWidgets.add(VideoSelection()
          // const RecordVideo(),
          );
      screensWidgets.add(
        const ChatNotificationTabBarScreen(),
      );
    } else {
      screensWidgets.add(const ThreadListScreen());
    }
    screensWidgets.add(
      ProfileScreen(
        isMyProfile: true,
        user: user,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        if (currentPage > 0) {
          currentPage = 0;
          _pageViewController.jumpToPage(currentPage);
          setState(() {});
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: PageView(
                key: const Key("PageView"),
                controller: _pageViewController,
                physics: const NeverScrollableScrollPhysics(),
                children:
                    // screensWidgets
                    screensWidgets,
              ),
            ),
            // Container(
            //   height: 0.5,
            //   width: double.infinity,
            //   color: Theme.of(context).primaryColorLight,
            // ),
          ],
        ),
        bottomNavigationBar: GetBuilder<ChatNotificationController>(
            builder: (ChatNotificationController chatNotificationController) {
          print(
              "my counter is: ${chatNotificationController.messageCount + chatNotificationController.notificationCount}");
          List<BottomNavigationBarItem> bottomNavItems = [
            bottomNavigationTab(
                icon: currentPage == 0 ? Icons.home : Icons.home_outlined,
                tooltip: 'Home',
                tabIndex: 0),
            bottomNavigationTab(
                icon: Icons.search, tooltip: 'Search', tabIndex: 1),
          ];

          if (Get.find<AuthController>().getLoginUserData()?.isFreelancer ??
              true) {
            bottomNavItems.add(
              bottomNavigationTab(
                  icon: currentPage == 2
                      ? Icons.add_circle
                      : Icons.add_circle_outline,
                  tooltip: 'Upload Video',
                  tabIndex: bottomNavItems.length),
            );
            bottomNavItems.add(
              bottomNavigationTab(
                  icon: currentPage == 3
                      ? Icons.notifications
                      : Icons.notifications_none_outlined,
                  tooltip: 'Notifications',
                  tabIndex: bottomNavItems.length,
                  count: (chatNotificationController.messageCount +
                      chatNotificationController.notificationCount),
                  isCount: (chatNotificationController.messageCount +
                          chatNotificationController.notificationCount) >
                      0),
            );
          } else if (Get.find<AuthController>()
                  .getLoginUserData()!
                  .type
                  .toString() ==
              "admin") {
            bottomNavItems.add(
              bottomNavigationTab(
                  icon: currentPage == 2
                      ? Icons.add_circle
                      : Icons.add_circle_outline,
                  tooltip: 'Upload Video',
                  tabIndex: bottomNavItems.length),
            );
            bottomNavItems.add(
              bottomNavigationTab(
                  icon: currentPage == 3
                      ? Icons.notifications
                      : Icons.notifications_none_outlined,
                  tooltip: 'Notifications',
                  tabIndex: bottomNavItems.length,
                  count: (chatNotificationController.messageCount +
                      chatNotificationController.notificationCount),
                  isCount: (chatNotificationController.messageCount +
                          chatNotificationController.notificationCount) >
                      0),
            );
          } else {
            bottomNavItems.add(
              bottomNavigationTab(
                  icon: currentPage == 2
                      ? Ionicons.chatbox_ellipses
                      : Ionicons.chatbox_ellipses_outline,
                  tooltip: 'Chat',
                  tabIndex: bottomNavItems.length,
                  count: chatNotificationController.messageCount,
                  isCount: chatNotificationController.messageCount > 0),
            );
          }
          bottomNavItems.add(bottomNavigationTab(
            icon: Icons.person_outline,
            tooltip: 'Profile',
            tabIndex: bottomNavItems.length,
          ));
          return CustomBottomNavigationBar(
            elevation: 0,
            backgroundColor: Theme.of(context).primaryColorDark,
            unselectedItemColor: Theme.of(context).primaryColorLight,
            selectedItemColor: Theme.of(context).secondaryHeaderColor,
            onTap: (index) {
              if (index == screensWidgets.length - 1) {
                if (Get.find<AuthController>().authRepo.isLoggedOut()) {
                  Get.toNamed(RouteHelper.signIn);
                } else {
                  setState(() {
                    currentPage = index;
                    _pageViewController.jumpToPage(currentPage);
                  });
                }
              } else if (index == screensWidgets.length - 2) {
                if (Get.find<AuthController>().authRepo.isLoggedOut()) {
                  Get.toNamed(RouteHelper.signIn);
                } else {
                  if (!Get.find<AuthController>()
                          .getLoginUserData()!
                          .isFreelancer &&
                      !Get.find<AuthController>().isLoginUserSubscribed) {
                    if (Get.find<AuthController>()
                            .getLoginUserData()!
                            .type
                            .toString() ==
                        "admin") {
                           setState(() {
                      currentPage = index;
                      _pageViewController.jumpToPage(currentPage);
                    });
                    } else {
                      showSubscriptionBuyMessage();
                    }

                    /// To Chat US user must subscribe to a plan first
                    ///
                    // showSubscriptionBuyMessage();
                  } else {
                    setState(() {
                      currentPage = index;
                      _pageViewController.jumpToPage(currentPage);
                    });
                  }
                }
              } else if ((Get.find<AuthController>()
                          .getLoginUserData()
                          ?.isFreelancer ??
                      true) &&
                  index == screensWidgets.length - 3) {
                if (Get.find<AuthController>().authRepo.isLoggedOut()) {
                  Get.toNamed(RouteHelper.signIn);
                } else {
                  setState(() {
                    currentPage = index;
                    _pageViewController.jumpToPage(currentPage);
                  });
                }
              } else {
                setState(() {
                  currentPage = index;
                  _pageViewController.jumpToPage(currentPage);
                });
              }
            },
            items: bottomNavItems,
          );
        }),
      ),
    );
  }

  BottomNavigationBarItem bottomNavigationTab(
      {bool isCount = false,
      int? count,
      required IconData icon,
      required String tooltip,
      required int tabIndex}) {
    return BottomNavigationBarItem(
      icon: Container(
        alignment: Alignment.center,
        child: isCount
            ? Badge.count(
                count: count ?? 0,
                child: Icon(
                  icon,
                  size: tabIndex == currentPage ? 30 : 25,
                  color: tabIndex == currentPage
                      ? Theme.of(context).secondaryHeaderColor
                      : Theme.of(context).primaryColorLight,
                ),
              )
            : Icon(
                icon,
                size: tabIndex == currentPage ? 30 : 25,
                color: tabIndex == currentPage
                    ? Theme.of(context).secondaryHeaderColor
                    : Theme.of(context).primaryColorLight,
              ),
      ),
      tooltip: tooltip,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
