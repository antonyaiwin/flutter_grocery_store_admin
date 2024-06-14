import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

import '../constants/color_constants.dart';

enum OrderStatus {
  orderCreated(
      text: 'Order Placed',
      icon: Iconsax.bag_tick_2_bold,
      color: ColorConstants.orderCreatedColor,
      nextActionText: 'Accept Order'),
  orderAccepted(
      text: 'Order Accepted',
      icon: Iconsax.shop_bold,
      color: ColorConstants.orderAcceptedColor,
      nextActionText: 'Order Packed'),
  orderPacked(
      text: 'Order Packed',
      icon: Iconsax.box_bold,
      color: ColorConstants.orderPackedColor,
      nextActionText: 'Out for Delivery'),
  orderOutForDelivery(
      text: 'Out For Delivery',
      icon: Iconsax.truck_bold,
      color: ColorConstants.orderOutForDeliveryColor,
      nextActionText: 'Order Delivered'),
  orderDelivered(
      text: 'Order Delivered',
      icon: Iconsax.tick_square_bold,
      color: ColorConstants.orderDeliveredColor,
      nextActionText: ''),
  orderCancelled(
      text: 'Order Cancelled',
      icon: Iconsax.close_square_bold,
      color: ColorConstants.orderCancelledColor,
      nextActionText: ''),
  unknown(
      text: 'Status Unknown',
      icon: Iconsax.information_bold,
      color: ColorConstants.orderUnknownColor,
      nextActionText: '');

  final String text;
  final String nextActionText;
  final IconData icon;
  final Color color;

  const OrderStatus(
      {required this.text,
      required this.icon,
      required this.color,
      required this.nextActionText});
}
