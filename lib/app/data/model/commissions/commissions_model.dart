// lib/models/commission.dart
class CommissionResponse {
  final bool status;
  final double totalSuccessAmount;
  final List<Commission> commissions;

  CommissionResponse({
    required this.status,
    required this.totalSuccessAmount,
    required this.commissions,
  });

  factory CommissionResponse.fromJson(Map<String, dynamic> json) {
    return CommissionResponse(
      status: json['status'] ?? false,
      totalSuccessAmount: (json['totalSuccessAmount'] ?? 0.0).toDouble(),
      commissions: (json['commissions'] as List<dynamic>?)
          ?.map((e) => Commission.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class Commission {
  final int commissionId;
  final int userId;
  final double amount;
  final String status;
  final String generatedDate;
  final String referredUserName;

  Commission({
    required this.commissionId,
    required this.userId,
    required this.amount,
    required this.status,
    required this.generatedDate,
    required this.referredUserName,
  });

  factory Commission.fromJson(Map<String, dynamic> json) {
    return Commission(
      commissionId: json['CommissionID'] ?? 0,
      userId: json['UserID'] ?? 0,
      amount: (json['Amount'] ?? 0.0).toDouble(),
      status: json['Status'] ?? '',
      generatedDate: json['GeneratedDate'] ?? '',
      referredUserName: json['ReferredUserName'] ?? '',
    );
  }
}