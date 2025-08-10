// To parse this JSON data, do
//
//     final quizModel = quizModelFromJson(jsonString);

import 'dart:convert';

QuizModel quizModelFromJson(String str) => QuizModel.fromJson(json.decode(str));

String quizModelToJson(QuizModel data) => json.encode(data.toJson());

class QuizModel {
  final bool? success;
  final String? message;
  final int? total;
  final List<Quiz>? data;

  QuizModel({this.success, this.message, this.total, this.data});

  QuizModel copyWith({bool? success, String? message, int? total, List<Quiz>? data}) => QuizModel(
    success: success ?? this.success,
    message: message ?? this.message,
    total: total ?? this.total,
    data: data ?? this.data,
  );

  factory QuizModel.fromJson(Map<String, dynamic> json) => QuizModel(
    success: json["success"],
    message: json["message"],
    total: json["total"],
    data: json["data"] == null ? [] : List<Quiz>.from(json["data"]!.map((x) => Quiz.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "total": total,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Quiz {
  final int? quizId;
  final String? questionText;
  final int? videoId;
  final String? createdAt;
  final List<Option>? options;

  Quiz({this.quizId, this.questionText, this.videoId, this.createdAt, this.options});

  Quiz copyWith({int? quizId, String? questionText, int? videoId, String? createdAt, List<Option>? options}) => Quiz(
    quizId: quizId ?? this.quizId,
    questionText: questionText ?? this.questionText,
    videoId: videoId ?? this.videoId,
    createdAt: createdAt ?? this.createdAt,
    options: options ?? this.options,
  );

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
    quizId: json["QuizID"],
    questionText: json["QuestionText"],
    videoId: json["VideoID"],
    createdAt: json["CreatedAt"],
    options: json["Options"] == null ? [] : List<Option>.from(json["Options"]!.map((x) => Option.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "QuizID": quizId,
    "QuestionText": questionText,
    "VideoID": videoId,
    "CreatedAt": createdAt,
    "Options": options == null ? [] : List<dynamic>.from(options!.map((x) => x.toJson())),
  };
}

class Option {
  final int? optionId;
  final String? optionText;

  Option({this.optionId, this.optionText});

  Option copyWith({int? optionId, String? optionText}) =>
      Option(optionId: optionId ?? this.optionId, optionText: optionText ?? this.optionText);

  factory Option.fromJson(Map<String, dynamic> json) =>
      Option(optionId: json["OptionID"], optionText: json["OptionText"]);

  Map<String, dynamic> toJson() => {"OptionID": optionId, "OptionText": optionText};
}
