// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    final String? docId;
    final String? name;
    final String? email;
    final String? contactNo;

    UserModel({
        this.docId,
        this.name,
        this.email,
        this.contactNo,
    });

    // from json to user model for using in app
    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        docId: json["id"],
        name: json["name"],
        email: json["email"],
        contactNo: json["contactNo"],
    );

    // user model to json for storing in firestore
    Map<String, dynamic> toJson() => {
        // "docID": userID,
        "name": name,
        "email": email,
        "contactNo": contactNo,
    };
}
