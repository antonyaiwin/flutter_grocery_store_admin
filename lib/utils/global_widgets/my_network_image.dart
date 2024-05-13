import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'custom_loading_indicator.dart';

class MyNetworkImage extends StatelessWidget {
  const MyNetworkImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit,
  });

  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height ?? 250,
      width: width,
      fit: fit,
      errorWidget: (context, url, error) => const Center(
        child: Icon(Icons.error),
      ),
      progressIndicatorBuilder: (context, url, progress) =>
          const CustomLoadingIndicator(),
    );
  }
}
