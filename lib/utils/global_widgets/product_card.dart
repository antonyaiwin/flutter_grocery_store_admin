import 'package:flutter/material.dart';
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
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: MyNetworkImage(
                    imageUrl: item.imageUrl != null && item.imageUrl!.isNotEmpty
                        ? item.imageUrl![0]
                        : ''),
              ),
              Text(
                item.name ?? '',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    '250g',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '₹${item.priceMRP?.toStringAsFixed(1) ?? ''}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
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
                  // )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
