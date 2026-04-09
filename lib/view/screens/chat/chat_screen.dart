import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:get/get.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/controller/notification_chat_controller.dart';
import 'package:jobreels/controller/post_controller.dart';
import 'package:jobreels/data/model/response/chat_thread_model.dart';
import 'package:jobreels/helper/helper.dart';
import 'package:jobreels/helper/socket_helper.dart';
import 'package:jobreels/main.dart';
import 'package:jobreels/util/dimensions.dart';
import 'package:jobreels/util/styles.dart';
import 'package:jobreels/view/base/custom_app_bar.dart';
import 'package:jobreels/view/base/custom_loader.dart';
import 'package:jobreels/view/base/custom_snackbar.dart';
import 'package:jobreels/view/base/custom_toast.dart';
import 'package:jobreels/view/base/my_text_field.dart';
import 'package:jobreels/view/base/popup_alert.dart';
import '../../../data/model/response/chat_model.dart';
import '../../../data/model/response/user.dart';
import '../profile/ProfileScreen.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final int userId;
  final int threadId;
  final bool isCallApiOnInitState;
  const ChatScreen(
      {Key? key,
      required this.userId,
      this.isCallApiOnInitState = true,
      required this.threadId,
      required this.userName})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _chatTextController = TextEditingController();
  double borderRadius = 15;

  @override
  void initState() {
    PostsController postsController = Get.find<PostsController>();
    // if(postsController.totalPosts == 0 && !postsController.isApiCalledAtLeastOneTime){
    postsController.getPosts().then((value) {
      print("my value of sharing: ${value}");
    });
    ChatNotificationController chatController =
        Get.find<ChatNotificationController>();
    chatController.currentOpenedThread = ChatThread(
        id: widget.threadId,
        unreadCount: 0,
        userId: widget.userId,
        userName: widget.userName,
        userProfileUrl: "");
    if (widget.isCallApiOnInitState) {
      chatController.fetchThreadMessages(widget.threadId).then((value) {
        chatController.currentOpenedThread?.lastMessage =
            chatController.chatMessageList.isNotEmpty
                ? chatController.chatMessageList.last
                : null;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        title: widget.userName,
        onTap: (Get.find<AuthController>().getLoginUserData()?.isFreelancer ??
                true)
            ? null
            : () {
                Get.to(() => ProfileScreen(
                      userId: widget.userId,
                      isMyProfile: false,
                      user: Get.find<AuthController>().getLoginUserData(),
                      showAppbarLeading: true,
                    ));
              },
        leading: null,
        showLeading: true,
        titleColor: Theme.of(context).primaryColorLight,
        tileColor: Theme.of(context).primaryColor,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: GetBuilder<AuthController>(builder: (authController) {
          return GetBuilder<ChatNotificationController>(
              builder: (chatController) {
            chatController.scrollController ??= ScrollController();
            User? loginUser = authController.getLoginUserData();
            return SafeArea(
              bottom: true,
              child: SizedBox(
                height: context.height,
                child: chatController.isThreadMessageFetchingData
                    ? const Center(
                        child: CustomLoader(),
                      )
                    // : loginUser == null ? const SizedBox()
                    // : (!loginUser.isFreelancer && !loginUser.isSubscribed)
                    // ? PopupAlert(popupObject: getPopupObject(hideCancelButton: true),)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: ListView.builder(
                              controller: chatController.scrollController,
                              reverse: true,
                              itemCount: chatController.chatMessageList.length,
                              itemBuilder: (listContext, listIndex) {
                                int index =
                                    chatController.chatMessageList.length -
                                        1 -
                                        listIndex;
                                final message =
                                    chatController.chatMessageList[index];
                                print("my read status is: ${message.isRead}");
                                final previousMessage = index > 0
                                    ? chatController.chatMessageList[index - 1]
                                    : null;
                                final showDateSeparation =
                                    previousMessage == null ||
                                        message.dateTime
                                                .difference(
                                                    previousMessage.dateTime)
                                                .inDays !=
                                            0;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (showDateSeparation)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL,
                                            ),
                                            child: Text(
                                              chatDateFormat.format(message
                                                  .dateTime), // Format the date as needed
                                              style:
                                                  montserratSemiBold.copyWith(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    Container(
                                        alignment: message.isMyMessage
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          margin: const EdgeInsets.only(
                                            bottom:
                                                Dimensions.PADDING_SIZE_SMALL,
                                          ),
                                          decoration: BoxDecoration(
                                            color: message.isMyMessage
                                                ? Theme.of(context).primaryColor
                                                : Colors.grey.shade200,
                                            borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(borderRadius),
                                              topRight:
                                                  Radius.circular(borderRadius),
                                              bottomRight: Radius.circular(
                                                  message.isMyMessage
                                                      ? 0
                                                      : borderRadius),
                                              bottomLeft: Radius.circular(
                                                  message.isMyMessage
                                                      ? borderRadius
                                                      : 0),
                                            ),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                message.isMyMessage
                                                    ? CrossAxisAlignment.end
                                                    : CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                message.message,
                                                style:
                                                    montserratSemiBold.copyWith(
                                                  color: message.isMyMessage
                                                      ? Theme.of(context)
                                                          .primaryColorLight
                                                      : Theme.of(context)
                                                          .primaryColorDark,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL,
                                              ),
                                              Text(
                                                chatTimeFormat
                                                    .format(message.dateTime),
                                                style:
                                                    montserratRegular.copyWith(
                                                  color: message.isMyMessage
                                                      ? Theme.of(context)
                                                          .primaryColorLight
                                                      : Colors.grey.shade500,
                                                  fontSize: 11,
                                                ),
                                              ),
                                              message.isMyMessage
                                                  ? Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 3),
                                                      child: Text(
                                                        int.parse(message.isRead
                                                                        .toString()) ==
                                                                    "0" ||
                                                                message.isRead
                                                                        .toString() ==
                                                                    "0"
                                                            ? "delivered"
                                                            : "read",
                                                        style: montserratRegular
                                                            .copyWith(
                                                          color: int.parse(message
                                                                          .isRead
                                                                          .toString()) ==
                                                                      "0" ||
                                                                  message.isRead
                                                                          .toString() ==
                                                                      "0"
                                                              ? Colors.red
                                                              : Colors.green,
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 0, width: 0),
                                            ],
                                          ),
                                        )),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                          ),
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Theme.of(context).primaryColor,
                          ),
                          CustomInputTextField(
                            controller: _chatTextController,
                            focusNode: null,
                            isNoBorderDecoration: true,
                            context: context,
                            hintText: 'Write message here',
                            suffixIcon: InkWell(
                              onTap: () {
                                if (_chatTextController.text
                                    .trim()
                                    .isNotEmpty) {
                                  _sendTextMessage(chatController);
                                }
                              },
                              borderRadius: BorderRadius.circular(50),
                              radius: 50,
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    shape: BoxShape.circle),
                                margin:
                                    const EdgeInsets.only(left: 3, right: 10),
                                alignment: Alignment.center,
                                child: Icon(
                                  Ionicons.md_arrow_forward,
                                  color: Theme.of(context).primaryColorLight,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            );
          });
        }),
      ),
    );
  }

  _sendTextMessage(ChatNotificationController chatController) {
    SendMessageFormat msg = SendMessageFormat(
      type: "Text",
      message: _chatTextController.text.trim(),
      threadId: widget.threadId,
      toUserId: widget.userId,
      messageNumber: generateMessageNumber(
          loggedInUserId: Get.find<AuthController>().getLoginUserData()!.id!,
          toUserId: widget.userId),
    );
    ChatMessage chatMessage = ChatMessage(
        message: msg.message,
        isRead: 0,
        dateTime: DateTime.now(),
        isMyMessage: true,
        threadId: widget.threadId);
    _chatTextController.clear();
    chatController.chatMessageList.add(chatMessage);
    setState(() {});
    jobReelSocket
        .sendMessageToUser(
            msg: msg,
            onEmitAck: (ack) {
              debugPrint("MessageTime:-> $ack");
              if (ack['status']) {
                chatController.updateLastMessage(chatMessage: chatMessage);
                chatController.scrollController?.animateTo(0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.linear);
              } else {
                showCustomSnackBar("Failed to send message");
                chatController.chatMessageList.remove(chatMessage);
                setState(() {});
              }
            })
        .then((isSocketConnected) {
      if (!isSocketConnected) {
        showCustomToast("Failed to send message", isErrorToast: true);
        chatController.chatMessageList.remove(chatMessage);
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    ChatNotificationController chatController =
        Get.find<ChatNotificationController>();
    chatController.chatMessageList.clear();
    chatController.currentOpenedThread = null;
    chatController.scrollController = null;
    _chatTextController.dispose();
    super.dispose();
  }
}
