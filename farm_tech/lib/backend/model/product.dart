// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

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
    int? imagesCount;
    String? sellerId;

    ProductModel({
        this.docId,
        this.title,
        this.price,
        this.stockQuantity,
        this.minOrder,
        this.category,
        this.description,
        this.imagesCount,
        this.sellerId
    });

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        docId: json["docId"],
        title: json["title"],
        price: json["price"],
        stockQuantity: json["stockQuantity"],
        minOrder: json["minOrder"],
        category: json["category"],
        description: json["description"],
        imagesCount: json["imagesCount"],
        sellerId: json["sellerId"]
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "price": price,
        "stockQuantity": stockQuantity,
        "minOrder": minOrder,
        "category": category,
        "description": description,
        "imagesCount": imagesCount,
        "sellerId": sellerId
    };
}
