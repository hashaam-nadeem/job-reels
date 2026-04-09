import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/controller/post_controller.dart';
import 'package:jobreels/data/model/response/user.dart';
import 'package:jobreels/util/images.dart';
import 'package:jobreels/view/base/custom_loader.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../data/model/response/post.dart';
import '../../base/custom_app_bar.dart';
import '../../base/video_item_widget.dart';
import '../main/main_screen.dart';

class HomeScreen extends StatefulWidget {
  final int? initialPage;
  List<Post> postListToRender;
  final String title;
  final bool showVisitProfileButton;
  HomeScreen(
      {super.key,
      this.initialPage,
      this.title = 'Home',
      List<Post>? postListToRender,
      this.showVisitProfileButton = true})
      : postListToRender = postListToRender ?? [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _pageController =
        PageController(initialPage: widget.initialPage ?? homePageCurrentIndex);
    initDynamicLinks();
    PostsController postsController = Get.find<PostsController>();
    if (postsController.totalPosts == 0 &&
        !postsController.isApiCalledAtLeastOneTime) {
      postsController.getPosts().then((value) {
        print("my value of sharing: ${value}");
        if (!postsController.isDeepLinkingInitialized) {
          postsController.isDeepLinkingInitialized = true;
          initDynamicLinks();
        }
      });
    } else {
      if (!postsController.isDeepLinkingInitialized) {
        postsController.isDeepLinkingInitialized = true;
        initDynamicLinks();
      }
    }

    super.initState();
    getUserProfile();
  }

  var userId;
  getUserProfile() {
    User? user = Get.find<AuthController>().getLoginUserData();
    if (user != null) {
      setState(() {
        userId = user.id.toString();
        print("my user id is: #${userId}");
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.title == 'Home' && homePageCurrentIndex > 0) {
          homePageCurrentIndex = 0;
          _pageController.jumpToPage(homePageCurrentIndex);
          return false;
        } else {
          return true;
        }
      },
      child: Material(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: GetBuilder<PostsController>(
              builder: (PostsController postsController) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  color: Theme.of(context).primaryColorDark,
                  child: SmartRefresher(
                    controller: _refreshController,
                    header: const MaterialClassicHeader(
                      distance: 90,
                    ),
                    scrollController: ScrollController(),
                    enablePullDown: !postsController.isDataFetching,
                    onRefresh: () async {
                      await postsController.getPosts();
                      if (widget.title == 'Home') {
                        homePageCurrentIndex = 0;
                      }
                      _refreshController.refreshCompleted();
                    },
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.postListToRender.isNotEmpty
                          ? widget.postListToRender.length
                          : postsController.isDataFetching
                              ? 1
                              : postsController.totalPosts,
                      scrollDirection: Axis.vertical,
                      onPageChanged: (int page) {
                        if (widget.title == 'Home') {
                          homePageCurrentIndex = page;
                        }
                      },
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height -
                              MediaQuery.of(context).padding.top -
                              kToolbarHeight -
                              kBottomNavigationBarHeight,
                          child: Center(
                              child: postsController.isDataFetching
                                  ? const CustomLoader()
                                  : VideoItem(
                                      post: widget.postListToRender.isNotEmpty
                                          ? widget.postListToRender[index]
                                          : postsController.postList[index],
                                      isFirstVideo: index == 0,
                                      myuserId: userId,
                                      pageController: _pageController,
                                      showVisitProfileButton:
                                          widget.showVisitProfileButton)),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  child: SizedBox(
                    width: context.width,
                    child: CustomAppBar(
                      title: widget.title,
                      tileColor: Colors.transparent,
                      titleColor: Theme.of(context).primaryColorLight,
                      showLeading: widget.postListToRender.isNotEmpty,
                      leading: widget.postListToRender.isEmpty
                          ? const SizedBox()
                          : null,
                      trailing: [
                        !postsController.isDataFetching &&
                                widget.postListToRender.isEmpty
                            ? IconButton(
                                onPressed: () {
                                  _pageController.jumpToPage(0);
                                  _refreshController.requestRefresh();
                                },
                                icon: Image.asset(
                                  Images.reload,
                                  color: Theme.of(context).primaryColorLight,
                                  height: 30,
                                  width: 30,
                                ))
                            : const SizedBox(
                                width: 48,
                              ),
                      ],
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

  void initDynamicLinks() {
    debugPrint("initDynamicLinks.isDeepLinkingInitialized:->> ");
    Future.delayed(
        Duration(
          seconds: 4,
        ), () {
      FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
      dynamicLinks
          .getInitialLink()
          .then((PendingDynamicLinkData? pendingDynamicLinkData) {
        debugPrint(
            "pendingDynamicLinkData:->> ${pendingDynamicLinkData?.asMap()}");
        if (pendingDynamicLinkData != null) {
          Future.delayed(const Duration(seconds: 2)).then((value) {
            int index = Get.find<PostsController>().postList.indexWhere(
                (post) =>
                    "${post.id}" ==
                    pendingDynamicLinkData.link.queryParameters['id']);

            homePageCurrentIndex = index;
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              _pageController.jumpToPage(index);
            });
          });
        }
      });
      dynamicLinks.onLink.listen((dynamicLinkData) {
        int index = Get.find<PostsController>().postList.indexWhere((post) =>
            "${post.id}" == dynamicLinkData.link.queryParameters['id']);

        Future.delayed(const Duration(seconds: 4)).then((value) {
          homePageCurrentIndex = index;
          _pageController.jumpToPage(index);
        });
      }).onError((error) {
        debugPrint('onLink error');
        debugPrint(error.message);
      });
    });
  }
}
