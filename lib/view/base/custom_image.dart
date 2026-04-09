import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:jobreels/util/app_constants.dart';
import 'package:jobreels/view/base/custom_loader.dart';

import '../../util/images.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final bool isProfileImage;
  const CustomImage(
      {super.key,
      required this.image,
      required this.isProfileImage,
      this.height,
      this.width,
      this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    print("profileimage :${image}");
    return Image.network(
      "$image",
      height: height,
      width: width,
      fit: fit,
    );

    //     CachedNetworkImage(
    //   cacheManager: cacheManager,
    //   key: Key(image),
    //   imageUrl: image, height: height, width: width, fit: fit,
    //   placeholder: (context, url) => isProfileImage
    //       ? const SizedBox()
    //       : const Center(
    //           child: CustomLoader(),
    //         ),
    //   // errorWidget: (context, url, error) => Image.asset(Images.placeholder, height: height, width: width, fit: fit),
    // );
  }
}
