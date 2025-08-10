// To parse this JSON data, do
//
//     final quizResultModel = quizResultModelFromJson(jsonString);

import 'dart:convert';

QuizResultModel quizResultModelFromJson(String str) => QuizResultModel.fromJson(json.decode(str));

String quizResultModelToJson(QuizResultModel data) => json.encode(data.toJson());

class QuizResultModel {
  final bool? success;
  final String? message;
  final List<QuizResult>? data;

  QuizResultModel({this.success, this.message, this.data});

  QuizResultModel copyWith({bool? success, String? message, List<QuizResult>? data}) =>
      QuizResultModel(success: success ?? this.success, message: message ?? this.message, data: data ?? this.data);

  factory QuizResultModel.fromJson(Map<String, dynamic> json) => QuizResultModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<QuizResult>.from(json["data"]!.map((x) => QuizResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class QuizResult {
  final int? videoId;
  final String? videoTitle;
  final int? attempted;
  final int? correct;
  final double? accuracyPercentage;

  QuizResult({this.videoId, this.videoTitle, this.attempted, this.correct, this.accuracyPercentage});

  QuizResult copyWith({int? videoId, String? videoTitle, int? attempted, int? correct, double? accuracyPercentage}) =>
      QuizResult(
        videoId: videoId ?? this.videoId,
        videoTitle: videoTitle ?? this.videoTitle,
        attempted: attempted ?? this.attempted,
        correct: correct ?? this.correct,
        accuracyPercentage: accuracyPercentage ?? this.accuracyPercentage,
      );

  factory QuizResult.fromJson(Map<String, dynamic> json) => QuizResult(
    videoId: json["VideoID"],
    videoTitle: json["VideoTitle"],
    attempted: json["Attempted"],
    correct: json["Correct"],
    accuracyPercentage: json["AccuracyPercentage"],
  );

  Map<String, dynamic> toJson() => {
    "VideoID": videoId,
    "VideoTitle": videoTitle,
    "Attempted": attempted,
    "Correct": correct,
    "AccuracyPercentage": accuracyPercentage,
  };
}
