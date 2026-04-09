import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glow_solar/data/model/response/notification_model.dart';
import 'package:glow_solar/view/screens/notification/widget/notification_item_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import '../../../controller/notification_controller.dart';
import '../../../controller/theme_controller.dart';
import '../../../util/app_strings.dart';
import '../../../util/dimensions.dart';
import '../../../util/styles.dart';
import '../../base/custom_app_bar.dart';

class NotificationScreen extends StatefulWidget {
  final int isFromNotificationClick;
   int ?notificationClickId;
   NotificationScreen({Key? key, required this.isFromNotificationClick, required this.notificationClickId}) : super(key: key);
  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late RefreshController _refreshController;
  // bool isHighLightNotification = true;

  @override
  void initState() {
    Get.find<NotificationController>().notificationCount;
    _refreshController = RefreshController(initialRefresh: Get.find<NotificationController>().notificationList.isNotEmpty);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.find<NotificationController>().fetchNotification();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: AppString.notificationController, leading: null,showLeading: true,),
      body: SafeArea(
        child: Container(
          width : context.width,
          height: context.height,
          padding:  const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          margin: EdgeInsets.zero,
          child:GetBuilder<NotificationController>(builder: (notificationController){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SmartRefresher(
                    enablePullDown: true,
                    controller: _refreshController,
                    header: const MaterialClassicHeader(),
                    onRefresh: _onRefresh,
                    child:(notificationController.isDataFetching && notificationController.notificationList.isEmpty)
                        ? ListView(
                      children: [
                        notificationLoadingWidget(),
                        notificationLoadingWidget(),
                        notificationLoadingWidget(),
                        notificationLoadingWidget(),
                        notificationLoadingWidget(),
                        notificationLoadingWidget(),
                      ],
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
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        Notifications notification = notificationController.notificationList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: NotificationControllerItemWidget(
                            notificationsId: notification.id,
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
        borderRadius: BorderRadius.circular(11),
      ),
      height: 120,
      child: Shimmer.fromColors(
        period: const Duration(milliseconds: 1500),
        direction: ShimmerDirection.ltr,
        baseColor: Get.find<ThemeController>().darkTheme==0? Theme.of(context).backgroundColor :Colors.grey.shade300,
        highlightColor: Get.find<ThemeController>().darkTheme==0? Theme.of(context).scaffoldBackgroundColor : Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.circular(11),
          ),
          padding: const EdgeInsets.only(left: 20,right: 20,top: 15,),
        ),
      ),
    );
  }

  void _onRefresh() async{
    Get.find<NotificationController>().notificationCount;
    await Get.find<NotificationController>().fetchNotification();
    _refreshController.refreshCompleted();
  }

}
