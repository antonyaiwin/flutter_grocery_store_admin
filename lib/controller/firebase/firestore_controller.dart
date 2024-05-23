import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:flutter_grocery_store_admin/model/category_model.dart';
import 'package:flutter_grocery_store_admin/model/product_model.dart';

class FireStoreController extends ChangeNotifier {
  static const String _categoryCollectionName = 'categories';
  static const String productsCollectionName = 'grocery-shop/data/products';
  var db = FirebaseFirestore.instance;
  List<CategoryModel> categoryList = [];
  List<ProductModel> productList = [];

  FireStoreController() {
    _initCategoriesListener();
    _initProductsListener();
  }

  String? getLastCategoryIndex() {
    return categoryList.isEmpty
        ? '0'
        : categoryList[categoryList.length - 1].id;
  }

  int? getLastProductIndex() {
    return productList.isEmpty ? 0 : productList[productList.length - 1].id;
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

  void _initProductsListener() {
    db
        .collection(productsCollectionName)
        .orderBy('id')
        .snapshots()
        .listen((event) {
      productList = event.docs
          .map((e) => ProductModel.fromQueryDocumentSnapshot(e))
          .toList();
      notifyListeners();
    });
  }

// CATEGORY CRUD Operation

  Future<void> addCategory(CategoryModel category) async {
    await db.collection(_categoryCollectionName).add(category.toMap())
        /* .onError((error, stackTrace) {
      log(stackTrace.toString());
      log(error.toString());
    }) */
        ;
    log('addCategory completed');
  }

  Future<void> updateCategory(CategoryModel category) async {
    await db
        .collection(_categoryCollectionName)
        .doc(category.collectionDocumentId)
        .update({
      if (category.name != null) 'name': category.name,
      if (category.imageUrl != null) 'imageUrl': category.imageUrl,
    });
    log('updateCategory completed');
  }

  Future<bool> deleteCategory(String categoryId) async {
    try {
      await db.collection(_categoryCollectionName).doc(categoryId).delete()
          /* .onError((error, stackTrace) =>
              log('deleteCategory onError : $error \n $stackTrace')) */
          ;
      return true;
    } on FirebaseException catch (e) {
      log('deleteCategory FirebaseException: ${e.code}');
      return false;
    }
  }

  CategoryModel? getCategoryById(String id) {
    return categoryList
        .firstWhereOrNull((element) => element.collectionDocumentId == id);
  }

  ProductModel? getProductById(String id) {
    return productList
        .firstWhereOrNull((element) => element.collectionDocumentId == id);
  }

  // PRODUCTS CRUD Operation

  Future<DocumentReference<Map<String, dynamic>>> addProduct(
      ProductModel product) async {
    var ref = await db.collection(productsCollectionName).add(product.toMap());
    log('addProduct completed');
    return ref;
  }

  Future<List<ProductModel>> getProductByCategory(String? categoryId) async {
    List<ProductModel> list = [];
    if (categoryId == null) {
      return list;
    }
    var data = await db
        .collection(productsCollectionName)
        .where('categoryId', isEqualTo: categoryId)
        .get();
    list = data.docs
        .map((e) => ProductModel.fromQueryDocumentSnapshot(e))
        .toList();
    return list;
  }

  Future<void> updateProduct(ProductModel product) async {
    await db
        .collection(productsCollectionName)
        .doc(product.collectionDocumentId)
        .update(product.toMapWithoutNull());
    log('updateProduct completed');
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await db.collection(productsCollectionName).doc(productId).delete()
          /*  .onError((error, stackTrace) =>
              log('deleteProduct onError : $error \n $stackTrace')) */
          ;
      return true;
    } on FirebaseException catch (e) {
      log('deleteProduct FirebaseException: ${e.code}');
      return false;
    }
  }

  Future<List<ProductModel>> searchProductsUsingBarcode(String text) async {
    List<ProductModel> list = [];
    try {
      var data = await db
          .collection(productsCollectionName)
          .where('barcode', isEqualTo: text)
          .get();
      list = data.docs
          .map((e) => ProductModel.fromQueryDocumentSnapshot(e))
          .toList();
    } on FirebaseException catch (e) {
      log('searchProductsUsingBarcode FirebaseException: ${e.code}');
    }
    return list;
  }
}
