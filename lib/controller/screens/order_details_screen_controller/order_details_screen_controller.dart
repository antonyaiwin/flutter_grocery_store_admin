import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/core/enum/order_status.dart';
import 'package:flutter_grocery_store_admin/utils/functions/functions.dart';

import '../../../model/order_model.dart';

class OrderDetailsScreenController extends ChangeNotifier {
  QueryDocumentSnapshot<OrderModel> orderSnap;
  OrderModel order;
  BuildContext context;
  bool changingOrderStatus = false;
  OrderDetailsScreenController({
    required this.context,
    required this.orderSnap,
  }) : order = OrderModel() {
    order = orderSnap.data();

    _initOrderListener();
  }

  Future<void> _initOrderListener() async {
    orderSnap.reference.snapshots().listen(
      (event) {
        if (event.data() != null) {
          order = event.data()!;
          notifyListeners();
        }
      },
    );
  }

  Future<void> orderSwiped(OrderStatus orderStatus) async {
    OrderModel? temp;
    DateTime now = DateTime.now();

    switch (orderStatus) {
      case OrderStatus.orderCreated:
        temp = OrderModel(orderAcceptedTime: now);
        break;
      case OrderStatus.orderAccepted:
        temp = OrderModel(orderPackedTime: now);
        break;
      case OrderStatus.orderPacked:
        temp = OrderModel(orderOutForDeliveryTime: now);
        break;
      case OrderStatus.orderOutForDelivery:
        temp = OrderModel(orderDeliveredTime: now);
        break;
      case OrderStatus.orderDelivered:
        temp = OrderModel(orderAcceptedTime: now);
        break;
      case OrderStatus.orderCancelled:
        temp = OrderModel(orderAcceptedTime: now);
        break;

      default:
        break;
    }
    if (temp != null) {
      try {
        await orderSnap.reference.update(temp.toMap());
      } on Exception catch (e) {
        log(e.toString());
        if (context.mounted) {
          showErrorSnackBar(context: context, content: 'Something went wrong');
        }
      }
    } else {
      if (context.mounted) {
        showErrorSnackBar(context: context, content: 'Something went wrong');
      }
    }
    notifyListeners();
  }
}
