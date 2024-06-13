import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_grocery_store_admin/core/enum/order_status.dart';

import 'package:flutter_grocery_store_admin/model/address_model.dart';
import 'package:flutter_grocery_store_admin/model/cart_item_model.dart';

class OrderModel {
  String? collectionDocumentId;
  String? createdUserId;
  String? paymentMethod;
  List<CartItemModel>? cartItems;
  AddressModel? deliveryAddress;
  double? totalPrice;
  double? deliveryPrice;
  double? finalPrice;
  int? itemCount;
  DateTime? orderCreatedTime;
  DateTime? orderAcceptedTime;
  DateTime? orderPackedTime;
  DateTime? orderOutForDeliveryTime;
  DateTime? orderDeliveredTime;
  DateTime? orderCancelledTime;

  OrderModel({
    this.collectionDocumentId,
    this.createdUserId,
    this.paymentMethod,
    this.cartItems,
    this.deliveryAddress,
    this.totalPrice,
    this.deliveryPrice,
    this.finalPrice,
    this.itemCount,
    this.orderCreatedTime,
    this.orderAcceptedTime,
    this.orderPackedTime,
    this.orderOutForDeliveryTime,
    this.orderDeliveredTime,
    this.orderCancelledTime,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'createdUserId': createdUserId,
      'paymentMethod': paymentMethod,
      'cartItems': cartItems?.map((x) => x.toMap()).toList(),
      'deliveryAddress': deliveryAddress?.toMap(),
      'totalPrice': totalPrice,
      'deliveryPrice': deliveryPrice,
      'finalPrice': finalPrice,
      'itemCount': itemCount,
      'orderCreatedTime': orderCreatedTime?.millisecondsSinceEpoch,
      'orderAcceptedTime': orderAcceptedTime?.millisecondsSinceEpoch,
      'orderPackedTime': orderPackedTime?.millisecondsSinceEpoch,
      'orderOutForDeliveryTime':
          orderOutForDeliveryTime?.millisecondsSinceEpoch,
      'orderDeliveredTime': orderDeliveredTime?.millisecondsSinceEpoch,
      'orderCancelledTime': orderCancelledTime?.millisecondsSinceEpoch,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      collectionDocumentId: map['collectionDocumentId'] != null
          ? map['collectionDocumentId'] as String
          : null,
      createdUserId:
          map['createdUserId'] != null ? map['createdUserId'] as String : null,
      paymentMethod:
          map['paymentMethod'] != null ? map['paymentMethod'] as String : null,
      cartItems: map['cartItems'] != null
          ? (map['cartItems'] as List<dynamic>)
              .map<CartItemModel>(
                (x) => CartItemModel.fromMap(x),
              )
              .toList()
          : null,
      deliveryAddress: map['deliveryAddress'] != null
          ? AddressModel.fromMap(map['deliveryAddress'] as Map<String, dynamic>)
          : null,
      totalPrice:
          map['totalPrice'] != null ? map['totalPrice'] as double : null,
      deliveryPrice:
          map['deliveryPrice'] != null ? map['deliveryPrice'] as double : null,
      finalPrice:
          map['finalPrice'] != null ? map['finalPrice'] as double : null,
      itemCount: map['itemCount'] != null ? map['itemCount'] as int : null,
      orderCreatedTime: map['orderCreatedTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['orderCreatedTime'] as int)
          : null,
      orderAcceptedTime: map['orderAcceptedTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['orderAcceptedTime'] as int)
          : null,
      orderPackedTime: map['orderPackedTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['orderPackedTime'] as int)
          : null,
      orderOutForDeliveryTime: map['orderOutForDeliveryTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['orderOutForDeliveryTime'] as int)
          : null,
      orderDeliveredTime: map['orderDeliveredTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['orderDeliveredTime'] as int)
          : null,
      orderCancelledTime: map['orderCancelledTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              map['orderCancelledTime'] as int)
          : null,
    );
  }

  factory OrderModel.fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> query) {
    var map = query.data();
    return OrderModel.fromMap(map).copyWith(collectionDocumentId: query.id);
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  OrderModel copyWith({
    String? collectionDocumentId,
    String? createdUserId,
    String? paymentMethod,
    List<CartItemModel>? cartItems,
    AddressModel? deliveryAddress,
    double? totalPrice,
    double? deliveryPrice,
    double? finalPrice,
    int? itemCount,
    DateTime? orderCreatedTime,
    DateTime? orderAcceptedTime,
    DateTime? orderPackedTime,
    DateTime? orderOutForDeliveryTime,
    DateTime? orderDeliveredTime,
    DateTime? orderCancelledTime,
  }) {
    return OrderModel(
      collectionDocumentId: collectionDocumentId ?? this.collectionDocumentId,
      createdUserId: createdUserId ?? this.createdUserId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      cartItems: cartItems ?? this.cartItems,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      totalPrice: totalPrice ?? this.totalPrice,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      finalPrice: finalPrice ?? this.finalPrice,
      itemCount: itemCount ?? this.itemCount,
      orderCreatedTime: orderCreatedTime ?? this.orderCreatedTime,
      orderAcceptedTime: orderAcceptedTime ?? this.orderAcceptedTime,
      orderPackedTime: orderPackedTime ?? this.orderPackedTime,
      orderOutForDeliveryTime:
          orderOutForDeliveryTime ?? this.orderOutForDeliveryTime,
      orderDeliveredTime: orderDeliveredTime ?? this.orderDeliveredTime,
      orderCancelledTime: orderCancelledTime ?? this.orderCancelledTime,
    );
  }

  OrderStatus getOrderStatus() {
    if (orderCancelledTime != null) {
      return OrderStatus.orderCancelled;
    } else if (orderDeliveredTime != null) {
      return OrderStatus.orderDelivered;
    } else if (orderOutForDeliveryTime != null) {
      return OrderStatus.orderOutForDelivery;
    } else if (orderPackedTime != null) {
      return OrderStatus.orderPacked;
    } else if (orderAcceptedTime != null) {
      return OrderStatus.orderAccepted;
    } else if (orderCreatedTime != null) {
      return OrderStatus.orderCreated;
    }
    return OrderStatus.unknown;
  }
}
