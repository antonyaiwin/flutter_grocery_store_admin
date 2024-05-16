import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/model/category_model.dart';

class FireStoreController extends ChangeNotifier {
  static const String _categoryCollectionName = 'categories';
  var db = FirebaseFirestore.instance;
  List<CategoryModel> categoryList = [];

  FireStoreController() {
    _initCategoriesListener();
  }

  String? getLastCategoryIndex() {
    return categoryList[categoryList.length - 1].id;
  }

  _initCategoriesListener() {
    db
        .collection(_categoryCollectionName)
        .orderBy('id')
        .snapshots()
        .listen((event) {
      categoryList = event.docs
          .map((e) => CategoryModel.fromQueryDocumentSnapshot(e))
          .toList();
      notifyListeners();
    });
  }

  Future<void> addCategory(CategoryModel category) async {
    await db.collection(_categoryCollectionName).add(category.toMap())
        /* .onError((error, stackTrace) {
      log(stackTrace.toString());
      log(error.toString());
    }) */
        ;
    log('addCategory completed');
  }
}
