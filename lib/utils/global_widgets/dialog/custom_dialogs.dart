import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/product/product_delete_controller.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/enum/delete_state.dart';
import '../../../model/product_model.dart';
import '../../functions/functions.dart';

void showProductDeleteDialog(BuildContext context, ProductModel item) {
  showDialog(
    context: context,
    builder: (context) => ChangeNotifierProvider(
      create: (BuildContext context) => ProductDeleteController(product: item),
      child: AlertDialog(
        title: const Text('Delete?'),
        content: Consumer<ProductDeleteController>(
          builder: (BuildContext context, value, Widget? child) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Are you sure to delete? \nThis can\'t be undone.'),
              if (value.deleteState == DeleteState.error)
                const Text(
                  'Error occurred while deleting the product!',
                  style: TextStyle(
                    color: ColorConstants.snackBarErrorBackground,
                  ),
                ),
            ],
          ),
        ),
        actions: [
          Consumer<ProductDeleteController>(
            builder: (BuildContext context, value, Widget? child) {
              if (value.deleteState == DeleteState.deleted) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.pop(context);
                  showSuccessSnackBar(
                    context: context,
                    content:
                        'Product "${item.name ?? ''}" deleted successfully.',
                  );
                });
              }
              return TextButton(
                onPressed: value.deleteState == DeleteState.deleting
                    ? null
                    : () {
                        value.deleteProduct(context);
                      },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Yes'),
                    if (value.deleteState == DeleteState.deleting) ...[
                      const SizedBox(width: 5),
                      const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(),
                      ),
                    ]
                  ],
                ),
              );
            },
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('no'),
          ),
        ],
      ),
    ),
  );
}
