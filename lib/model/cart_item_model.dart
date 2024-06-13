import 'package:flutter_grocery_store_admin/model/product_model.dart';

import 'dart:convert';

class CartItemModel {
  int quantity;
  ProductModel product;
  CartItemModel({
    this.quantity = 1,
    required this.product,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'quantity': quantity,
      'product': product.toMap(),
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      quantity: map['quantity'] as int,
      product: ProductModel.fromMap(map['product'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CartItemModel.fromJson(String source) =>
      CartItemModel.fromMap(json.decode(source) as Map<String, dynamic>);

  CartItemModel copyWith({
    int? quantity,
    ProductModel? product,
  }) {
    return CartItemModel(
      quantity: quantity ?? this.quantity,
      product: product ?? this.product,
    );
  }
}
