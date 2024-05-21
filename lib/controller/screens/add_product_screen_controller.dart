// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:flutter_grocery_store_admin/controller/firebase/firestore_controller.dart';
import 'package:flutter_grocery_store_admin/core/enum/unit_type.dart';
import 'package:flutter_grocery_store_admin/model/product_model.dart';
import 'package:flutter_grocery_store_admin/view/crop_image_screen/crop_image_screen.dart';

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
  String? selectedCategoryId;
  UnitType? selectedUnitType = UnitType.kilogram;
  ProductModel? productModel;
  List<File> imagesList = [];
  List<String> imageUrlList = [];
  List<UnitType> unitList = UnitType.values;

  bool uploading = false, searchingDetails = false;
  String message = 'Loading';

  AddProductScreenController({
    this.productModel,
  }) {
    if (productModel != null) {
      populateProductDetails();
    }
  }

  void populateProductDetails() {
    nameController.text = productModel?.name ?? nameController.text;
    descriptionController.text =
        productModel?.description ?? descriptionController.text;
    selectedCategoryId = productModel?.categoryId ?? selectedCategoryId;
    priceMrpController.text =
        productModel?.priceMRP.toString() ?? priceMrpController.text;
    priceSellingController.text =
        productModel?.priceSelling.toString() ?? priceSellingController.text;
    quantityController.text =
        productModel?.quantity.toString() ?? quantityController.text;
    selectedUnitType = productModel?.unitType ?? selectedUnitType;
    barcodeController.text = productModel?.barcode ?? barcodeController.text;
    imageUrlList.addAll(productModel?.imageUrl ?? []);
  }

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

  void deleteImageLink(String imageUrl) {
    imageUrlList.remove(imageUrl);
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
        (imagesList.isNotEmpty ||
            nameController.text != productModel?.name ||
            descriptionController.text != productModel?.description ||
            double.tryParse(priceMrpController.text) !=
                productModel?.priceMRP ||
            double.tryParse(priceSellingController.text) !=
                productModel?.priceSelling ||
            double.tryParse(quantityController.text) !=
                productModel?.quantity ||
            barcodeController.text != productModel?.barcode ||
            selectedCategoryId != productModel?.categoryId ||
            selectedUnitType != productModel?.unitType ||
            imageUrlList != productModel?.imageUrl);
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

  Future<bool> updateProduct(BuildContext context) async {
    if (imagesList.isNotEmpty) {
      _changeUploadingStatus(true);
      for (var file in imagesList) {
        String? imageUrl = await context
            .read<FirebaseStorageController>()
            .addProductImage(file, productModel!.collectionDocumentId!);
        if (imageUrl != null) {
          imageUrlList.add(imageUrl);
        }
      }
    }
    _changeMessage(updatingProductMessage);
    await context.read<FireStoreController>().updateProduct(
          ProductModel(
            collectionDocumentId: productModel!.collectionDocumentId,
            name: nameController.text == productModel!.name
                ? null
                : nameController.text,
            description: descriptionController.text == productModel!.description
                ? null
                : descriptionController.text,
            categoryId: selectedCategoryId == productModel!.categoryId
                ? null
                : selectedCategoryId,
            priceMRP: double.tryParse(priceMrpController.text) ==
                    productModel!.priceMRP
                ? null
                : double.tryParse(priceMrpController.text),
            priceSelling: double.tryParse(priceSellingController.text) ==
                    productModel!.priceSelling
                ? null
                : double.tryParse(priceSellingController.text),
            quantity: double.tryParse(quantityController.text) ==
                    productModel!.quantity
                ? null
                : double.tryParse(quantityController.text),
            unitType: selectedUnitType == productModel!.unitType
                ? null
                : selectedUnitType,
            barcode: barcodeController.text == productModel!.barcode
                ? null
                : barcodeController.text,
            imageUrl:
                productModel!.imageUrl == imageUrlList ? null : imageUrlList,
          ),
        );
    _changeUploadingStatus(false);
    return true;
  }
}
