import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? collectionDocumentId;
  int? id;
  String? name;
  String? description;
  String? categoryId;
  double? price;
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
    this.price,
    this.rating,
    this.ratingCount,
    this.barcode,
    this.imageUrl,
  });

  factory ProductModel.fromQueryDocumentSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> e) {
    return ProductModel.fromMap(e.data()).copyWith(collectionDocumentId: e.id);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'categoryId': categoryId,
      'price': price,
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
      if (price != null) 'price': price,
      if (rating != null) 'rating': rating,
      if (ratingCount != null) 'ratingCount': ratingCount,
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
      price: map['price'] != null ? map['price'] as double : null,
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
    return 'ProductModel(collectionDocumentId: $collectionDocumentId, id: $id, name: $name, description: $description, categoryId: $categoryId, price: $price, rating: $rating, ratingCount: $ratingCount, barcode: $barcode, imageUrl: $imageUrl)';
  }

  ProductModel copyWith({
    String? collectionDocumentId,
    int? id,
    String? name,
    String? description,
    String? categoryId,
    double? price,
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
      price: price ?? this.price,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      barcode: barcode ?? this.barcode,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
