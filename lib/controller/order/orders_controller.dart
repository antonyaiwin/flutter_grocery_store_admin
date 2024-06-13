import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_grocery_store_admin/model/order_model.dart';

class OrdersController extends ChangeNotifier {
  static const String _ordersCollectionName = 'orders';
  var db = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot<OrderModel>> activeOrderList = [];
  List<QueryDocumentSnapshot<OrderModel>> pastOrderList = [];
  final BuildContext context;

  OrdersController(this.context) {
    _initActiveOrdersListener();
    _initPastOrdersListener();
  }

  CollectionReference<OrderModel> get ordersCollection {
    return db.collection(_ordersCollectionName).withConverter(
          fromFirestore: (snapshot, options) =>
              OrderModel.fromMap(snapshot.data() ?? {}).copyWith(
            collectionDocumentId: snapshot.id,
          ),
          toFirestore: (value, options) => value.toMap(),
        );
  }

  _initActiveOrdersListener() {
    ordersCollection
        .orderBy('orderCreatedTime', descending: true)
        .where(
          Filter.or(
            Filter('orderAcceptedTime', isNull: true),
            Filter('orderPackedTime', isNull: true),
            Filter('orderOutForDeliveryTime', isNull: true),
            Filter.and(
              Filter('orderDeliveredTime', isNull: true),
              Filter('orderCancelledTime', isNull: true),
            ),
          ),
        )
        .snapshots()
        .listen((event) {
      activeOrderList = event.docs;
      notifyListeners();
    });
  }

  _initPastOrdersListener() {
    ordersCollection
        .orderBy('orderCreatedTime', descending: true)
        .where(
          Filter.and(
            Filter('orderAcceptedTime', isGreaterThan: 0),
            Filter('orderPackedTime', isGreaterThan: 0),
            Filter('orderOutForDeliveryTime', isGreaterThan: 0),
            Filter.or(
              Filter('orderDeliveredTime', isGreaterThan: 0),
              Filter('orderCancelledTime', isGreaterThan: 0),
            ),
          ),
        )
        .snapshots()
        .listen((event) {
      pastOrderList = event.docs;
      notifyListeners();
    });
  }
}
