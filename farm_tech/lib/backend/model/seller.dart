// To parse this JSON data, do
//
//     final sellerModel = sellerModelFromJson(jsonString);

import 'dart:convert';

SellerModel sellerModelFromJson(String str) => SellerModel.fromJson(json.decode(str));

String sellerModelToJson(SellerModel data) => json.encode(data.toJson());

class SellerModel {
    String? docId;
    String? name;
    String? contactNo;
    String? cnicNo;
    String? shopName;
    String? shopLocation;
    String? shopDescription;
    String? profileImageUrl;

    SellerModel({
        this.docId,
        this.name,
        this.contactNo,
        this.cnicNo,
        this.shopName,
        this.shopLocation,
        this.shopDescription,
        this.profileImageUrl,
    });

    factory SellerModel.fromJson(Map<String, dynamic> json) => SellerModel(
        docId: json["id"],
        name: json["name"],
        contactNo: json["contactNo"],
        cnicNo: json["cnicNo"],
        shopName: json["shopName"],
        shopLocation: json["shopLocation"],
        shopDescription: json["shopDescription"],
    );

    Map<String, dynamic> toJson() => {
        // "docId": docId,
        "name": name,
        "contactNo": contactNo,
        "cnicNo": cnicNo,
        "shopName": shopName,
        "shopLocation": shopLocation,
        "shopDescription": shopDescription,
    };
}
