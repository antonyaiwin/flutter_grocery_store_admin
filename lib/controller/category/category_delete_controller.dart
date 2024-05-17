import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/model/category_model.dart';
import 'package:provider/provider.dart';

import '../firebase/firestore_controller.dart';

class CategoryDeleteController extends ChangeNotifier {
  final CategoryModel category;
  DeleteState deleteState = DeleteState.initial;

  CategoryDeleteController({required this.category});
  Future<void> deleteCategory(BuildContext context) async {
    deleteState = DeleteState.deleting;
    notifyListeners();
    bool deleted = await context
        .read<FireStoreController>()
        .deleteCategory(category.collectionDocumentId!);
    if (deleted) {
      deleteState = DeleteState.deleted;
    } else {
      deleteState = DeleteState.error;
    }
    notifyListeners();
  }
}

enum DeleteState {
  initial,
  deleting,
  deleted,
  error,
}
