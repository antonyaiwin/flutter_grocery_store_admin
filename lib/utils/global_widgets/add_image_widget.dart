import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/utils/global_widgets/my_network_image.dart';

import '../../core/constants/color_constants.dart';

class AddImageWidget extends StatelessWidget {
  const AddImageWidget({
    super.key,
    this.imageFile,
    this.onTap,
    this.onCameraPressed,
    this.onImagePressed,
    this.onDeletePressed,
    this.borderRadius,
    this.imageUrl,
  });
  const AddImageWidget.network(
    this.imageUrl, {
    super.key,
    this.onTap,
    this.onCameraPressed,
    this.onImagePressed,
    this.onDeletePressed,
    this.borderRadius,
  }) : imageFile = null;

  final File? imageFile;
  final void Function()? onTap;
  final void Function()? onCameraPressed;
  final void Function()? onImagePressed;
  final void Function()? onDeletePressed;
  final BorderRadius? borderRadius;
  final String? imageUrl;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      child: Container(
          clipBehavior: Clip.antiAlias,
          height: 100,
          width: imageFile != null || imageUrl != null ? null : 100,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            // image: imagePath != null
            //     ? DecorationImage(image: FileImage(File(imagePath!)))
            //     : null,
            border: imageFile != null || imageUrl != null
                ? null
                : Border.all(
                    color: ColorConstants.hintColor,
                    width: 2,
                  ),
          ),
          child: imageFile == null && imageUrl == null
              ? Column(
                  children: [
                    IconButton(
                      onPressed: onImagePressed,
                      icon: const Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 25,
                      ),
                    ),
                    IconButton(
                      onPressed: onCameraPressed,
                      icon: const Icon(
                        Icons.add_a_photo_outlined,
                        size: 25,
                      ),
                    ),
                  ],
                )
              : Stack(
                  children: [
                    imageFile != null
                        ? Image.file(imageFile!)
                        : MyNetworkImage(imageUrl: imageUrl!),
                    if (onTap != null)
                      Positioned(
                        bottom: -9,
                        right: -9,
                        child: IconButton.filled(
                          constraints:
                              BoxConstraints.tight(const Size.square(30)),
                          padding: const EdgeInsets.all(5),
                          iconSize: 18,
                          onPressed: onDeletePressed,
                          icon: const Icon(
                            Icons.delete,
                          ),
                        ),
                      ),
                  ],
                ) /* Image.file(
                File(imagePath!),
                fit: BoxFit.cover,
              ), */
          ),
    );
  }
}
