// To parse this JSON data, do
//
//     final recentSearchModel = recentSearchModelFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

RecentSearchModel recentSearchModelFromJson(String str, String docId) =>
    RecentSearchModel.fromJson(json.decode(str), docId);

String recentSearchModelToJson(RecentSearchModel data) =>
    json.encode(data.toJson());

class RecentSearchModel {
  String? docId;
  String? searchText;
  String? buyerId;
  Timestamp? createdAt;

  RecentSearchModel(
      {this.docId, this.searchText, this.buyerId, this.createdAt});

  factory RecentSearchModel.fromJson(Map<String, dynamic> json, String docId) =>
      RecentSearchModel(
          docId: docId,
          searchText: json["searchText"],
          buyerId: json["buyerId"],
          createdAt: json["createdAt"]);

  Map<String, dynamic> toJson() => {
        "searchText": searchText,
        "buyerId": buyerId,
        "createdAt": Timestamp.now()
      };
}
