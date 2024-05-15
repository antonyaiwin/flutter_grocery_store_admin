import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_grocery_store_admin/view/crop_image_screen/crop_image_screen.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreenController extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  String? selectedCategory;

  List<File> imagesList = [];

  onCategorySelected(String? value) {
    selectedCategory = value;
  }

  Future<void> scanBarcode() async {
    String result = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'Cancel',
      true,
      ScanMode.DEFAULT,
    );
    log(result);
    if (result != '-1') {
      barcodeController.text = result;
    }
  }

  Future<void> pickImage(BuildContext context) async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xFile != null) {
      Uint8List? image = await xFile.readAsBytes();
      if (!context.mounted) {
        return;
      }
      image = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CropImageScreen(image: image!),
        ),
      );
      if (image == null) {
        return;
      }

      imagesList.add(File(xFile.path)..writeAsBytes(image));
      notifyListeners();
    }
  }
}
