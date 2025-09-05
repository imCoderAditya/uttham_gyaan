// To parse this JSON data, do
//
//     final withdrawalTransactionModel = withdrawalTransactionModelFromJson(jsonString);

import 'dart:convert';

WithdrawalTransactionModel withdrawalTransactionModelFromJson(String str) => WithdrawalTransactionModel.fromJson(json.decode(str));

String withdrawalTransactionModelToJson(WithdrawalTransactionModel data) => json.encode(data.toJson());

class WithdrawalTransactionModel {
    final bool? status;
    final String? message;
    final List<WithdrawalTransaction>? data;

    WithdrawalTransactionModel({
        this.status,
        this.message,
        this.data,
    });

    WithdrawalTransactionModel copyWith({
        bool? status,
        String? message,
        List<WithdrawalTransaction>? data,
    }) => 
        WithdrawalTransactionModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory WithdrawalTransactionModel.fromJson(Map<String, dynamic> json) => WithdrawalTransactionModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<WithdrawalTransaction>.from(json["data"]!.map((x) => WithdrawalTransaction.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class WithdrawalTransaction {
    final int? walletId;
    final int? userId;
    final String? transactionType;
    final double? amount;
    final String? description;
    final String? createdAt;
    final String? status;

    WithdrawalTransaction({
        this.walletId,
        this.userId,
        this.transactionType,
        this.amount,
        this.description,
        this.createdAt,
        this.status,
    });

    WithdrawalTransaction copyWith({
        int? walletId,
        int? userId,
        String? transactionType,
        double? amount,
        String? description,
        String? createdAt,
        String? status,
    }) => 
        WithdrawalTransaction(
            walletId: walletId ?? this.walletId,
            userId: userId ?? this.userId,
            transactionType: transactionType ?? this.transactionType,
            amount: amount ?? this.amount,
            description: description ?? this.description,
            createdAt: createdAt ?? this.createdAt,
            status: status ?? this.status,
        );

    factory WithdrawalTransaction.fromJson(Map<String, dynamic> json) => WithdrawalTransaction(
        walletId: json["WalletID"],
        userId: json["UserID"],
        transactionType: json["TransactionType"],
        amount: json["Amount"]?.toDouble(),
        description: json["Description"],
        createdAt: json["CreatedAt"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "WalletID": walletId,
        "UserID": userId,
        "TransactionType": transactionType,
        "Amount": amount,
        "Description": description,
        "CreatedAt": createdAt,
        "status": status,
    };
}
