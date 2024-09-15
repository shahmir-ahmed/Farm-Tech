// To parse this JSON data, do
//
//     final reviewModel = reviewModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

ReviewModel reviewModelFromJson(String str, String docId) =>
    ReviewModel.fromJson(json.decode(str), docId);

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  String? docId;
  String? review;
  String? starsCount;
  String? buyerId;
  String? productId; //HGusmi3IPJ7eWjOdCdFj, b6JvxqwDQSYv6KcfZoLs
  String? sellerId;
  String? orderId; // to uniquely identify a buyer's review for an order
  Timestamp? createdAt;

  ReviewModel({
    this.docId,
    this.review,
    this.starsCount,
    this.buyerId,
    this.productId,
    this.sellerId,
    this.orderId,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json, String docId) =>
      ReviewModel(
        docId: docId,
        review: json["review"],
        starsCount: json["starsCount"],
        buyerId: json["buyerId"],
        productId: json["productId"],
        sellerId: json["sellerId"],
        orderId: json["orderId"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "review": review,
        "starsCount": starsCount,
        "buyerId": buyerId,
        "productId": productId,
        "sellerId": sellerId,
        "orderId": orderId,
        "createdAt": createdAt ?? Timestamp.now(),
      };
}
