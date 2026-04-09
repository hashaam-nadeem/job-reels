import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../helper/helper.dart';
import 'custom_loader.dart';

class ImageView extends StatelessWidget {
  final String imageUrl;
  final Future<File?> imgFuture;
  const ImageView({Key? key,required this.imageUrl,required this.imgFuture,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String imageCacheKey = "CustomCacheManager$imageUrl";
    return FutureBuilder<File?>(
      key: Key("FutureBuilder$imageCacheKey"),
      builder: (BuildContext buildContext,AsyncSnapshot snapshot){
        if(snapshot.hasData){
          return FileImageView(
            key: Key(imageCacheKey),
            imageUrl: imageUrl,
            fit: BoxFit.cover,
          );
        }else{
          return const Center(
            child: CustomLoader(),
          );
        }
      },
      future: imgFuture,
    );
  }
}

class FileImageView extends StatefulWidget {
  final BoxFit ?fit;
  final bool showLoader;
  final String imageUrl;
  const FileImageView({Key? key, required this.imageUrl, this.fit, this.showLoader = false}) : super(key: key);

  @override
  State<FileImageView> createState() => _FileImageViewState();
}

class _FileImageViewState extends State<FileImageView> with AutomaticKeepAliveClientMixin<FileImageView>{
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return CachedNetworkImage(
      key: widget.key,
      imageUrl: widget.imageUrl,
      filterQuality: FilterQuality.high,
      placeholder: (context, url) => SizedBox(
        child: Center(
          child: widget.showLoader? const CustomLoader():const SizedBox(),
        ),
      ),
      fit: widget.fit ?? BoxFit.cover,
      errorWidget: (context, url, error) => const SizedBox(
          child: Center(
              child: Icon(Icons.error),
          ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}