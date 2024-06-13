import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controller/screens/add_product_screen_controller.dart';
import '../../../controller/screens/home_screen_controller.dart';
import '../../add_product_screen/add_product_screen.dart';

class HomeBottomNavBar extends StatelessWidget {
  const HomeBottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeScreenController>(
      builder: (BuildContext context, controller, Widget? child) =>
          BottomNavigationBar(
        currentIndex: controller.selectedPageIndex,
        onTap: (value) {
          if (value == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                  create: (BuildContext context) =>
                      AddProductScreenController(),
                  child: const AddProductScreen(),
                ),
              ),
            );
          } else {
            controller.setSelecetedPageIndex(value);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_outlined),
            activeIcon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.category),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
