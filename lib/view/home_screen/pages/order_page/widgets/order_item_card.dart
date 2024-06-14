import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../../controller/screens/order_details_screen_controller/order_details_screen_controller.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/constants/image_constants.dart';
import '../../../../../core/enum/order_status.dart';
import '../../../../../model/order_model.dart';
import '../../../../../utils/global_widgets/order_header.dart';
import '../../../../../utils/global_widgets/order_status_indicator.dart';
import '../../../../order_details_screen/order_details_screen.dart';

class OrderItemCard extends StatelessWidget {
  const OrderItemCard({
    super.key,
    required this.orderSnap,
    this.isDense = false,
  });

  const OrderItemCard.dense({
    super.key,
    required this.orderSnap,
  }) : isDense = true;

  final QueryDocumentSnapshot<OrderModel> orderSnap;
  OrderModel get order => orderSnap.data();
  final bool isDense;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => OrderDetailsScreenController(
                context: context,
                orderSnap: orderSnap,
              ),
              child: OrderDetailsScreen(),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        decoration: BoxDecoration(
          color: ColorConstants.primaryWhite,
          border: Border.all(
            color: ColorConstants.hintColor,
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ColorConstants.primaryBlack.withOpacity(0.05),
                border: Border(
                  bottom: BorderSide(
                    color: ColorConstants.hintColor.withOpacity(0.3),
                  ),
                ),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
              ),
              child: OrderHeader(
                order: order,
                isDense: isDense,
              ),
            ),
            if (!isDense) ...[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    order.cartItems != null && order.cartItems!.length > 4
                        ? 5
                        : order.cartItems?.length ?? 0,
                    (index) {
                      if (index == 4) {
                        return Text(
                          '+ ${order.cartItems!.length - 4} more',
                          style: const TextStyle(
                              color: ColorConstants.primaryColor),
                        );
                      }
                      var e = order.cartItems![index];

                      return Text.rich(
                        TextSpan(
                          text: '${e.quantity} x ',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: ColorConstants.hintColor,
                                  ),
                          children: [
                            TextSpan(
                              text:
                                  '${e.product.name} [${e.product.getFormattedQuantity()}]',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: ColorConstants.primaryBlack,
                                  ),
                            ),
                          ],
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
              DottedLine(
                dashColor: ColorConstants.hintColor.withOpacity(0.4),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    if (order.orderCreatedTime != null) ...[
                      const Icon(
                        Iconsax.calendar_1_outline,
                        color: ColorConstants.hintColor,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        DateFormat("d MMM yyyy 'at' h:mm a")
                            .format(order.orderCreatedTime!),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorConstants.hintColor,
                            ),
                      ),
                    ],
                    const Spacer(),
                    if (order.paymentMethod == 'razorpay') ...[
                      Image.asset(
                        ImageConstants.razorpayLogo,
                        width: 18,
                        height: 18,
                      ),
                      Text(
                        'Razorpay',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorConstants.hintColor,
                            ),
                      ),
                    ] else if (order.paymentMethod == 'cod') ...[
                      const Icon(
                        Iconsax.moneys_outline,
                        size: 18,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Cash on delivery',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: ColorConstants.hintColor,
                            ),
                      )
                    ]
                  ],
                ),
              ),
              DottedLine(
                dashColor: ColorConstants.hintColor.withOpacity(0.4),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    OrderStatusIndicator(orderStatus: order.getOrderStatus()),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget getOrderStatusIndicator(OrderStatus orderStatus) {
    return Text(orderStatus.name);
  }
}
