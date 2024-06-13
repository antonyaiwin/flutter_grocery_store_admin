import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../constants/color_constants.dart';

enum OrderStatus {
  orderCreated(
    text: 'Order Placed',
    icon: Iconsax.bag_tick_2_bold,
    color: ColorConstants.orderCreatedColor,
  ),
  orderAccepted(
    text: 'Order Accepted',
    icon: Iconsax.shop_bold,
    color: ColorConstants.orderAcceptedColor,
  ),
  orderPacked(
    text: 'Order Packed',
    icon: Iconsax.box_bold,
    color: ColorConstants.orderPackedColor,
  ),
  orderOutForDelivery(
    text: 'Out For Delivery',
    icon: Iconsax.truck_bold,
    color: ColorConstants.orderOutForDeliveryColor,
  ),
  orderDelivered(
    text: 'Order Delivered',
    icon: Iconsax.tick_square_bold,
    color: ColorConstants.orderDeliveredColor,
  ),
  orderCancelled(
    text: 'Order Cancelled',
    icon: Iconsax.close_square_bold,
    color: ColorConstants.orderCancelledColor,
  ),
  unknown(
    text: 'Status Unknown',
    icon: Iconsax.information_bold,
    color: ColorConstants.orderUnknownColor,
  );

  final String text;
  final IconData icon;
  final Color color;

  const OrderStatus(
      {required this.text, required this.icon, required this.color});
}
