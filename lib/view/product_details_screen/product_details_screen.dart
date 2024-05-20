import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/controller/firebase/firestore_controller.dart';
import 'package:provider/provider.dart';

import '../../controller/cart_controller.dart';
import '../../core/constants/color_constants.dart';
import '../../model/product_model.dart';
import '../../utils/global_widgets/add_to_cart_button.dart';
import '../../utils/global_widgets/my_network_image.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.item});
  final ProductModel item;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Product Details'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.circular(15),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    Center(
                      child: MyNetworkImage(
                          imageUrl:
                              item.imageUrl != null && item.imageUrl!.isNotEmpty
                                  ? item.imageUrl![0]
                                  : ''),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.name ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Quantity
                    Text(
                      item.getFormattedQuantity(),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        // Selling Price
                        Text(
                          '₹${item.getFormattedSellingPrice()}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(width: 3),
                        if (item.getOffer() != null) ...[
                          // MRP price
                          Text(
                            '₹${item.getFormattedMRP()}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: ColorConstants.hintColor,
                                  decoration: TextDecoration.lineThrough,
                                  decorationColor: ColorConstants.primaryRed,
                                ),
                          ),
                          const SizedBox(width: 10),

                          // Offer
                          Container(
                            decoration: const BoxDecoration(
                              color: ColorConstants.primaryGreen,
                              borderRadius: BorderRadius.all(
                                Radius.circular(15),
                              ),
                            ),
                            padding: const EdgeInsets.all(5),
                            child: Text(
                              item.getOffer()!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: ColorConstants.primaryWhite,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (item.rating != null && item.ratingCount != null)
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            double rating = item.rating ?? 0;
                            return Icon(
                              Icons.star,
                              size: 15,
                              color: rating.round() ~/ (index + 1) == 0
                                  ? Colors.grey
                                  : Colors.amber,
                            );
                          }),

                          const SizedBox(width: 10),
                          // Text(
                          //   item.rating.count.toString(),
                          //   style: Theme.of(context)
                          //       .textTheme
                          //       .bodyMedium
                          //       ?.copyWith(
                          //           color: Colors.amber,
                          //           fontWeight: FontWeight.bold),
                          // ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.ratingCount ?? 0} Ratings',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        ],
                      )
                    else
                      Text(
                        'No ratings yet',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    const SizedBox(height: 20),
                    const Divider(),
                    Text(
                      'Category',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 20,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        MyNetworkImage(
                            height: 75,
                            width: 75,
                            imageUrl: context
                                    .read<FireStoreController>()
                                    .getCategoryById(item.categoryId ?? '')
                                    ?.imageUrl ??
                                ''),
                        const SizedBox(width: 10),
                        Text(
                          context
                                  .read<FireStoreController>()
                                  .getCategoryById(item.categoryId ?? '')
                                  ?.name ??
                              'No category',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10), const Divider(),
                    Text(
                      'Description',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 20,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.description ?? '',
                      textAlign: TextAlign.justify,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 215, 215, 215),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      item.getFormattedSellingPrice(),
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ],
                ),
                const Spacer(),
                Consumer<CartController>(
                  builder: (context, value, child) {
                    return AddToCartButton(
                      count: value.getItemCount(item.id!),
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
          )
        ],
      ),
    );
  }
}
