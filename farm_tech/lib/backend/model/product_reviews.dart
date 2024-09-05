// To parse this JSON data, do
//
//     final productReviewsModel = productReviewsModelFromJson(jsonString);

import 'dart:convert';

ProductReviewsModel productReviewsModelFromJson(String str) => ProductReviewsModel.fromJson(json.decode(str));

String productReviewsModelToJson(ProductReviewsModel data) => json.encode(data.toJson());

class ProductReviewsModel {
    String? avgRating;

    ProductReviewsModel({
        this.avgRating,
    });

    factory ProductReviewsModel.fromJson(Map<String, dynamic> json) => ProductReviewsModel(
        avgRating: json["avgRating"],
    );

    Map<String, dynamic> toJson() => {
        "avgRating": avgRating,
    };
}
