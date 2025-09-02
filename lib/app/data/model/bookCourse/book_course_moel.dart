// To parse this JSON data, do
//
//     final bookCourseModel = bookCourseModelFromJson(jsonString);

import 'dart:convert';

BookCourseModel bookCourseModelFromJson(String str) => BookCourseModel.fromJson(json.decode(str));

String bookCourseModelToJson(BookCourseModel data) => json.encode(data.toJson());

class BookCourseModel {
    final int? statusCode;
    final String? message;
    final int? paymentId;
    final int? courseId;
    final int? userId;
    final double? mrp;
    final String? transactionId;
    final String? status;

    BookCourseModel({
        this.statusCode,
        this.message,
        this.paymentId,
        this.courseId,
        this.userId,
        this.mrp,
        this.transactionId,
        this.status,
    });

    BookCourseModel copyWith({
        int? statusCode,
        String? message,
        int? paymentId,
        int? courseId,
        int? userId,
        double? mrp,
        String? transactionId,
        String? status,
    }) => 
        BookCourseModel(
            statusCode: statusCode ?? this.statusCode,
            message: message ?? this.message,
            paymentId: paymentId ?? this.paymentId,
            courseId: courseId ?? this.courseId,
            userId: userId ?? this.userId,
            mrp: mrp ?? this.mrp,
            transactionId: transactionId ?? this.transactionId,
            status: status ?? this.status,
        );

    factory BookCourseModel.fromJson(Map<String, dynamic> json) => BookCourseModel(
        statusCode: json["StatusCode"],
        message: json["Message"],
        paymentId: json["PaymentID"],
        courseId: json["CourseID"],
        userId: json["UserID"],
        mrp: json["MRP"]?.toDouble(),
        transactionId: json["TransactionID"],
        status: json["Status"],
    );

    Map<String, dynamic> toJson() => {
        "StatusCode": statusCode,
        "Message": message,
        "PaymentID": paymentId,
        "CourseID": courseId,
        "UserID": userId,
        "MRP": mrp,
        "TransactionID": transactionId,
        "Status": status,
    };
}
