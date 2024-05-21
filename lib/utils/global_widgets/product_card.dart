import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_grocery_store_admin/controller/screens/add_product_screen_controller.dart';
import 'package:flutter_grocery_store_admin/core/constants/color_constants.dart';
import 'package:flutter_grocery_store_admin/utils/global_widgets/my_network_image.dart';
import 'package:flutter_grocery_store_admin/view/add_product_screen/add_product_screen.dart';
import 'package:provider/provider.dart';

import '../../controller/cart_controller.dart';
import '../../controller/product/product_delete_controller.dart';
import '../../core/enum/delete_state.dart';
import '../../model/product_model.dart';
import '../../view/product_details_screen/product_details_screen.dart';
import '../functions/functions.dart';
import 'add_to_cart_button.dart';
import 'elevated_card.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.item,
  });

  final ProductModel item;

  @override
  Widget build(BuildContext context) {
    return ElevatedCard(
      elevation: 5,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(item: item),
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(15).copyWith(bottom: 0),
              child: Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: MyNetworkImage(
                          imageUrl:
                              item.imageUrl != null && item.imageUrl!.isNotEmpty
                                  ? item.imageUrl![0]
                                  : ''),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.name ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Row(
                          children: [
                            Text(
                              item.getFormattedQuantity(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            // Selling Price
                            Text(
                              '₹${item.getFormattedSellingPrice()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.primaryGreen,
                                  ),
                            ),
                            const SizedBox(width: 3),

                            // MRP
                            if (item.getOffer() != null)
                              Text(
                                '₹${item.getFormattedMRP()}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: ColorConstants.hintColor,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor:
                                          ColorConstants.primaryRed,
                                    ),
                              ),
                            // Consumer<CartController>(
                            //   builder: (BuildContext context, value, Widget? child) =>
                            //       AddToCartButton(
                            //     count: value.getItemCount(item.id ?? 0),
                            //     label: 'ADD',
                            //     height: 30,
                            //     width: 70,
                            //     onTap: () {
                            //       value.addItemToCart(item);
                            //     },
                            //     onAddTap: () {
                            //       value.addItemToCart(item);
                            //     },
                            //     onRemoveTap: () {
                            //       value.removeItemFromCart(item);
                            //     },
                            //   ),
                            // ),
                            Spacer(),

                            PopupMenuButton(
                              itemBuilder: (BuildContext context) => [
                                PopupMenuItem(
                                  child: const Text('Edit'),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ChangeNotifierProvider(
                                          create: (context) =>
                                              AddProductScreenController(
                                            productModel: item,
                                          ),
                                          child: const AddProductScreen(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                PopupMenuItem(
                                  child: const Text('Delete'),
                                  onTap: () {
                                    showDeleteDialog(context);
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (item.getOffer() != null)
              Positioned(
                child: Container(
                  decoration: const BoxDecoration(
                    color: ColorConstants.primaryGreen,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    item.getOffer()!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: ColorConstants.primaryWhite,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ChangeNotifierProvider(
        create: (BuildContext context) =>
            ProductDeleteController(product: item),
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
}
