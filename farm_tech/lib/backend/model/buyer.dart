// To parse this JSON data, do
//
//     final buyerModel = buyerModelFromJson(jsonString);

import 'dart:convert';

BuyerModel buyerModelFromJson(String str, String docId) => BuyerModel.fromJson(json.decode(str), docId);

String buyerModelToJson(BuyerModel data) => json.encode(data.toJson());

class BuyerModel {
    String? docId;
    String? name;
    String? email;
    String? contactNo;
    String? address;
    String? profileImageUrl;

    BuyerModel({
        this.docId,
        this.name,
        this.email,
        this.contactNo,
        this.address,
        this.profileImageUrl
    });

    factory BuyerModel.fromJson(Map<String, dynamic> json, String docId) => BuyerModel(
        docId: docId,
        name: json["name"],
        email: json["email"],
        contactNo: json["contactNo"],
        address: json["address"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "contactNo": contactNo,
        "address": address,
    };

    Map<String, dynamic> addressToJson() => {
        "address": address,
    };
}
