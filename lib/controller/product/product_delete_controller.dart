import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/model/product_model.dart';
import 'package:provider/provider.dart';

import '../../core/enum/delete_state.dart';
import '../../utils/functions/functions.dart';
import '../firebase/firestore_controller.dart';

class ProductDeleteController extends ChangeNotifier {
  final ProductModel product;
  DeleteState deleteState = DeleteState.initial;

  ProductDeleteController({required this.product});
  Future<void> deleteProduct(BuildContext context) async {
    deleteState = DeleteState.deleting;
    notifyListeners();
    // await context
    //     .read<FirebaseStorageController>()
    //     .deleteProductFiles(product.collectionDocumentId!);
    try {
      bool deleted = await context
          .read<FireStoreController>()
          .deleteProduct(product.collectionDocumentId!);
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
