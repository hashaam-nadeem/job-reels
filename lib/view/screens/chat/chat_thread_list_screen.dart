import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/data/model/response/notification_model.dart';
import 'package:jobreels/view/screens/notification/widget/notification_item_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/notification_chat_controller.dart';
import '../../../controller/theme_controller.dart';
import '../../../util/app_strings.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';

class NotificationScreen extends StatefulWidget {
   const NotificationScreen({Key? key,}) : super(key: key);
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late RefreshController _refreshController;

  @override
  void initState() {
    Get.find<ChatNotificationController>().notificationCount;
    _refreshController = RefreshController(initialRefresh: Get.find<ChatNotificationController>().notificationList.isNotEmpty);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<ChatNotificationController>().fetchNotification();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Container(
          width : context.width,
          padding:  const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL, right: Dimensions.PADDING_SIZE_SMALL, bottom: Dimensions.PADDING_SIZE_SMALL, ),
          margin: EdgeInsets.zero,
          child:GetBuilder<ChatNotificationController>(builder: (notificationController){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: true,
                    controller: _refreshController,
                    header: const MaterialClassicHeader(),
                    onRefresh: _onRefresh,
                    child: (notificationController.isDataFetching && notificationController.notificationList.isEmpty)
                        ? ListView.builder(
                            itemCount: context.height~/67,
                            padding: const EdgeInsets.only(top: 10),
                            itemBuilder: (BuildContext listContext, int index,){
                              return notificationLoadingWidget();
                            }
                          )
                        : notificationController.notificationList.isEmpty
                        ? Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppString.noNotificationFound,
                          textAlign: TextAlign.center,
                          style: montserratMedium.copyWith(fontSize: 15),
                        ),
                      ],
                    )
                        : ListView.builder(
                            itemCount: notificationController.notificationList.length,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              NotificationModel notification = notificationController.notificationList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: NotificationControllerItemWidget(
                                  notification: notification,
                                ),
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

  Widget notificationLoadingWidget(){
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
          padding: const EdgeInsets.only(left: 20,right: 20,top: 15,),
        ),
      ),
    );
  }

  void _onRefresh() async{
    Get.find<ChatNotificationController>().notificationCount;
    await Get.find<ChatNotificationController>().fetchNotification();
    _refreshController.refreshCompleted();
  }

}
