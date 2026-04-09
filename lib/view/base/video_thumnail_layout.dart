import 'package:flutter/material.dart';
import 'package:jobreels/data/model/response/post.dart';
import 'package:jobreels/helper/helper.dart';
import 'package:jobreels/view/base/custom_image.dart';

class VideoGridSearch extends StatelessWidget {
  final Post post;

  const VideoGridSearch({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      width: (deviceWidth / 3).floorToDouble(),
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            getUserName(user: post.user!),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: CustomImage(
                image: post.thumbnail,
                isProfileImage: true,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}