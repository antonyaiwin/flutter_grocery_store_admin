import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/model/category_model.dart';
import 'package:provider/provider.dart';

import '../../core/enum/delete_state.dart';
import '../../utils/functions/functions.dart';
import '../firebase/firestore_controller.dart';

class CategoryDeleteController extends ChangeNotifier {
  final CategoryModel category;
  DeleteState deleteState = DeleteState.initial;

  CategoryDeleteController({required this.category});
  Future<void> deleteCategory(BuildContext context) async {
    try {
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
    } on FirebaseException catch (e) {
      if (!context.mounted) {
        return;
      }
      showErrorSnackBar(
          context: context, content: 'Error : ${e.message ?? ''}');
      deleteState = DeleteState.error;
    }
    notifyListeners();
  }
}
