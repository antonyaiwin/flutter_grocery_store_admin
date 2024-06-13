import 'package:flutter/material.dart';

import '../../core/constants/color_constants.dart';
import '../../model/order_model.dart';
import 'my_network_image.dart';

class OrderHeader extends StatelessWidget {
  const OrderHeader({
    super.key,
    required this.order,
    this.isDense = false,
  });

  final bool isDense;
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: ColorConstants.primaryWhite,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: ColorConstants.hintColor,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
          ),
          child: MyNetworkImage(
              imageUrl: order.cartItems?.first.product.imageUrl?.first ?? ''),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text.rich(
                TextSpan(
                  text: 'Total amount - ',
                  children: [
                    TextSpan(
                      text: '₹${order.finalPrice?.toStringAsFixed(2) ?? ''}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (isDense) Text(order.getOrderStatus().name),
      ],
    );
  }
}
