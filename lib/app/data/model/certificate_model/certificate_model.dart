import 'dart:convert';

CourseProgressModel courseProgressModelFromJson(String str) => CourseProgressModel.fromJson(json.decode(str));

String courseProgressModelToJson(CourseProgressModel data) => json.encode(data.toJson());

class CourseProgressModel {
  CourseProgressModel({
    this.status,
    this.data,
  });

  bool? status;
  CourseProgressData? data;

  factory CourseProgressModel.fromJson(Map<String, dynamic> json) => CourseProgressModel(
    status: json["status"],
    data: json["data"] != null ? CourseProgressData.fromJson(json["data"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class CourseProgressData {
  CourseProgressData({
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

  int? userId;
  int? courseId;
  String? courseStartedDate;
  int? totalVideos;
  int? videosCompleted;
  double? videoCompletionPercentage;
  double? overallCompletionPercentage;
  int? totalQuizzes;
  int? quizzesAttempted;
  int? correctAnswers;
  int? totalQuizAttempts;
  double? quizSuccessRate;
  int? totalWatchedMinutes;
  int? totalCourseDurationMinutes;
  double? averageVideoCompletionPercentage;
  String? lastVideoActivity;
  String? lastQuizActivity;
  String? videoProgressDetails;
  String? certificateLink;

  factory CourseProgressData.fromJson(Map<String, dynamic> json) => CourseProgressData(
    userId: json["UserID"],
    courseId: json["CourseID"],
    courseStartedDate: json["CourseStartedDate"],
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
    lastVideoActivity: json["LastVideoActivity"],
    lastQuizActivity: json["LastQuizActivity"],
    videoProgressDetails: json["VideoProgressDetails"],
    certificateLink: json["CertificateLink"],
  );

  Map<String, dynamic> toJson() => {
    "UserID": userId,
    "CourseID": courseId,
    "CourseStartedDate": courseStartedDate,
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
    "LastVideoActivity": lastVideoActivity,
    "LastQuizActivity": lastQuizActivity,
    "VideoProgressDetails": videoProgressDetails,
    "CertificateLink": certificateLink,
  };
}