// To parse this JSON data, do
//
//     final sellerReviewsModel = sellerReviewsModelFromJson(jsonString);

import 'dart:convert';

SellerReviewsModel sellerReviewsModelFromJson(String str) => SellerReviewsModel.fromJson(json.decode(str));

String sellerReviewsModelToJson(SellerReviewsModel data) => json.encode(data.toJson());

class SellerReviewsModel {
    String? totalReviewsCount;
    String? avgRating;

    SellerReviewsModel({
        this.totalReviewsCount,
        this.avgRating,
    });

    factory SellerReviewsModel.fromJson(Map<String, dynamic> json) => SellerReviewsModel(
        totalReviewsCount: json["totalReviewsCount"],
        avgRating: json["avgRating"],
    );

    Map<String, dynamic> toJson() => {
        "totalReviewsCount": totalReviewsCount,
        "avgRating": avgRating,
    };
}
