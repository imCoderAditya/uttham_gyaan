// To parse this JSON data, do
//
//     final walletModel = walletModelFromJson(jsonString);

import 'dart:convert';

WalletModel walletModelFromJson(String str) => WalletModel.fromJson(json.decode(str));

String walletModelToJson(WalletModel data) => json.encode(data.toJson());

class WalletModel {
    final bool? status;
    final String? message;
    final WalletData? data;

    WalletModel({
        this.status,
        this.message,
        this.data,
    });

    WalletModel copyWith({
        bool? status,
        String? message,
        WalletData? data,
    }) => 
        WalletModel(
            status: status ?? this.status,
            message: message ?? this.message,
            data: data ?? this.data,
        );

    factory WalletModel.fromJson(Map<String, dynamic> json) => WalletModel(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null ? null : WalletData.fromJson(json["Data"]),
    );

    Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data?.toJson(),
    };
}

class WalletData {
    final String? fullName;
    final int? totalPayments;
    final double? totalSpent;
    final int? coursesEnrolled;
    final int? totalReferrals;
    final int? convertedReferrals;
    final double? totalCommissionEarned;
    final double? debitedcommission;
    final double? availableBalance;
    final double? pendingCommission;
    final double? rejectedCommission;

    WalletData({
        this.fullName,
        this.totalPayments,
        this.totalSpent,
        this.coursesEnrolled,
        this.totalReferrals,
        this.convertedReferrals,
        this.totalCommissionEarned,
        this.debitedcommission,
        this.availableBalance,
        this.pendingCommission,
        this.rejectedCommission,
    });

    WalletData copyWith({
        String? fullName,
        int? totalPayments,
        double? totalSpent,
        int? coursesEnrolled,
        int? totalReferrals,
        int? convertedReferrals,
        double? totalCommissionEarned,
        double? debitedcommission,
        double? availableBalance,
        double? pendingCommission,
        double? rejectedCommission,
    }) => 
        WalletData(
            fullName: fullName ?? this.fullName,
            totalPayments: totalPayments ?? this.totalPayments,
            totalSpent: totalSpent ?? this.totalSpent,
            coursesEnrolled: coursesEnrolled ?? this.coursesEnrolled,
            totalReferrals: totalReferrals ?? this.totalReferrals,
            convertedReferrals: convertedReferrals ?? this.convertedReferrals,
            totalCommissionEarned: totalCommissionEarned ?? this.totalCommissionEarned,
            debitedcommission: debitedcommission ?? this.debitedcommission,
            availableBalance: availableBalance ?? this.availableBalance,
            pendingCommission: pendingCommission ?? this.pendingCommission,
            rejectedCommission: rejectedCommission ?? this.rejectedCommission,
        );

    factory WalletData.fromJson(Map<String, dynamic> json) => WalletData(
        fullName: json["FullName"],
        totalPayments: json["TotalPayments"],
        totalSpent: json["TotalSpent"]?.toDouble(),
        coursesEnrolled: json["CoursesEnrolled"],
        totalReferrals: json["TotalReferrals"],
        convertedReferrals: json["ConvertedReferrals"],
        totalCommissionEarned: json["TotalCommissionEarned"]?.toDouble(),
        debitedcommission: json["Debitedcommission"]?.toDouble(),
        availableBalance: json["AvailableBalance"]?.toDouble(),
        pendingCommission: json["PendingCommission"]?.toDouble(),
        rejectedCommission: json["RejectedCommission"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "FullName": fullName,
        "TotalPayments": totalPayments,
        "TotalSpent": totalSpent,
        "CoursesEnrolled": coursesEnrolled,
        "TotalReferrals": totalReferrals,
        "ConvertedReferrals": convertedReferrals,
        "TotalCommissionEarned": totalCommissionEarned,
        "Debitedcommission": debitedcommission,
        "AvailableBalance": availableBalance,
        "PendingCommission": pendingCommission,
        "RejectedCommission": rejectedCommission,
    };
}
