import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/model/category_model.dart';

class FireStoreController extends ChangeNotifier {
  static const String _categoryCollectionName = 'categories';
  var db = FirebaseFirestore.instance;
  List<CategoryModel> categoryList = [];

  FireStoreController() {
    addCategoriesListener();
  }

  addCategoriesListener() {
    db.collection(_categoryCollectionName).snapshots().listen((event) {
      categoryList = event.docs
          .map((e) => CategoryModel.fromQueryDocumentSnapshot(e))
          .toList();
      notifyListeners();
    });
  }
}
