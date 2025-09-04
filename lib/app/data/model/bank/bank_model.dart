class BankModel {
  final int bankDetailId;
  final int userId;
  final String accountHolderName;
  final String accountNumber;
  final String ifscCode;
  final String bankName;
  final String upiId;
  final String phonePe;
  final String googlePay;
  final String paytm;
  final String createdDate;
  final String updatedDate;

  BankModel({
    required this.bankDetailId,
    required this.userId,
    required this.accountHolderName,
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    required this.upiId,
    required this.phonePe,
    required this.googlePay,
    required this.paytm,
    required this.createdDate,
    required this.updatedDate,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      bankDetailId: json['BankDetailID'] ?? 0,
      userId: json['UserID'] ?? 0,
      accountHolderName: json['AccountHolderName'] ?? '',
      accountNumber: json['AccountNumber'] ?? '',
      ifscCode: json['IFSCCode'] ?? '',
      bankName: json['BankName'] ?? '',
      upiId: json['UPIId'] ?? '',
      phonePe: json['PhonePe'] ?? '',
      googlePay: json['GooglePay'] ?? '',
      paytm: json['Paytm'] ?? '',
      createdDate: json['CreatedDate'] ?? '',
      updatedDate: json['UpdatedDate'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BankDetailID': bankDetailId,
      'UserID': userId,
      'AccountHolderName': accountHolderName,
      'AccountNumber': accountNumber,
      'IFSCCode': ifscCode,
      'BankName': bankName,
      'UPIId': upiId,
      'PhonePe': phonePe,
      'GooglePay': googlePay,
      'Paytm': paytm,
      'CreatedDate': createdDate,
      'UpdatedDate': updatedDate,
    };
  }
}