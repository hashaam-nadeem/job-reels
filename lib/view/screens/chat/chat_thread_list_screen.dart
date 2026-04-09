import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/controller/post_controller.dart';
import 'package:jobreels/data/model/response/chat_thread_model.dart';
import 'package:jobreels/data/model/response/notification_model.dart';
import 'package:jobreels/view/screens/chat/widget/thread_item_widget.dart';
import 'package:jobreels/view/screens/notification/widget/notification_item_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/notification_chat_controller.dart';
import '../../../controller/theme_controller.dart';
import '../../../util/app_strings.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';

class ThreadListScreen extends StatefulWidget {
  final bool showAppBar;
  const ThreadListScreen({Key? key, this.showAppBar = true}) : super(key: key);
  @override
  State<ThreadListScreen> createState() => _ThreadListScreenState();
}

class _ThreadListScreenState extends State<ThreadListScreen> {
  late RefreshController _refreshController;

  @override
  void initState() {
    // Get.find<ChatNotificationController>().setNotiMessageCounter(msgCounter: 0,isInit: true);
    PostsController postsController = Get.find<PostsController>();
    // if(postsController.totalPosts == 0 && !postsController.isApiCalledAtLeastOneTime){
    postsController.getPosts().then((value) {
      print("my value of sharing: ${value}");
    });
    _refreshController = RefreshController(
        initialRefresh:
            Get.find<ChatNotificationController>().chatThreadList.isNotEmpty);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<ChatNotificationController>().fetchThreadList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: widget.showAppBar
          ? CustomAppBar(
              title: AppString.messages,
              leading: null,
              showLeading: false,
              titleColor: Theme.of(context).primaryColorLight,
              tileColor: Theme.of(context).primaryColor,
            )
          : null,
      body: SafeArea(
        child: Container(
          width: context.width,
          margin: EdgeInsets.zero,
          child: GetBuilder<ChatNotificationController>(
              builder: (notificationController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: true,
                    controller: _refreshController,
                    header: const MaterialClassicHeader(),
                    onRefresh: _onRefresh,
                    child: (notificationController.isThreadFetchingData &&
                            notificationController.chatThreadList.isEmpty)
                        ? ListView.builder(
                            itemCount: context.height ~/ 67,
                            padding: const EdgeInsets.only(top: 10),
                            itemBuilder: (
                              BuildContext listContext,
                              int index,
                            ) {
                              return notificationLoadingWidget();
                            })
                        : notificationController.chatThreadList.isEmpty
                            ? Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    AppString.noChatFound,
                                    textAlign: TextAlign.center,
                                    style:
                                        montserratMedium.copyWith(fontSize: 15),
                                  ),
                                ],
                              )
                            : ListView.builder(
                                itemCount: notificationController
                                    .chatThreadList.length,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  ChatThread thread = notificationController
                                      .chatThreadList[index];

                                  print("my unread count is: ${thread}");
                                  return thread.lastMessage == null
                                      ? Container(
                                          height: 0,
                                          width: 0,
                                        )
                                      : ThreadItemWidget(
                                          thread: thread,
                                        );
                                },
                              ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget notificationLoadingWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      height: 50,
      child: Shimmer.fromColors(
        period: const Duration(milliseconds: 1500),
        direction: ShimmerDirection.ltr,
        baseColor: Theme.of(context).primaryColorDark.withOpacity(0.3),
        highlightColor: Theme.of(context).primaryColorDark.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorDark.withOpacity(0.3),
          ),
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 15,
          ),
        ),
      ),
    );
  }

  void _onRefresh() async {
    await Get.find<ChatNotificationController>().fetchThreadList();
    PostsController postsController = Get.find<PostsController>();
    // if(postsController.totalPosts == 0 && !postsController.isApiCalledAtLeastOneTime){
    postsController.getPosts().then((value) {
      print("my value of sharing: ${value}");
    });
    _refreshController.refreshCompleted();
  }
}
