// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
    String? docId;
    String? title;
    int? price;
    int? stockQuantity;
    int? minOrder;
    String? category;
    String? description;
    List<String>? profileImageUrls;
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
        this.profileImageUrls,
        this.imagesCount,
        this.sellerId,
        this.createdAt,
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        // docId: json["docId"],
        title: json["title"],
        price: json["price"],
        stockQuantity: json["stockQuantity"],
        minOrder: json["minOrder"],
        category: json["category"],
        description: json["description"],
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
}
