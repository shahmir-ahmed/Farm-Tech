// To parse this JSON data, do
//
//     final buyerModel = buyerModelFromJson(jsonString);

import 'dart:convert';

BuyerModel buyerModelFromJson(String str, String docId) => BuyerModel.fromJson(json.decode(str), docId);

String buyerModelToJson(BuyerModel data) => json.encode(data.toJson());

class BuyerModel {
    String? docId;
    String? name;
    String? contactNo;

    BuyerModel({
        this.docId,
        this.name,
        this.contactNo,
    });

    factory BuyerModel.fromJson(Map<String, dynamic> json, String docId) => BuyerModel(
        docId: docId,
        name: json["name"],
        contactNo: json["contactNo"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "contactNo": contactNo,
    };
}
