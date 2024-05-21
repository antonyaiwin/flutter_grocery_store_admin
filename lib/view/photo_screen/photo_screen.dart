import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key, required this.imageFile, this.imageUrl});
  const PhotoScreen.network({super.key, required this.imageUrl})
      : imageFile = null;
  final File? imageFile;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Photo'),
      ),
      body: imageFile != null
          ? PhotoView(
              imageProvider: FileImage(imageFile!),
            )
          : PhotoView(
              imageProvider: NetworkImage(imageUrl!),
            ),
    );
  }
}
