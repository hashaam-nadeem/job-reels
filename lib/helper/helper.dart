import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:jobreels/controller/auth_controller.dart';
import 'package:jobreels/data/model/response/user.dart';
import 'package:jobreels/helper/route_helper.dart';
import 'package:jobreels/view/base/custom_snackbar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../data/model/helpers.dart';
import '../data/model/response/post.dart';
import '../util/app_constants.dart';
import 'package:share_plus/share_plus.dart';

import '../view/base/popup_alert.dart';

late Directory appDirectory;
DateFormat dateFormat = DateFormat('dd MMMM yyyy');
DateFormat chatDateFormat = DateFormat.yMMMMd();
DateFormat threadDateFormat = DateFormat('d MMMM');
DateFormat chatTimeFormat = DateFormat.jm();

Future<DateTime?> selectDateOfBirth(
    BuildContext context, DateTime? initialDate) async {
  DateTime initialTime = initialDate ?? DateTime.now();
  final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialTime,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 150)),
      lastDate: DateTime.now());
  return picked;
}

Future<File?> getDownloadedFile(
    {required String imageUrl, String? baseUrl}) async {
  String directoryPath = "${appDirectory.path}/cached_image";
  await Directory(directoryPath).create(recursive: true);
  final String filePath = '$directoryPath/${imageUrl.split('/').last}';
  File? imageFile;
  File file = File(filePath);
  if (file.existsSync()) {
    imageFile = file;
  } else {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        imageFile = await cacheManager.putFile(
          imageUrl,
          response.bodyBytes,
          fileExtension: imageUrl.split(".").last,
        );
        await file.writeAsBytes(response.bodyBytes);
      } else {
        debugPrint('Failed to download image:-> $imageUrl}');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
  return imageFile;
}

bool validateEmail(String email) {
  const pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
  final regex = RegExp(pattern);
  return regex.hasMatch(email);
}

bool validatePhoneNumber(String phone) {
  return phone.isNotEmpty && phone.length < 10;
}

RegExp maximumLengthFormatter(int maxLength) {
  return RegExp('^.{1,$maxLength}');
}

bool passwordCombinationValidator(String password) {
  RegExp passwordRegex = RegExp(r'[!@#$%/\₹€≈π¥₱£¢^&=*(),_.?":{}|<>]');
  //  RegExp(
  //   r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$+_!%*#?&{:;=~`/"}()<>|^-])[A-Za-z\d@$+_!%*#?&{:;=~`/"}()<>|^-₺]{8,}$',
  // );
  return passwordRegex.hasMatch(password.toUpperCase());
}

Future sharePostLinkToExternalApp(
    {required String text, required BuildContext context}) async {
  final box = context.findRenderObject() as RenderBox?;
  await Share.share(
    text,
    sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
  );
}

Future<String?> getFirebaseDynamicLink(Post post) async {
  try {
    final DynamicLinkParameters dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse("https://www.jobreels.app?id=${post.id!}"),
      uriPrefix: "https://jobreels.page.link",
      androidParameters: const AndroidParameters(
        packageName: "com.job.jobreels",
      ),
      iosParameters: const IOSParameters(
          bundleId: "com.job.jobreels",
          minimumVersion: "1",
          appStoreId: "6451405137"),
      navigationInfoParameters: const NavigationInfoParameters(
        forcedRedirectEnabled: true,
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: "JobReels App",
        description: post.title,
      ),
      longDynamicLink: Uri.parse("https://www.jobreels.app?id=${post.id!}"),
    );
    final Uri shortLink =
        await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParams);
    Uri url = shortLink;
    String deepLink = url.resolveUri(shortLink).toString();
    return deepLink;
  } catch (e) {
    debugPrint("Exception on creating dynamic links:-> $e");
    return null;
  }
}

Future<void> openUrlInExternalApp(String url) async {
  Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    showCustomSnackBar("Unable to open url");
  }
}

bool validateUrlText(String str) => (str.indexOf("http://") == 0 ||
    str.indexOf("https://") == 0 ||
    str.indexOf("www.") == 0);

String decryptDataAndGetOtp({required num verify, required num time}) {
  return ((verify - time) / time).toStringAsFixed(0);
}

PopupObject getPopupObject({bool hideCancelButton = false}) {
  return PopupObject(
    title: 'Subscribe',
    body: 'You must subscribe to view premium data (free for now)',
    buttonText: "Subscribe",
    hideTopRightCancelButton: hideCancelButton,
    onYesPressed: () {},
  );
}

showSubscriptionBuyMessage() {
  showPopUpAlert(
    popupObject: PopupObject(
      title: 'Subscribe',
      body: 'You must subscribe to view premium data (free for now)',
      buttonText: "Subscribe",
      onYesPressed: () {
        Get.back();
        demoTestingSubscription();
      },
    ),
  );
}

void demoTestingSubscription() async {
  AuthController authController = Get.find<AuthController>();
  authController.subscribeUser();
  await showPopUpAlert(
    popupObject: PopupObject(
      title: 'Subscribe',
      body: 'Subscribed successfully',
      hideTopRightCancelButton: true,
      buttonText: "Continue",
      onYesPressed: () {
        Get.back();
        // Get.offAllNamed(RouteHelper.getMainScreenRoute());
      },
    ),
    barrierDismissible: false,
  );
}

showLoginMessagePopup() {
  showPopUpAlert(
    popupObject: PopupObject(
      title: 'Login Required',
      body: 'Login to view this data.',
      buttonText: "Login Now",
      onYesPressed: () {
        Get.back();
        Get.toNamed(RouteHelper.getSignInRoute());
      },
    ),
  );
}

String generateMessageNumber(
    {required int loggedInUserId, required int toUserId}) {
  return "$loggedInUserId$toUserId${DateTime.now().microsecond}${DateTime.now().millisecondsSinceEpoch}${DateTime.now().millisecond}";
}

String getUserName({required User user}) {
 
  return user.id == 165
      ? user.firstName
      : 
      user.lastName.toString().isEmpty || user.lastName==null?
      "${user.firstName}"
      :
      "${user.firstName} ${user.lastName.substring(0, 1).toUpperCase()}";
}
