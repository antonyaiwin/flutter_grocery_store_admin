import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_grocery_store_admin/core/constants/color_constants.dart';
import 'package:flutter_grocery_store_admin/utils/global_widgets/my_network_image.dart';
import 'package:provider/provider.dart';

import '../../controller/cart_controller.dart';
import '../../model/product_model.dart';
import '../../view/product_details_screen/product_details_screen.dart';
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
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  Expanded(
                    flex: 6,
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
                    flex: 5,
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
                            Text(
                              '₹${item.getFormattedSellingPrice()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '₹${item.getFormattedMRP()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: ColorConstants.hintColor,
                                    decoration: TextDecoration.lineThrough,
                                    decorationColor: ColorConstants.hintColor,
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
