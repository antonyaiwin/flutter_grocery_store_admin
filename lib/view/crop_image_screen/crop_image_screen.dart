import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/core/constants/color_constants.dart';

class CropImageScreen extends StatefulWidget {
  const CropImageScreen({super.key, required this.image});

  final Uint8List image;

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  final CropController cropController = CropController();

  double? aspectRatio = 1;

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
      body: Column(
        children: [
          Expanded(
            child: Crop(
              controller: cropController,
              image: widget.image,
              aspectRatio: aspectRatio,
              initialSize: 0.8,
              onCropped: (value) {
                Navigator.pop(context, value);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  _changeAspectRatio(null);
                },
                icon: Icon(
                  Icons.crop,
                  color:
                      aspectRatio == null ? ColorConstants.primaryColor : null,
                ),
              ),
              IconButton(
                onPressed: () {
                  _changeAspectRatio(1);
                },
                icon: Icon(
                  Icons.crop_din,
                  color: aspectRatio == 1 ? ColorConstants.primaryColor : null,
                ),
              ),
              IconButton(
                onPressed: () {
                  _changeAspectRatio(16 / 9);
                },
                icon: Icon(
                  Icons.crop_16_9,
                  color: aspectRatio == 16 / 9
                      ? ColorConstants.primaryColor
                      : null,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context, widget.image);
            },
            child: const Text('Continue without cropping'),
          ),
        ],
      ),
    );
  }

  _changeAspectRatio(double? value) {
    aspectRatio = value;
    cropController.aspectRatio = value;
    setState(() {});
  }
}
