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
    final Summary? summary;

    WithdrawalTransactionModel({
        this.status,
        this.message,
        this.data,
        this.summary,
    });

    WithdrawalTransactionModel copyWith({
        bool? status,
        String? message,
        List<WithdrawalTransaction>? data,
        Summary? summary,
    }) => 
        WithdrawalTransactionModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
            summary: summary ?? this.summary,
        );

    factory WithdrawalTransactionModel.fromJson(Map<String, dynamic> json) => WithdrawalTransactionModel(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? [] : List<WithdrawalTransaction>.from(json["data"]!.map((x) => WithdrawalTransaction.fromJson(x))),
        summary: json["summary"] == null ? null : Summary.fromJson(json["summary"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "summary": summary?.toJson(),
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

class Summary {
    final double? availableBalance;
    final double? rejectedAmount;
    final double? totalWithdrawalAmount;
    final double? totalWithdrawlAmountInPendingRequest;
    final int? totalDebitSuccessCount;
    final int? totalDebitPendingCount;
    final int? totalDebitCount;

    Summary({
        this.availableBalance,
        this.rejectedAmount,
        this.totalWithdrawalAmount,
        this.totalWithdrawlAmountInPendingRequest,
        this.totalDebitSuccessCount,
        this.totalDebitPendingCount,
        this.totalDebitCount,
    });

    Summary copyWith({
        double? availableBalance,
        double? rejectedAmount,
        double? totalWithdrawalAmount,
        double? totalWithdrawlAmountInPendingRequest,
        int? totalDebitSuccessCount,
        int? totalDebitPendingCount,
        int? totalDebitCount,
    }) => 
        Summary(
            availableBalance: availableBalance ?? this.availableBalance,
            rejectedAmount: rejectedAmount ?? this.rejectedAmount,
            totalWithdrawalAmount: totalWithdrawalAmount ?? this.totalWithdrawalAmount,
            totalWithdrawlAmountInPendingRequest: totalWithdrawlAmountInPendingRequest ?? this.totalWithdrawlAmountInPendingRequest,
            totalDebitSuccessCount: totalDebitSuccessCount ?? this.totalDebitSuccessCount,
            totalDebitPendingCount: totalDebitPendingCount ?? this.totalDebitPendingCount,
            totalDebitCount: totalDebitCount ?? this.totalDebitCount,
        );

    factory Summary.fromJson(Map<String, dynamic> json) => Summary(
        availableBalance: json["AvailableBalance"]?.toDouble(),
        rejectedAmount: json["RejectedAmount"]?.toDouble(),
        totalWithdrawalAmount: json["TotalWithdrawalAmount"]?.toDouble(),
        totalWithdrawlAmountInPendingRequest: json["Total_Withdrawl_Amount_in_Pending_request"]?.toDouble(),
        totalDebitSuccessCount: json["TotalDebitSuccessCount"],
        totalDebitPendingCount: json["TotalDebitPendingCount"],
        totalDebitCount: json["TotalDebitCount"],
    );

    Map<String, dynamic> toJson() => {
        "AvailableBalance": availableBalance,
        "RejectedAmount": rejectedAmount,
        "TotalWithdrawalAmount": totalWithdrawalAmount,
        "Total_Withdrawl_Amount_in_Pending_request": totalWithdrawlAmountInPendingRequest,
        "TotalDebitSuccessCount": totalDebitSuccessCount,
        "TotalDebitPendingCount": totalDebitPendingCount,
        "TotalDebitCount": totalDebitCount,
    };
}
