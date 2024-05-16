import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_grocery_store_admin/utils/functions/image_functions.dart';

class FirebaseStorageController extends ChangeNotifier {
  final storgeRef = FirebaseStorage.instance.ref();
  static const String baseStoragePath = 'grocery-store';
  static const String categoryStoragePath =
      '$baseStoragePath/categories/images/';

  Future<String?> addCategoryImage(File image, String id) async {
    var imageRef = storgeRef.child('$categoryStoragePath$id.jpg');
    Uint8List? imageData = await getCompressedImageData(image);
    if (imageData == null) {
      return null;
    }
    try {
      await imageRef.putData(imageData);
      return await imageRef.getDownloadURL();
    } on FirebaseException catch (e) {
      log(e.toString());
      return null;
    }
  }
}
