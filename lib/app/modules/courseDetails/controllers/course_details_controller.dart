import 'dart:convert';

import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/utils/logger_utils.dart';
import 'package:uttham_gyaan/app/data/model/video/course_video_model.dart';
import 'package:uttham_gyaan/app/data/repositories/api_repo.dart';

class CourseDetailsController extends GetxController {
  APIRepo apiRepo = APIRepo();

  RxInt? courseId = RxInt(1);
  final Rxn<VideoModel> _videoModel = Rxn<VideoModel>();

  Rxn<VideoModel> get videoModel => _videoModel;
  RxBool isLoading = false.obs;
  Future<void> fetchAllCourseVideo() async {
    isLoading.value = true;
    try {
      final res = await apiRepo.fetchAllCourseVideo(courseId: courseId?.value);

      if (res != null) {
        _videoModel.value = videoModelFromJson(json.encode(res.data));
        LoggerUtils.debug(json.encode(_videoModel.value), tag: "Response");
      } else {
        LoggerUtils.debug(jsonEncode(res.data), tag: "Response");
      }
    } catch (e) {
      LoggerUtils.error("Error: $e");
    } finally {
      await Future.delayed(Duration(milliseconds: 100));
      isLoading.value = false;
      update();
    }
  }

  @override
  void onReady() {
    fetchAllCourseVideo();
    super.onReady();
  }
}
