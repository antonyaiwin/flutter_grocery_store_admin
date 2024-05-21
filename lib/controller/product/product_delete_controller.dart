import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/model/product_model.dart';
import 'package:provider/provider.dart';

import '../../core/enum/delete_state.dart';
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
    bool deleted = await context
        .read<FireStoreController>()
        .deleteProduct(product.collectionDocumentId!);
    if (deleted) {
      deleteState = DeleteState.deleted;
    } else {
      deleteState = DeleteState.error;
    }
    notifyListeners();
  }
}
