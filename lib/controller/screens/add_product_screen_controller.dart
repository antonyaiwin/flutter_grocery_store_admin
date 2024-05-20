import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_grocery_store_admin/controller/firebase/firestore_controller.dart';
import 'package:flutter_grocery_store_admin/core/enum/unit_type.dart';
import 'package:flutter_grocery_store_admin/model/product_model.dart';
import 'package:flutter_grocery_store_admin/view/crop_image_screen/crop_image_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../firebase/firebase_storage_controller.dart';

class AddProductScreenController extends ChangeNotifier {
  static const String uploadMessage = 'Uploading image';
  static const String addingProductMessage = 'Adding product';
  static const String updatingProductMessage = 'Updating product';

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceMrpController = TextEditingController();
  TextEditingController priceSellingController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  ProductModel? productModel;

  bool uploading = false, searchingDetails = false;
  String message = 'Loading';
  String? selectedCategoryId;
  UnitType? selectedUnitType = UnitType.kilogram;

  List<File> imagesList = [];
  List<String> imageUrlList = [];
  List<UnitType> unitList = UnitType.values;

  onCategorySelected(String? value) {
    selectedCategoryId = value;
  }

  onUnitSelected(UnitType? value) {
    selectedUnitType = value;
  }

  void deleteImage(File file) {
    imagesList.remove(file);
    notifyListeners();
  }

  Future<String> scanBarcode() async {
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
    return result;
  }

  Future<void> pickImage(BuildContext context,
      [ImageSource source = ImageSource.camera]) async {
    XFile? xFile = await ImagePicker().pickImage(source: source);
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

      var file = File(xFile.path);
      file.writeAsBytes(image);
      imagesList.add(file);
      notifyListeners();
    }
  }

  void _changeUploadingStatus(bool value) {
    uploading = value;
    if (value) {
      _changeMessage(uploadMessage);
    }
    notifyListeners();
  }

  bool isEdited() {
    return productModel == null ||
        (imagesList.isNotEmpty || nameController.text != productModel?.name);
  }

  void _changeMessage(String msg) {
    message = msg;
    notifyListeners();
  }

  // Product CRUD Operations

  Future<bool> addProduct(BuildContext context) async {
    _changeUploadingStatus(true);

    int lastIndex =
        context.read<FireStoreController>().getLastProductIndex() ?? -1;
    lastIndex++;
    _changeMessage(addingProductMessage);
    var ref = await context.read<FireStoreController>().addProduct(
          ProductModel(
            id: lastIndex,
            name: nameController.text,
            description: descriptionController.text,
            categoryId: selectedCategoryId,
            priceMRP: double.parse(priceMrpController.text),
            priceSelling: double.parse(priceSellingController.text),
            quantity: double.parse(quantityController.text),
            unitType: selectedUnitType,
            barcode: barcodeController.text,
          ),
        );

    if (imagesList.isNotEmpty) {
      _changeMessage(uploadMessage);
    }
    for (var imageFile in imagesList) {
      var imageUrl =
          await context.read<FirebaseStorageController>().addProductImage(
                imageFile,
                ref.id,
                imagesList.indexOf(imageFile).toString().padLeft(10, '0'),
              );
      if (imageUrl != null) {
        imageUrlList.add(imageUrl);
      }
    }
    await context.read<FireStoreController>().updateProduct(
          ProductModel(collectionDocumentId: ref.id, imageUrl: imageUrlList),
        );
    _changeUploadingStatus(false);
    return true;
  }

  // Future<bool> updateCategory(BuildContext context) async {
  //   if (_fireStoreController == null) {
  //     return false;
  //   }
  //   String? imageUrl;
  //   if (imageFile != null) {
  //     _changeUploadingStatus(true);
  //     imageUrl = await context
  //         .read<FirebaseStorageController>()
  //         .addCategoryImage(imageFile!, categoryModel!.id!);
  //   }
  //   _changeMessage(updatingCategoryMessage);
  //   await _fireStoreController.updateCategory(
  //     CategoryModel(
  //       collectionDocumentId: categoryModel!.collectionDocumentId,
  //       imageUrl: imageUrl,
  //       name: nameController.text == categoryModel!.name
  //           ? null
  //           : nameController.text,
  //     ),
  //   );
  //   _changeUploadingStatus(false);
  //   return true;
  // }
}
