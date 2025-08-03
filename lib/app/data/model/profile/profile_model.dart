// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

ProfileModel profileModelFromJson(String str) => ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  final int? statusCode;
  final String? message;
  final ProfileData? data;

  ProfileModel({this.statusCode, this.message, this.data});

  ProfileModel copyWith({int? statusCode, String? message, ProfileData? data}) => ProfileModel(
    statusCode: statusCode ?? this.statusCode,
    message: message ?? this.message,
    data: data ?? this.data,
  );

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    statusCode: json["StatusCode"],
    message: json["Message"],
    data: json["Data"] == null ? null : ProfileData.fromJson(json["Data"]),
  );

  Map<String, dynamic> toJson() => {"StatusCode": statusCode, "Message": message, "Data": data?.toJson()};
}

class ProfileData {
  final int? userId;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? passwordHash;
  final String? languagePreference;
  final bool? isVerified;
  final DateTime? createdAt;
  final int? referredByUserId;
  final String? referredByName;

  ProfileData({
    this.userId,
    this.fullName,
    this.email,
    this.phone,
    this.passwordHash,
    this.languagePreference,
    this.isVerified,
    this.createdAt,
    this.referredByUserId,
    this.referredByName,
  });

  ProfileData copyWith({
    int? userId,
    String? fullName,
    String? email,
    String? phone,
    String? passwordHash,
    String? languagePreference,
    bool? isVerified,
    DateTime? createdAt,
    int? referredByUserId,
    String? referredByName,
  }) => ProfileData(
    userId: userId ?? this.userId,
    fullName: fullName ?? this.fullName,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    passwordHash: passwordHash ?? this.passwordHash,
    languagePreference: languagePreference ?? this.languagePreference,
    isVerified: isVerified ?? this.isVerified,
    createdAt: createdAt ?? this.createdAt,
    referredByUserId: referredByUserId ?? this.referredByUserId,
    referredByName: referredByName ?? this.referredByName,
  );

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
    userId: json["UserID"],
    fullName: json["FullName"],
    email: json["Email"],
    phone: json["Phone"],
    passwordHash: json["PasswordHash"],
    languagePreference: json["LanguagePreference"],
    isVerified: json["IsVerified"],
    createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
    referredByUserId: json["ReferredByUserID"],
    referredByName: json["ReferredByName"],
  );

  Map<String, dynamic> toJson() => {
    "UserID": userId,
    "FullName": fullName,
    "Email": email,
    "Phone": phone,
    "PasswordHash": passwordHash,
    "LanguagePreference": languagePreference,
    "IsVerified": isVerified,
    "CreatedAt": createdAt?.toIso8601String(),
    "ReferredByUserID": referredByUserId,
    "ReferredByName": referredByName,
  };
}
