import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/utils/logger_utils.dart';
import 'package:uttham_gyaan/app/data/model/course/my_course_model.dart';
import 'package:uttham_gyaan/app/data/model/video/course_video_model.dart';
import 'package:uttham_gyaan/app/data/repositories/api_repo.dart';

class MycourseController extends GetxController {
  final isLoading = false.obs;
  APIRepo apiRepo = APIRepo();
  final Rxn<MyCourseModel> _myCourseModel = Rxn<MyCourseModel>();
  final searchController = TextEditingController();
  // Get Video Model
  Rxn<MyCourseModel> get myCourseModel => _myCourseModel;
  final Rxn<VideoModel> _videoModel = Rxn<VideoModel>();

  Rxn<VideoModel> get videoModel => _videoModel;
  Future<void> fetchStudentCourse({String? query}) async {
    isLoading.value = true;
    try {
      final res = await apiRepo.fetchMyCourseVideo(query: query);
      if (res != null) {
        _myCourseModel.value = myCourseModelFromJson(json.encode(res.data));
        LoggerUtils.debug("Response: ${json.encode(_myCourseModel.value)}");
      } else {
        LoggerUtils.warning("Failed: ${res.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error $e");
    } finally {
      isLoading.value = true;
      update();
    }
  }

  Future<void> fetchAllCourseVideo(int? courseId) async {
    isLoading.value = true;
    try {
      final res = await apiRepo.fetchAllCourseVideo(courseId: courseId);

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
  void onInit() {
    fetchStudentCourse();
    super.onInit();
  }

  // Add these properties and methods to your controller

  // final filteredCourses = <MyCourseData>[].obs;

  // void searchCourses(String query) {
  //   if (query.isEmpty) {
  //     filteredCourses.clear();
  //   } else {
  //     final courses = myCourseModel.value?.myCourseData ?? [];
  //     filteredCourses.value =
  //         courses
  //             .where(
  //               (course) =>
  //                   course.title?.toLowerCase().contains(query.toLowerCase()) == true ||
  //                   course.description?.toLowerCase().contains(query.toLowerCase()) == true,
  //             )
  //             .toList();
  //   }
  // }

  void clearSearch() {
    // searchController.clear();
    // filteredCourses.clear();
  }

  Future<void> fetchMyCourses() async {
    // Your API call implementation
  }
}
