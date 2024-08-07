// To parse this JSON data, do
//
//     final orderModel = orderModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

OrderModel orderModelFromJson(String str, String docId) =>
    OrderModel.fromJson(json.decode(str), docId);

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  String? docId;
  String? quantity;
  String? totalAmount;
  String? status;
  String? productId;
  String? customerId;
  String? sellerId;
  Timestamp? createdAt;

  OrderModel(
      {this.docId,
      this.quantity,
      this.totalAmount,
      this.status,
      this.productId,
      this.customerId,
      this.sellerId,
      this.createdAt});

  factory OrderModel.fromJson(Map<String, dynamic> json, String docId) =>
      OrderModel(
        docId: docId,
        quantity: json["quantity"],
        totalAmount: json["totalAmount"],
        status: json["status"],
        productId: json["productId"],
        customerId: json["customerId"],
        sellerId: json["sellerId"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "totalAmount": totalAmount,
        "status": status,
        "productId": productId,
        "customerId": customerId,
        "sellerId": sellerId,
        "createdAt": createdAt != null
            ? createdAt!.toString()
            : Timestamp.now(),
      };
}
