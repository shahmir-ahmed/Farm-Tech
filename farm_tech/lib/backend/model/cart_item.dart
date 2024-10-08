// To parse this JSON data, do
//
//     final cartItemModel = cartItemModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

CartItemModel cartItemModelFromJson(String str, String docId) =>
    CartItemModel.fromJson(json.decode(str), docId);

String cartItemModelToJson(CartItemModel data) => json.encode(data.toJson());

class CartItemModel {
  String? docId;
  String? quantity;
  String? total;
  String? productId;
  String? buyerId;
  Timestamp? createdAt;

  CartItemModel({
    this.docId,
    this.quantity,
    this.total,
    this.productId,
    this.buyerId,
    this.createdAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json, String docId) =>
      CartItemModel(
        docId: docId,
        quantity: json["quantity"],
        total: json["total"],
        productId: json["productId"],
        buyerId: json["buyerId"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "total": total,
        "productId": productId,
        "buyerId": buyerId,
        "createdAt": createdAt ?? Timestamp.now(),
      };
}
