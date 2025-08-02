// To parse this JSON data, do
//
//     final videoDetailsModel = videoDetailsModelFromJson(jsonString);

import 'dart:convert';

VideoDetailsModel videoDetailsModelFromJson(String str) => VideoDetailsModel.fromJson(json.decode(str));

String videoDetailsModelToJson(VideoDetailsModel data) => json.encode(data.toJson());

class VideoDetailsModel {
  final bool? success;
  final String? message;
  final Data? data;

  VideoDetailsModel({this.success, this.message, this.data});

  VideoDetailsModel copyWith({bool? success, String? message, Data? data}) =>
      VideoDetailsModel(success: success ?? this.success, message: message ?? this.message, data: data ?? this.data);

  factory VideoDetailsModel.fromJson(Map<String, dynamic> json) => VideoDetailsModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"success": success, "message": message, "data": data?.toJson()};
}

class Data {
  final Video? video;
  final Progress? progress;

  Data({this.video, this.progress});

  Data copyWith({Video? video, Progress? progress}) =>
      Data(video: video ?? this.video, progress: progress ?? this.progress);

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    video: json["video"] == null ? null : Video.fromJson(json["video"]),
    progress: json["progress"] == null ? null : Progress.fromJson(json["progress"]),
  );

  Map<String, dynamic> toJson() => {"video": video?.toJson(), "progress": progress?.toJson()};
}

class Progress {
  final int? watchedDurationMinutes;
  final double? completionPercentage;
  final bool? isCompleted;

  Progress({this.watchedDurationMinutes, this.completionPercentage, this.isCompleted});

  Progress copyWith({int? watchedDurationMinutes, double? completionPercentage, bool? isCompleted}) => Progress(
    watchedDurationMinutes: watchedDurationMinutes ?? this.watchedDurationMinutes,
    completionPercentage: completionPercentage ?? this.completionPercentage,
    isCompleted: isCompleted ?? this.isCompleted,
  );

  factory Progress.fromJson(Map<String, dynamic> json) => Progress(
    watchedDurationMinutes: json["WatchedDurationMinutes"],
    completionPercentage: json["CompletionPercentage"]?.toDouble(),
    isCompleted: json["IsCompleted"],
  );

  Map<String, dynamic> toJson() => {
    "WatchedDurationMinutes": watchedDurationMinutes,
    "CompletionPercentage": completionPercentage,
    "IsCompleted": isCompleted,
  };
}

class Video {
  final int? videoId;
  final int? courseId;
  final String? title;
  final String? videoUrl;
  final int? durationMinutes;
  final int? sequenceOrder;
  final String? courseTitle;

  Video({
    this.videoId,
    this.courseId,
    this.title,
    this.videoUrl,
    this.durationMinutes,
    this.sequenceOrder,
    this.courseTitle,
  });

  Video copyWith({
    int? videoId,
    int? courseId,
    String? title,
    String? videoUrl,
    int? durationMinutes,
    int? sequenceOrder,
    String? courseTitle,
  }) => Video(
    videoId: videoId ?? this.videoId,
    courseId: courseId ?? this.courseId,
    title: title ?? this.title,
    videoUrl: videoUrl ?? this.videoUrl,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    sequenceOrder: sequenceOrder ?? this.sequenceOrder,
    courseTitle: courseTitle ?? this.courseTitle,
  );

  factory Video.fromJson(Map<String, dynamic> json) => Video(
    videoId: json["VideoID"],
    courseId: json["CourseID"],
    title: json["Title"],
    videoUrl: json["VideoUrl"],
    durationMinutes: json["DurationMinutes"],
    sequenceOrder: json["SequenceOrder"],
    courseTitle: json["CourseTitle"],
  );

  Map<String, dynamic> toJson() => {
    "VideoID": videoId,
    "CourseID": courseId,
    "Title": title,
    "VideoUrl": videoUrl,
    "DurationMinutes": durationMinutes,
    "SequenceOrder": sequenceOrder,
    "CourseTitle": courseTitle,
  };
}
