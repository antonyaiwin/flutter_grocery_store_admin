import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/core/constants/color_constants.dart';
import 'package:flutter_grocery_store_admin/utils/global_widgets/my_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({
    super.key,
    required this.imageFile,
    this.imageUrl,
    this.imageUrlList,
    this.initialIndex = 0,
  });
  const PhotoScreen.network({
    super.key,
    this.imageUrl,
    this.imageUrlList,
    this.initialIndex = 0,
  }) : imageFile = null;

  final File? imageFile;
  final String? imageUrl;
  final List<String?>? imageUrlList;
  final int initialIndex;

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  late PageController pageController;
  final BoxDecoration _boxDecoration = const BoxDecoration(
    color: ColorConstants.scaffoldBackgroundColor,
  );

  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialIndex);
    pageController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Photo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.imageUrlList != null
                ? PhotoViewGallery.builder(
                    backgroundDecoration: _boxDecoration,
                    pageController: pageController,
                    itemCount: widget.imageUrlList?.length ?? 0,
                    builder: (context, index) => PhotoViewGalleryPageOptions(
                      imageProvider:
                          NetworkImage(widget.imageUrlList?[index] ?? ''),
                      controller: PhotoViewController(),
                    ),
                  )
                : widget.imageFile != null
                    ? PhotoView(
                        backgroundDecoration: _boxDecoration,
                        imageProvider: FileImage(widget.imageFile!),
                      )
                    : PhotoView(
                        backgroundDecoration: _boxDecoration,
                        imageProvider: NetworkImage(widget.imageUrl!),
                      ),
          ),
          SizedBox(
            height: 75,
            child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(10),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => InkWell(
                      onTap: () => pageController.animateToPage(
                        index,
                        duration: Durations.extralong1,
                        curve: Curves.easeInOut,
                      ),
                      child: Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: pageController.page?.round() == index
                                  ? ColorConstants.primaryColor
                                  : ColorConstants.hintColor,
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignOutside,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: MyNetworkImage(
                              imageUrl: widget.imageUrlList?[index] ?? '')),
                    ),
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemCount: widget.imageUrlList?.length ?? 1),
          )
        ],
      ),
    );
  }
}
