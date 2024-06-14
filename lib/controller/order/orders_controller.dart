import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/core/constants/color_constants.dart';

import 'package:flutter_grocery_store_admin/model/order_model.dart';
import 'package:flutter_grocery_store_admin/service/navigation_service.dart';
import 'package:flutter_grocery_store_admin/utils/functions/widget_route_functions.dart';
import 'package:flutter_grocery_store_admin/view/home_screen/pages/order_page/widgets/order_item_card.dart';
import 'package:provider/provider.dart';

class OrdersController extends ChangeNotifier {
  static const String _ordersCollectionName = 'orders';
  var db = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot<OrderModel>> activeOrderList = [];
  List<QueryDocumentSnapshot<OrderModel>> pastOrderList = [];
  List<QueryDocumentSnapshot<OrderModel>> newOrderList = [];

  OrdersController() {
    _initActiveOrdersListener();
    _initPastOrdersListener();
  }

  CollectionReference<OrderModel> get ordersCollection {
    return db.collection(_ordersCollectionName).withConverter(
          fromFirestore: (snapshot, options) =>
              OrderModel.fromMap(snapshot.data() ?? {}),
          toFirestore: (value, options) => value.toMap(),
        );
  }

  _initActiveOrdersListener() {
    ordersCollection
        .orderBy('orderCreatedTime', descending: true)
        .where(
          // Filter.and(
          Filter.or(
            Filter('orderAcceptedTime', isNull: true),
            Filter('orderPackedTime', isNull: true),
            Filter('orderOutForDeliveryTime', isNull: true),
            Filter.and(
              Filter('orderDeliveredTime', isNull: true),
              Filter('orderCancelledTime', isNull: true),
            ),
            // ),
            // Filter('orderDeniedTime', isNull: false),
          ),
        )
        .snapshots()
        .listen((event) {
      activeOrderList = event.docs;
      notifyListeners();
      loadNewOrders();
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

  loadNewOrders() {
    var newList = activeOrderList
        .where((element) => element.data().orderAcceptedTime == null)
        .toList();

    List<String> newOrdersIdList = newOrderList.map((e) => e.id).toList();
    bool hasNewOrder = false;
    for (var element in newList) {
      if (!newOrdersIdList.contains(element.id)) {
        hasNewOrder = true;
        break;
      }
    }
    notifyListeners();
    newOrderList = newList;
    if (newOrderList.isNotEmpty && hasNewOrder) {
      showMyModalBottomSheet(
        context: NavigationService.navigatorKey.currentContext!,
        builder: (context, scrollController) =>
            const NewOrdersBottomSheetBody(),
      );
    }
  }
}

class NewOrdersBottomSheetBody extends StatelessWidget {
  const NewOrdersBottomSheetBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: ColorConstants.primaryWhite,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            'New Orders',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Divider(),
          Expanded(child: Consumer<OrdersController>(
            builder:
                (BuildContext context, OrdersController value, Widget? child) {
              return ListView.separated(
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  var order = value.newOrderList[index];
                  return OrderItemCard(orderSnap: order);
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: value.newOrderList.length,
              );
            },
          ))
        ],
      ),
    );
  }
}
