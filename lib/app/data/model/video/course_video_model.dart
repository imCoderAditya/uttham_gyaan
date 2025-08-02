// To parse this JSON data, do
//
//     final videoModel = videoModelFromJson(jsonString);

import 'dart:convert';

VideoModel videoModelFromJson(String str) => VideoModel.fromJson(json.decode(str));

String videoModelToJson(VideoModel data) => json.encode(data.toJson());

class VideoModel {
  final bool? success;
  final String? message;
  final int? total;
  final List<CourseVideo>? data;

  VideoModel({this.success, this.message, this.total, this.data});

  VideoModel copyWith({bool? success, String? message, int? total, List<CourseVideo>? data}) => VideoModel(
    success: success ?? this.success,
    message: message ?? this.message,
    total: total ?? this.total,
    data: data ?? this.data,
  );

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
    success: json["success"],
    message: json["message"],
    total: json["total"],
    data: json["data"] == null ? [] : List<CourseVideo>.from(json["data"]!.map((x) => CourseVideo.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "total": total,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CourseVideo {
  final int? videoId;
  final int? courseId;
  final String? title;
  final String? videoUrl;
  final int? durationMinutes;
  final int? sequenceOrder;

  CourseVideo({this.videoId, this.courseId, this.title, this.videoUrl, this.durationMinutes, this.sequenceOrder});

  CourseVideo copyWith({
    int? videoId,
    int? courseId,
    String? title,
    String? videoUrl,
    int? durationMinutes,
    int? sequenceOrder,
  }) => CourseVideo(
    videoId: videoId ?? this.videoId,
    courseId: courseId ?? this.courseId,
    title: title ?? this.title,
    videoUrl: videoUrl ?? this.videoUrl,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    sequenceOrder: sequenceOrder ?? this.sequenceOrder,
  );

  factory CourseVideo.fromJson(Map<String, dynamic> json) => CourseVideo(
    videoId: json["VideoID"],
    courseId: json["CourseID"],
    title: json["Title"],
    videoUrl: json["VideoUrl"],
    durationMinutes: json["DurationMinutes"],
    sequenceOrder: json["SequenceOrder"],
  );

  Map<String, dynamic> toJson() => {
    "VideoID": videoId,
    "CourseID": courseId,
    "Title": title,
    "VideoUrl": videoUrl,
    "DurationMinutes": durationMinutes,
    "SequenceOrder": sequenceOrder,
  };
}
