import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/controller/screens/add_product_screen_controller.dart';
import 'package:flutter_grocery_store_admin/core/constants/color_constants.dart';
import 'package:flutter_grocery_store_admin/utils/global_widgets/my_network_image.dart';
import 'package:flutter_grocery_store_admin/view/add_product_screen/add_product_screen.dart';
import 'package:provider/provider.dart';

import '../../model/product_model.dart';
import '../../view/product_details_screen/product_details_screen.dart';
import 'dialog/custom_dialogs.dart';
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
                            const Spacer(),

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
                                    showProductDeleteDialog(context, item);
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
}
