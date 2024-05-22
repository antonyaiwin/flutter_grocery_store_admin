// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:flutter_grocery_store_admin/controller/firebase/firebase_storage_controller.dart';
import 'package:flutter_grocery_store_admin/controller/firebase/firestore_controller.dart';
import 'package:flutter_grocery_store_admin/model/category_model.dart';

import '../../view/crop_image_screen/crop_image_screen.dart';

class AddCategoryScreenController extends ChangeNotifier {
  // static const String imageCompressMessage = 'Compressing image';
  final CategoryModel? categoryModel;
  static const String uploadMessage = 'Uploading image';
  static const String addingCategoryMessage = 'Adding category';
  static const String updatingCategoryMessage = 'Updating category';
  final FireStoreController? _fireStoreController;
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  bool uploading = false;
  String message = 'Loading';
  File? imageFile;
  String? imageUrl;
  AddCategoryScreenController(
    this._fireStoreController, {
    this.categoryModel,
  }) {
    log('added controller');
    if (categoryModel != null) {
      nameController.text = categoryModel!.name ?? '';
      imageUrl = categoryModel?.imageUrl;
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
    return categoryModel == null ||
        (imageFile != null ||
            nameController.text != categoryModel?.name ||
            imageUrl != categoryModel?.imageUrl);
  }

  void _changeMessage(String msg) {
    message = msg;
    notifyListeners();
  }

  deleteImageFile() {
    imageFile = null;
    imageUrl = null;
    notifyListeners();
  }

  Future<bool> addCategory(BuildContext context) async {
    _changeUploadingStatus(true);
    if (_fireStoreController == null) {
      _changeUploadingStatus(false);
      return false;
    }

    String lastIndex = _fireStoreController.getLastCategoryIndex() ?? '-1';
    String id = (int.parse(lastIndex) + 1).toString().padLeft(10, '0');
    String? imageUrl;
    if (imageFile != null) {
      _changeMessage(uploadMessage);
      imageUrl = await context
          .read<FirebaseStorageController>()
          .addCategoryImage(imageFile!, id);
    }
    _changeMessage(addingCategoryMessage);
    await _fireStoreController.addCategory(
        CategoryModel(id: id, imageUrl: imageUrl, name: nameController.text));
    _changeUploadingStatus(false);
    return true;
  }

  Future<bool> updateCategory(BuildContext context) async {
    if (_fireStoreController == null) {
      return false;
    }
    // String? imageUrl;
    if (imageFile != null) {
      _changeUploadingStatus(true);
      imageUrl = await context
          .read<FirebaseStorageController>()
          .addCategoryImage(imageFile!, categoryModel!.id!);
    }
    _changeMessage(updatingCategoryMessage);
    await _fireStoreController.updateCategory(
      CategoryModel(
        collectionDocumentId: categoryModel!.collectionDocumentId,
        imageUrl: imageUrl,
        name: nameController.text == categoryModel!.name
            ? null
            : nameController.text,
      ),
    );
    _changeUploadingStatus(false);
    return true;
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

      imageFile = File(xFile.path)..writeAsBytes(image);
      notifyListeners();
    }
  }
}
