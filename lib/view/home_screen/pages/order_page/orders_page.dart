import 'package:flutter/material.dart';
import 'package:flutter_grocery_store_admin/controller/order/orders_controller.dart';
import 'package:flutter_grocery_store_admin/view/home_screen/pages/order_page/widgets/order_item_card.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'New Orders',
              ),
              Tab(
                text: 'Past Orders',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ActiveOrdersColumn(),
            PastOrdersColumn(),
          ],
        ),
      ),
    );
  }
}

class ActiveOrdersColumn extends StatelessWidget {
  const ActiveOrdersColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<OrdersController>(
          builder: (BuildContext context, value, Widget? child) {
            if (value.activeOrderList.isEmpty) {
              return const Expanded(
                child: Center(
                  child: Text('No active orders'),
                ),
              );
            }
            return Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  var order = value.activeOrderList[index];
                  return OrderItemCard(
                    orderSnap: order,
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: value.activeOrderList.length,
              ),
            );
          },
        ),
      ],
    );
  }
}

class PastOrdersColumn extends StatelessWidget {
  const PastOrdersColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Consumer<OrdersController>(
          builder: (BuildContext context, value, Widget? child) {
            if (value.pastOrderList.isEmpty) {
              return const Expanded(
                child: Center(
                  child: Text('No active orders'),
                ),
              );
            }
            return Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  var order = value.pastOrderList[index];
                  return OrderItemCard(orderSnap: order);
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemCount: value.pastOrderList.length,
              ),
            );
          },
        ),
      ],
    );
  }
}
