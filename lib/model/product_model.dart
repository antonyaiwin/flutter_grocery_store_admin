// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_grocery_store_admin/core/enum/unit_type.dart';

class ProductModel {
  String? collectionDocumentId;
  int? id;
  String? name;
  String? description;
  String? categoryId;
  double? priceMRP;
  double? priceSelling;
  double? quantity;
  UnitType? unitType;
  double? rating;
  int? ratingCount;
  String? barcode;
  List<String>? imageUrl;
  ProductModel({
    this.collectionDocumentId,
    this.id,
    this.name,
    this.description,
    this.categoryId,
    this.priceMRP,
    this.priceSelling,
    this.quantity,
    this.unitType,
    this.rating,
    this.ratingCount,
    this.barcode,
    this.imageUrl,
  });

  String getFormattedMRP() {
    if (priceMRP == null) {
      return '';
    }
    return _getFormattedNumber(priceMRP!);
  }

  String getFormattedSellingPrice() {
    if (priceSelling == null) {
      return '';
    }
    return _getFormattedNumber(priceSelling!);
  }

  String _getFormattedNumber(num number) {
    if (number % 1 == 0) {
      return number.toStringAsFixed(0);
    } else {
      return number.toStringAsFixed(1);
    }
  }

  String getFormattedQuantity() {
    if (quantity == null) {
      return '';
    } else {
      String qValue = _getFormattedQuantityValue();
      switch (unitType) {
        case UnitType.kilogram:
          if (quantity! < 1) {
            return '$qValue g';
          } else {
            return '$qValue Kg';
          }
        case UnitType.liter:
          if (quantity! < 1) {
            return '$qValue ml';
          } else {
            return '$qValue L';
          }
        case UnitType.unit:
          return '${quantity!.toStringAsFixed(0)} pc';
        default:
          return '';
      }
    }
  }

  String _getFormattedQuantityValue() {
    if (quantity! < 1) {
      return (quantity! * 1000).toStringAsFixed(0);
    } else if (quantity! % 1 == 0) {
      return quantity!.toStringAsFixed(0);
    } else {
      return quantity!.toStringAsFixed(1);
    }
  }

  String? getOffer() {
    if (priceMRP == null || priceSelling == null || priceMRP == priceSelling) {
      return null;
    }
    return '${_getFormattedNumber(((priceMRP! - priceSelling!) * 100) ~/ priceMRP!)}%\nOFF';
  }

  factory ProductModel.fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> ref) {
    return ProductModel.fromMap(ref.data())
        .copyWith(collectionDocumentId: ref.id);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'priceMRP': priceMRP,
      'sellingPrice': priceSelling,
      'quantity': quantity,
      'unitType': unitType?.name,
      'rating': rating,
      'ratingCount': ratingCount,
      'barcode': barcode,
      'imageUrl': imageUrl,
    };
  }

  Map<String, dynamic> toMapWithoutNull() {
    return <String, dynamic>{
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (categoryId != null) 'categoryId': categoryId,
      if (priceMRP != null) 'priceMRP': priceMRP,
      if (priceSelling != null) 'sellingPrice': priceSelling,
      if (quantity != null) 'quantity': quantity,
      if (unitType != null) 'unitType': unitType?.name,
      // if (rating != null) 'rating': rating,
      // if (ratingCount != null) 'ratingCount': ratingCount,
      if (barcode != null) 'barcode': barcode,
      if (imageUrl != null) 'imageUrl': imageUrl,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      categoryId:
          map['categoryId'] != null ? map['categoryId'] as String : null,
      priceMRP: map['priceMRP'] != null ? map['priceMRP'] as double : null,
      priceSelling:
          map['sellingPrice'] != null ? map['sellingPrice'] as double : null,
      quantity: map['quantity'] != null ? map['quantity'] as double : null,
      unitType: map['unitType'] != null
          ? UnitType.values.byName(map['unitType'])
          : null,
      rating: map['rating'] != null ? map['rating'] as double : null,
      ratingCount:
          map['ratingCount'] != null ? map['ratingCount'] as int : null,
      barcode: map['barcode'] != null ? map['barcode'] as String : null,
      imageUrl:
          map['imageUrl'] != null ? List<String>.from((map['imageUrl'])) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(collectionDocumentId: $collectionDocumentId, id: $id, name: $name, description: $description, categoryId: $categoryId, priceMRP: $priceMRP, sellingPrice: $priceSelling, quantity: $quantity, unitType: $unitType, rating: $rating, ratingCount: $ratingCount, barcode: $barcode, imageUrl: $imageUrl)';
  }

  ProductModel copyWith({
    String? collectionDocumentId,
    int? id,
    String? name,
    String? description,
    String? categoryId,
    double? priceMRP,
    double? sellingPrice,
    double? quantity,
    UnitType? unitType,
    double? rating,
    int? ratingCount,
    String? barcode,
    List<String>? imageUrl,
  }) {
    return ProductModel(
      collectionDocumentId: collectionDocumentId ?? this.collectionDocumentId,
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      priceMRP: priceMRP ?? this.priceMRP,
      priceSelling: sellingPrice ?? this.priceSelling,
      quantity: quantity ?? this.quantity,
      unitType: unitType ?? this.unitType,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      barcode: barcode ?? this.barcode,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
