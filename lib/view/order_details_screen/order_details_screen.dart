import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/controller/screens/order_details_screen_controller/order_details_screen_controller.dart';
import 'package:flutter_grocery_store_admin/core/constants/color_constants.dart';
import 'package:flutter_grocery_store_admin/model/address_model.dart';
import 'package:flutter_grocery_store_admin/model/order_model.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:provider/provider.dart';
import '../../utils/global_widgets/address_card.dart';
import '../../utils/global_widgets/bill_details_card.dart';
import '../../utils/global_widgets/elevated_card.dart';
import '../../utils/global_widgets/order_header.dart';
import 'widgets/my_stepper.dart';

class OrderDetailsScreen extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  OrderDetailsScreen({super.key});
  late final OrderDetailsScreenController provider;
  OrderModel get order => provider.order;

  @override
  Widget build(BuildContext context) {
    provider = context.read<OrderDetailsScreenController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Summary'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedCard(
                    padding: const EdgeInsets.all(10),
                    child: Consumer<OrderDetailsScreenController>(
                      builder: (BuildContext context, value, Widget? child) =>
                          OrderHeader(order: order),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedCard(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Consumer(
                          builder: (BuildContext context, value,
                                  Widget? child) =>
                              MySubtitle('Items (${order.itemCount ?? ''})'),
                        ),
                        const MyDivider(),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Consumer<OrderDetailsScreenController>(
                            builder:
                                (BuildContext context, value, Widget? child) =>
                                    Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: order.cartItems
                                      ?.map(
                                        (e) => Text.rich(
                                          TextSpan(
                                            text: '${e.quantity} x ',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color:
                                                      ColorConstants.hintColor,
                                                ),
                                            children: [
                                              TextSpan(
                                                text:
                                                    '${e.product.name} [${e.product.getFormattedQuantity()}]',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: ColorConstants
                                                          .primaryBlack,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList() ??
                                  [],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedCard(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const MySubtitle('Order Status'),
                        const MyDivider(),
                        const SizedBox(height: 5),
                        Consumer<OrderDetailsScreenController>(
                          builder:
                              (BuildContext context, value, Widget? child) =>
                                  MyStepper(provider: provider),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer<OrderDetailsScreenController>(
                    builder: (BuildContext context, value, Widget? child) =>
                        ElevatedCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 10, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                MySubtitle('Delivery Address'),
                                MyDivider(),
                              ],
                            ),
                          ),
                          AddressCard(
                            address: order.deliveryAddress ?? AddressModel(),
                            isDefault: false,
                            displayChangeButton: true,
                            onChangePressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Consumer<OrderDetailsScreenController>(
                    builder: (BuildContext context, value, Widget? child) {
                      double? discount = ((order.totalPrice ?? 0) -
                          ((order.finalPrice ?? 0) -
                              (order.deliveryPrice ?? 0)));
                      return BillDetailsCard(
                        totalItems: order.cartItems?.fold<int>(
                            0,
                            (previousValue, element) =>
                                previousValue += element.quantity),
                        subtotal: order.totalPrice,
                        deliveryCharge: 20.0,
                        discount: discount != 0 ? discount : null,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Cancel Order'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Call Customer'),
                ),
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Consumer<OrderDetailsScreenController>(
              builder: (BuildContext context, value, Widget? child) {
                return SwipeButton.expand(
                  thumbPadding: const EdgeInsets.all(3),
                  activeTrackColor:
                      order.getOrderStatus().color.withOpacity(0.4),
                  activeThumbColor: order.getOrderStatus().color,
                  thumb: const Icon(
                    Icons.chevron_right,
                    color: ColorConstants.primaryWhite,
                  ),
                  elevationThumb: 2,
                  child: Text(
                    order.getOrderStatus().nextActionText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onSwipe: () {
                    provider.orderSwiped(value.order.getOrderStatus());
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MySubtitle extends StatelessWidget {
  const MySubtitle(
    this.text, {
    super.key,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}

class MyDivider extends StatelessWidget {
  const MyDivider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: ColorConstants.hintColor,
      thickness: 0.2,
    );
  }
}
