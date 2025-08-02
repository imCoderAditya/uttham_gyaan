// To parse this JSON data, do
//
//     final courseModel = courseModelFromJson(jsonString);

import 'dart:convert';

CourseModel courseModelFromJson(String str) => CourseModel.fromJson(json.decode(str));

String courseModelToJson(CourseModel data) => json.encode(data.toJson());

class CourseModel {
  final bool? success;
  final String? message;
  final int? total;
  final List<CourseData>? courseData;

  CourseModel({this.success, this.message, this.total, this.courseData});

  CourseModel copyWith({bool? success, String? message, int? total, List<CourseData>? courseData}) => CourseModel(
    success: success ?? this.success,
    message: message ?? this.message,
    total: total ?? this.total,
    courseData: courseData ?? this.courseData,
  );

  factory CourseModel.fromJson(Map<String, dynamic> json) => CourseModel(
    success: json["success"],
    message: json["message"],
    total: json["total"],
    courseData: json["data"] == null ? [] : List<CourseData>.from(json["data"]!.map((x) => CourseData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "total": total,
    "data": courseData == null ? [] : List<dynamic>.from(courseData!.map((x) => x.toJson())),
  };
}

class CourseData {
  final int? courseId;
  final String? title;
  final String? description;
  final String? thumbnailUrl;
  final int? durationMinutes;
  final dynamic language;
  final String? createdAt;
  final bool? isPublished;
  final double? mrp;
  final int? videoCount;

  CourseData({
    this.courseId,
    this.title,
    this.description,
    this.thumbnailUrl,
    this.durationMinutes,
    this.language,
    this.createdAt,
    this.isPublished,
    this.mrp,
    this.videoCount,
  });

  CourseData copyWith({
    int? courseId,
    String? title,
    String? description,
    String? thumbnailUrl,
    int? durationMinutes,
    dynamic language,
    String? createdAt,
    bool? isPublished,
    double? mrp,
    int? videoCount,
  }) => CourseData(
    courseId: courseId ?? this.courseId,
    title: title ?? this.title,
    description: description ?? this.description,
    thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    language: language ?? this.language,
    createdAt: createdAt ?? this.createdAt,
    isPublished: isPublished ?? this.isPublished,
    mrp: mrp ?? this.mrp,
    videoCount: videoCount ?? this.videoCount,
  );

  factory CourseData.fromJson(Map<String, dynamic> json) => CourseData(
    courseId: json["CourseID"],
    title: json["Title"],
    description: json["Description"],
    thumbnailUrl: json["ThumbnailUrl"],
    durationMinutes: json["DurationMinutes"],
    language: json["Language"],
    createdAt: json["CreatedAt"],
    isPublished: json["IsPublished"],
    mrp: json["mrp"],
    videoCount: json["VideoCount"],
  );

  Map<String, dynamic> toJson() => {
    "CourseID": courseId,
    "Title": title,
    "Description": description,
    "ThumbnailUrl": thumbnailUrl,
    "DurationMinutes": durationMinutes,
    "Language": language,
    "CreatedAt": createdAt,
    "IsPublished": isPublished,
    "mrp": mrp,
    "VideoCount": videoCount,
  };
}
