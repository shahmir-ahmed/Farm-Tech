// To parse this JSON data, do
//
//     final sellerModel = sellerModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

SellerModel sellerModelFromJson(String str, String docId) =>
    SellerModel.fromJson(json.decode(str), docId);

String sellerModelToJson(SellerModel data) => json.encode(data.toJson());

class SellerModel {
  String? docId;
  String? name;
  String? email;
  String? contactNo;
  String? cnicNo;
  String? shopName;
  String? shopLocation;
  String? shopDescription;
  String? profileImageUrl;
  String? avgRating;
  String? totalReviews;
  String? deviceToken;
  Timestamp? createdAt;

  SellerModel({
    this.docId,
    this.name,
    this.email,
    this.contactNo,
    this.cnicNo,
    this.shopName,
    this.shopLocation,
    this.shopDescription,
    this.profileImageUrl,
    this.totalReviews,
    this.avgRating,
    this.deviceToken,
    this.createdAt,
  });

  // when recieving data from firestore so converting json data to model
  factory SellerModel.fromJson(Map<String, dynamic> json, String docId) =>
      SellerModel(
        docId: docId,
        name: json["name"],
        email: json["email"],
        contactNo: json["contactNo"],
        cnicNo: json["cnicNo"],
        shopName: json["shopName"],
        shopLocation: json["shopLocation"],
        shopDescription: json["shopDescription"],
        profileImageUrl: "",
        deviceToken: json["deviceToken"],
        createdAt: json["createdAt"],
      );

  // when sending data to firestore so model data to json
  Map<String, dynamic> toJson() => {
        // "docId": docId,
        "name": name,
        "email": email,
        "contactNo": contactNo,
        "cnicNo": cnicNo,
        "shopName": shopName,
        "shopLocation": shopLocation,
        "shopDescription": shopDescription,
        "deviceToken": deviceToken,
        "createdAt": DateTime.now(),
      };
}
