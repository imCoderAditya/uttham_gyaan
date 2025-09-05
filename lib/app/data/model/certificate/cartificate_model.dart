// To parse this JSON data, do
//
//     final certificateModel = certificateModelFromJson(jsonString);

import 'dart:convert';

CertificateModel certificateModelFromJson(String str) => CertificateModel.fromJson(json.decode(str));

String certificateModelToJson(CertificateModel data) => json.encode(data.toJson());

class CertificateModel {
    final bool? status;
    final Data? data;

    CertificateModel({
        this.status,
        this.data,
    });

    CertificateModel copyWith({
        bool? status,
        Data? data,
    }) => 
        CertificateModel(
            status: status ?? this.status,
            data: data ?? this.data,
        );

    factory CertificateModel.fromJson(Map<String, dynamic> json) => CertificateModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
    };
}

class Data {
    final int? userId;
    final int? courseId;
    final DateTime? courseStartedDate;
    final int? totalVideos;
    final int? videosCompleted;
    final double? videoCompletionPercentage;
    final double? overallCompletionPercentage;
    final int? totalQuizzes;
    final int? quizzesAttempted;
    final int? correctAnswers;
    final int? totalQuizAttempts;
    final double? quizSuccessRate;
    final int? totalWatchedMinutes;
    final int? totalCourseDurationMinutes;
    final double? averageVideoCompletionPercentage;
    final DateTime? lastVideoActivity;
    final DateTime? lastQuizActivity;
    final String? videoProgressDetails;
    final String? certificateLink;

    Data({
        this.userId,
        this.courseId,
        this.courseStartedDate,
        this.totalVideos,
        this.videosCompleted,
        this.videoCompletionPercentage,
        this.overallCompletionPercentage,
        this.totalQuizzes,
        this.quizzesAttempted,
        this.correctAnswers,
        this.totalQuizAttempts,
        this.quizSuccessRate,
        this.totalWatchedMinutes,
        this.totalCourseDurationMinutes,
        this.averageVideoCompletionPercentage,
        this.lastVideoActivity,
        this.lastQuizActivity,
        this.videoProgressDetails,
        this.certificateLink,
    });

    Data copyWith({
        int? userId,
        int? courseId,
        DateTime? courseStartedDate,
        int? totalVideos,
        int? videosCompleted,
        double? videoCompletionPercentage,
        double? overallCompletionPercentage,
        int? totalQuizzes,
        int? quizzesAttempted,
        int? correctAnswers,
        int? totalQuizAttempts,
        double? quizSuccessRate,
        int? totalWatchedMinutes,
        int? totalCourseDurationMinutes,
        double? averageVideoCompletionPercentage,
        DateTime? lastVideoActivity,
        DateTime? lastQuizActivity,
        String? videoProgressDetails,
        String? certificateLink,
    }) => 
        Data(
            userId: userId ?? this.userId,
            courseId: courseId ?? this.courseId,
            courseStartedDate: courseStartedDate ?? this.courseStartedDate,
            totalVideos: totalVideos ?? this.totalVideos,
            videosCompleted: videosCompleted ?? this.videosCompleted,
            videoCompletionPercentage: videoCompletionPercentage ?? this.videoCompletionPercentage,
            overallCompletionPercentage: overallCompletionPercentage ?? this.overallCompletionPercentage,
            totalQuizzes: totalQuizzes ?? this.totalQuizzes,
            quizzesAttempted: quizzesAttempted ?? this.quizzesAttempted,
            correctAnswers: correctAnswers ?? this.correctAnswers,
            totalQuizAttempts: totalQuizAttempts ?? this.totalQuizAttempts,
            quizSuccessRate: quizSuccessRate ?? this.quizSuccessRate,
            totalWatchedMinutes: totalWatchedMinutes ?? this.totalWatchedMinutes,
            totalCourseDurationMinutes: totalCourseDurationMinutes ?? this.totalCourseDurationMinutes,
            averageVideoCompletionPercentage: averageVideoCompletionPercentage ?? this.averageVideoCompletionPercentage,
            lastVideoActivity: lastVideoActivity ?? this.lastVideoActivity,
            lastQuizActivity: lastQuizActivity ?? this.lastQuizActivity,
            videoProgressDetails: videoProgressDetails ?? this.videoProgressDetails,
            certificateLink: certificateLink ?? this.certificateLink,
        );

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["UserID"],
        courseId: json["CourseID"],
        courseStartedDate: json["CourseStartedDate"] == null ? null : DateTime.parse(json["CourseStartedDate"]),
        totalVideos: json["TotalVideos"],
        videosCompleted: json["VideosCompleted"],
        videoCompletionPercentage: json["VideoCompletionPercentage"]?.toDouble(),
        overallCompletionPercentage: json["OverallCompletionPercentage"]?.toDouble(),
        totalQuizzes: json["TotalQuizzes"],
        quizzesAttempted: json["QuizzesAttempted"],
        correctAnswers: json["CorrectAnswers"],
        totalQuizAttempts: json["TotalQuizAttempts"],
        quizSuccessRate: json["QuizSuccessRate"]?.toDouble(),
        totalWatchedMinutes: json["TotalWatchedMinutes"],
        totalCourseDurationMinutes: json["TotalCourseDurationMinutes"],
        averageVideoCompletionPercentage: json["AverageVideoCompletionPercentage"]?.toDouble(),
        lastVideoActivity: json["LastVideoActivity"] == null ? null : DateTime.parse(json["LastVideoActivity"]),
        lastQuizActivity: json["LastQuizActivity"] == null ? null : DateTime.parse(json["LastQuizActivity"]),
        videoProgressDetails: json["VideoProgressDetails"],
        certificateLink: json["CertificateLink"],
    );

    Map<String, dynamic> toJson() => {
        "UserID": userId,
        "CourseID": courseId,
        "CourseStartedDate": courseStartedDate?.toIso8601String(),
        "TotalVideos": totalVideos,
        "VideosCompleted": videosCompleted,
        "VideoCompletionPercentage": videoCompletionPercentage,
        "OverallCompletionPercentage": overallCompletionPercentage,
        "TotalQuizzes": totalQuizzes,
        "QuizzesAttempted": quizzesAttempted,
        "CorrectAnswers": correctAnswers,
        "TotalQuizAttempts": totalQuizAttempts,
        "QuizSuccessRate": quizSuccessRate,
        "TotalWatchedMinutes": totalWatchedMinutes,
        "TotalCourseDurationMinutes": totalCourseDurationMinutes,
        "AverageVideoCompletionPercentage": averageVideoCompletionPercentage,
        "LastVideoActivity": lastVideoActivity?.toIso8601String(),
        "LastQuizActivity": lastQuizActivity?.toIso8601String(),
        "VideoProgressDetails": videoProgressDetails,
        "CertificateLink": certificateLink,
    };
}
