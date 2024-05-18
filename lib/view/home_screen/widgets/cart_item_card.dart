import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/cart_controller.dart';
import '../../../model/product_model.dart';
import '../../../utils/global_widgets/add_to_cart_button.dart';
import '../../../utils/global_widgets/my_network_image.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    super.key,
    required this.item,
  });

  final ProductModel item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadiusDirectional.circular(15),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 1,
            child: AspectRatio(
              aspectRatio: 1,
              child: MyNetworkImage(
                  imageUrl: item.imageUrl != null && item.imageUrl!.isNotEmpty
                      ? item.imageUrl![0]
                      : ''),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.name ?? '',
                        style: Theme.of(context).textTheme.titleMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read<CartController>().deleteItemFromCart(item);
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text('Item removed from cart'),
                        ));
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 15,
                            ),
                            Text(item.rating.toString()),
                          ],
                        ),
                        Text(
                          '₹${item.priceMRP}',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Consumer<CartController>(
                      builder: (context, value, child) {
                        return AddToCartButton(
                          count: value.getItemCount(item.id ?? 0),
                          onTap: () {
                            value.addItemToCart(item);
                          },
                          onAddTap: () {
                            value.addItemToCart(item);
                          },
                          onRemoveTap: () {
                            value.removeItemFromCart(item);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
