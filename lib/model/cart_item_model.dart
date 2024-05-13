import 'package:flutter_grocery_store_admin/model/product_model.dart';

class CartItemModel {
  int quantity;
  ProductModel product;
  CartItemModel({
    this.quantity = 1,
    required this.product,
  });
}
