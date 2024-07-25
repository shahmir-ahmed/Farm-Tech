// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

class UserModel {
  final String? uId;
  final String? email;
  final String? password;

  UserModel({
    this.uId,
    this.email,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        uId: json["uId"],
        email: json["email"],
        password: json["password"],
      );
}
