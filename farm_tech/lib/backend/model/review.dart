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
  int? starsCount;
  String? reviewById;
  String? productId; //HGusmi3IPJ7eWjOdCdFj, b6JvxqwDQSYv6KcfZoLs
  String? sellerId;
  Timestamp? createdAt;

  ReviewModel({
    this.docId,
    this.review,
    this.starsCount,
    this.reviewById,
    this.productId,
    this.sellerId,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json, String docId) =>
      ReviewModel(
        docId: docId,
        review: json["review"],
        starsCount: json["starsCount"],
        reviewById: json["reviewById"],
        productId: json["productId"],
        sellerId: json["sellerId"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "review": review,
        "starsCount": starsCount,
        "reviewById": reviewById,
        "productId": productId,
        "sellerId": sellerId,
        "createdAt": createdAt,
      };
}
