// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ProductModel productModelFromJson(String str, String docId) =>
    ProductModel.fromJson(json.decode(str), docId);

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  String? docId;
  String? title;
  int? price;
  int? stockQuantity;
  int? minOrder;
  String? category;
  String? description;
  String? mainImageUrl;
  List<String>? imageUrls;
  int? imagesCount;
  String? sellerId;
  Timestamp? createdAt;

  ProductModel({
    this.docId,
    this.title,
    this.price,
    this.stockQuantity,
    this.minOrder,
    this.category,
    this.description,
    this.mainImageUrl,
    this.imageUrls,
    this.imagesCount,
    this.sellerId,
    this.createdAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json, String docId) =>
      ProductModel(
        docId: docId,
        title: json["title"],
        price: json["price"],
        stockQuantity: json["stockQuantity"],
        minOrder: json["minOrder"],
        category: json["category"],
        description: json["description"],
        mainImageUrl: "",
        imageUrls: [],
        imagesCount: json["imagesCount"],
        sellerId: json["sellerId"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "stockQuantity": stockQuantity,
        "minOrder": minOrder,
        "category": category,
        "description": description,
        "imagesCount": imagesCount,
        "sellerId": sellerId,
        "createdAt": Timestamp.now()
      };

  Map<String, dynamic> stockQuantityToJson() => {
        "stockQuantity": stockQuantity,
      };
}
