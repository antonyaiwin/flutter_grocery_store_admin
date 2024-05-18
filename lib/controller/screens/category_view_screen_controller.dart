import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/controller/firebase/firestore_controller.dart';
import 'package:flutter_grocery_store_admin/model/category_model.dart';
import 'package:flutter_grocery_store_admin/model/product_model.dart';
import 'package:provider/provider.dart';

class CategoryViewScreenController extends ChangeNotifier {
  final CategoryModel category;
  List<ProductModel> productList = [];
  bool isLoading = false;

  CategoryViewScreenController(BuildContext context, {required this.category}) {
    getProducts(context);
  }

  getProducts(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    productList = await context
        .read<FireStoreController>()
        .getProductByCategory(category.collectionDocumentId);
    isLoading = false;
    notifyListeners();
  }
}
