import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({super.key, required this.imageFile});
  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Photo'),
      ),
      body: PhotoView(imageProvider: FileImage(imageFile)),
    );
  }
}
