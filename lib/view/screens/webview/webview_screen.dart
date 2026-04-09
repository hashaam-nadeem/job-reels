import 'dart:async';
import 'package:jobreels/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../util/app_strings.dart';
import '../../base/custom_loader.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  final String _url=AppString.privacyPolicyUrl;
  final _key = UniqueKey();
  bool isLoading=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const CustomAppBar(title: AppString.privacyPolicy, leading: null,showLeading: true,),
      body: SafeArea(
          child: Stack(
      children: [
      WebView(
      key: _key,
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: _url,
        onWebViewCreated: (WebViewController webViewController) async {
          _controller.complete(webViewController);
        },

        onPageStarted: (url){
          setState(() {
            isLoading = false;
          });
        },
      ),
      isLoading?CustomLoader():Stack(),
      ],
    )
          // Scrollbar(
          //   child: SingleChildScrollView(
          //     physics: const BouncingScrollPhysics(),
          //     child: Container(
          //       width: context.width > 700 ? 700 : context.width,
          //       padding: context.width > 700
          //           ? const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
          //           : const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          //       margin: context.width > 700
          //           ? const EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT)
          //           : EdgeInsets.zero,
          //       decoration: context.width > 700
          //           ? BoxDecoration(
          //         color: Theme.of(context).cardColor,
          //         borderRadius:
          //         BorderRadius.circular(Dimensions.RADIUS_SMALL),
          //         boxShadow: [
          //           BoxShadow(
          //             color: Get.isDarkMode ? Colors.grey.shade700: Colors.grey.shade300,
          //             blurRadius: 5,
          //             spreadRadius: 1,
          //           )
          //         ],
          //       )
          //           : null,
          //       child: GetBuilder<AuthController>(builder: (authController) {
          //         return Column(
          //             crossAxisAlignment: CrossAxisAlignment.center,
          //             children: [
          //               const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 children: [
          //                   Text(AppString.policies.tr,
          //                     style: montserratMedium.copyWith(fontSize: 18),
          //                   ),
          //                 ],
          //               ),
          //               const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          //
          //               Text(AppString.policiesText.tr,
          //                 style: montserratRegular.copyWith(fontSize: 14),
          //               ),
          //               const SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 children: [
          //                   Text(AppString.termsAndConditions.tr,
          //                     style: montserratMedium.copyWith(fontSize: 18),
          //                   ),
          //                 ],
          //               ),
          //               const SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
          //
          //               Text(AppString.termsAndConditionsText.tr,
          //                 style: montserratRegular.copyWith(fontSize: 14),
          //               ),
          //
          //             ]);
          //       }),
          //     ),
          //   ),
          // )
      ),
    );
  }
}
