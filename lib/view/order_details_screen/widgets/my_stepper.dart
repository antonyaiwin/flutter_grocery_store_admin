import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../controller/screens/order_details_screen_controller/order_details_screen_controller.dart';
import 'my_step.dart';

class MyStepper extends StatelessWidget {
  const MyStepper({
    super.key,
    required this.provider,
  });

  final OrderDetailsScreenController provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyStep(
          title: 'Order placed\t\t\t',
          subtitle: provider.order.orderCreatedTime != null
              ? DateFormat('EEE, d MMM yyyy - h:mm a').format(
                  provider.order.orderCreatedTime!,
                )
              : null,
          isCompleted: provider.order.orderCreatedTime != null,
          isFirst: true,
        ),
        MyStep(
          title: 'Order Accepted\t\t\t',
          subtitle: provider.order.orderAcceptedTime != null
              ? DateFormat('EEE, d MMM yyyy - h:mm a').format(
                  provider.order.orderAcceptedTime!,
                )
              : null,
          isCompleted: provider.order.orderAcceptedTime != null,
        ),
        MyStep(
          title: 'Order packed\t\t\t',
          subtitle: provider.order.orderPackedTime != null
              ? DateFormat('EEE, d MMM yyyy - h:mm a').format(
                  provider.order.orderPackedTime!,
                )
              : null,
          isCompleted: provider.order.orderPackedTime != null,
        ),
        MyStep(
          title: 'Order out for delivery\t\t\t',
          subtitle: provider.order.orderOutForDeliveryTime != null
              ? DateFormat('EEE, d MMM yyyy - h:mm a').format(
                  provider.order.orderOutForDeliveryTime!,
                )
              : null,
          isCompleted: provider.order.orderOutForDeliveryTime != null,
        ),
        MyStep(
          title: 'Order delivered\t\t\t',
          subtitle: provider.order.orderDeliveredTime != null
              ? DateFormat('EEE, d MMM yyyy - h:mm a').format(
                  provider.order.orderDeliveredTime!,
                )
              : null,
          isCompleted: provider.order.orderDeliveredTime != null,
          isLast: true,
        ),
      ],
    );
  }
}
