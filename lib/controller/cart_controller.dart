import 'package:flutter/material.dart';

import '../model/cart_item_model.dart';
import '../model/product_model.dart';

class CartController extends ChangeNotifier {
  final List<CartItemModel> _cartItemList = [];

  List<CartItemModel> get cartItemList => _cartItemList;
  addItemToCart(ProductModel item) {
    for (var element in _cartItemList) {
      if (element.product.id == item.id) {
        element.quantity++;
        notifyListeners();
        return;
      }
    }
    _cartItemList.add(CartItemModel(product: item));
    notifyListeners();
  }

  removeItemFromCart(ProductModel item) {
    for (var element in _cartItemList) {
      if (element.product.id == item.id) {
        if (element.quantity <= 1) {
          _cartItemList.remove(element);
        } else {
          element.quantity--;
        }
        notifyListeners();
        return;
      }
    }
    notifyListeners();
  }

  deleteItemFromCart(ProductModel productModel) {
    _cartItemList
        .removeWhere((element) => element.product.id == productModel.id);
    notifyListeners();
  }

// clear all the items in cart
  clearItems() {
    _cartItemList.clear();
    notifyListeners();
  }

  // total items count in cart
  int get totalCartCount => _cartItemList.fold(
      0, (previousValue, element) => previousValue += element.quantity);

  // returns total price of all items in the cart
  double get totalCartPrice => _cartItemList.fold(
      0.0,
      (previousValue, element) =>
          previousValue += (element.product.price ?? 0) * element.quantity);

  int getItemCount(int id) {
    for (var element in _cartItemList) {
      if (element.product.id == id) {
        return element.quantity;
      }
    }
    return 0;
  }
}
