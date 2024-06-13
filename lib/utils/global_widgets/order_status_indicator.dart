import 'package:flutter/material.dart';

import '../../core/enum/order_status.dart';

class OrderStatusIndicator extends StatelessWidget {
  const OrderStatusIndicator({
    super.key,
    required this.orderStatus,
  });

  final OrderStatus orderStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: orderStatus.color),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Row(
        children: [
          Icon(
            orderStatus.icon,
            color: orderStatus.color,
            size: 20,
          ),
          const SizedBox(width: 5),
          Text(
            orderStatus.text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: orderStatus.color),
          ),
        ],
      ),
    );
  }
}
