// To parse this JSON data, do
//
//     final myCourseModel = myCourseModelFromJson(jsonString);

import 'dart:convert';

MyCourseModel myCourseModelFromJson(String str) => MyCourseModel.fromJson(json.decode(str));

String myCourseModelToJson(MyCourseModel data) => json.encode(data.toJson());

class MyCourseModel {
  final bool? success;
  final String? message;
  final int? total;
  final List<MyCourseData>? myCourseData;

  MyCourseModel({this.success, this.message, this.total, this.myCourseData});

  MyCourseModel copyWith({bool? success, String? message, int? total, List<MyCourseData>? myCourseData}) =>
      MyCourseModel(
        success: success ?? this.success,
        message: message ?? this.message,
        total: total ?? this.total,
        myCourseData: myCourseData ?? this.myCourseData,
      );

  factory MyCourseModel.fromJson(Map<String, dynamic> json) => MyCourseModel(
    success: json["success"],
    message: json["message"],
    total: json["total"],
    myCourseData:
        json["data"] == null ? [] : List<MyCourseData>.from(json["data"]!.map((x) => MyCourseData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "total": total,
    "data": myCourseData == null ? [] : List<dynamic>.from(myCourseData!.map((x) => x.toJson())),
  };
}

class MyCourseData {
  final int? courseId;
  final String? title;
  final String? description;
  final String? thumbnailUrl;
  final int? durationMinutes;
  final String? language;
  final DateTime? createdAt;
  final bool? isPublished;
  final double? mrp;
  final int? videoCount;

  MyCourseData({
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

  MyCourseData copyWith({
    int? courseId,
    String? title,
    String? description,
    String? thumbnailUrl,
    int? durationMinutes,
    String? language,
    DateTime? createdAt,
    bool? isPublished,
    double? mrp,
    int? videoCount,
  }) => MyCourseData(
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

  factory MyCourseData.fromJson(Map<String, dynamic> json) => MyCourseData(
    courseId: json["CourseID"],
    title: json["Title"],
    description: json["Description"],
    thumbnailUrl: json["ThumbnailUrl"],
    durationMinutes: json["DurationMinutes"],
    language: json["Language"],
    createdAt: json["CreatedAt"] == null ? null : DateTime.parse(json["CreatedAt"]),
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
    "CreatedAt": createdAt?.toIso8601String(),
    "IsPublished": isPublished,
    "mrp": mrp,
    "VideoCount": videoCount,
  };
}
