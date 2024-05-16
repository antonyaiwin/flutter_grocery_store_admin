import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';

class AddImageWidget extends StatelessWidget {
  const AddImageWidget({
    super.key,
    this.imageFile,
    this.onTap,
    this.borderRadius,
  });
  final File? imageFile;
  final void Function()? onTap;
  final BorderRadius? borderRadius;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius ?? BorderRadius.circular(10),
      child: Container(
          clipBehavior: Clip.antiAlias,
          height: 100,
          width: imageFile != null ? null : 100,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? BorderRadius.circular(10),
            // image: imagePath != null
            //     ? DecorationImage(image: FileImage(File(imagePath!)))
            //     : null,
            border: imageFile != null
                ? null
                : Border.all(
                    color: ColorConstants.hintColor,
                    width: 2,
                  ),
          ),
          child: imageFile == null
              ? const Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 35,
                )
              : Stack(
                  children: [
                    Image.file(imageFile!),
                    Positioned(
                      bottom: -9,
                      right: -9,
                      child: IconButton.filled(
                        constraints:
                            BoxConstraints.tight(const Size.square(30)),
                        padding: const EdgeInsets.all(5),
                        iconSize: 18,
                        onPressed: () {},
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
