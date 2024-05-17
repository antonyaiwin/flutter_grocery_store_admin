import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_grocery_store_admin/utils/global_widgets/base_keep_alive_page.dart';
import 'package:flutter_grocery_store_admin/view/home_screen/pages/cart_page.dart';
import 'package:flutter_grocery_store_admin/view/home_screen/pages/category_page.dart';
import 'package:flutter_grocery_store_admin/view/home_screen/pages/home_page.dart';
import 'package:flutter_grocery_store_admin/view/home_screen/pages/my_list_page.dart';

class HomeScreenController extends ChangeNotifier {
  PageController pageController = PageController();
  List<Widget> pageList = [
    const BaseKeepAlivePage(child: HomePage()),
    const BaseKeepAlivePage(child: CategoryPage()),
    const BaseKeepAlivePage(child: MyListPage()),
    const BaseKeepAlivePage(child: CartPage()),
  ];
  int selectedPageIndex = 0;

  setSelecetedPageIndex(int index) {
    if (selectedPageIndex != index) {
      selectedPageIndex = index;
      pageController.jumpToPage(
        selectedPageIndex,
      );
      notifyListeners();
    }
  }
}
