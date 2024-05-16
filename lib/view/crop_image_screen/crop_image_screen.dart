import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CropImageScreen extends StatelessWidget {
  CropImageScreen({super.key, required this.image});

  final Uint8List image;
  final CropController cropController = CropController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Image'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              cropController.crop();
            },
            icon: const Icon(Icons.done),
          )
        ],
      ),
      body: Crop(
        controller: cropController,
        image: image,
        onCropped: (value) {
          Navigator.pop(context, value);
        },
      ),
    );
  }
}
