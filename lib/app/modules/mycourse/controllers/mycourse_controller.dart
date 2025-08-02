import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/utils/logger_utils.dart';
import 'package:uttham_gyaan/app/data/model/course/my_course_model.dart';
import 'package:uttham_gyaan/app/data/repositories/api_repo.dart';

class MycourseController extends GetxController {
  final isLoading = false.obs;
  APIRepo apiRepo = APIRepo();
  final Rxn<MyCourseModel> _myCourseModel = Rxn<MyCourseModel>();

  Rxn<MyCourseModel> get myCourseModel => _myCourseModel;

  Future<void> fetchStudentCourse() async {
    try {
      final res = await apiRepo.fetchMyCourseVideo();
      if (res != null) {
        _myCourseModel.value = myCourseModelFromJson(json.encode(res.data));
        LoggerUtils.debug("Response: ${json.encode(_myCourseModel.value)}");
      } else {
        LoggerUtils.warning("Failed: ${res.data}");
      }
    } catch (e) {
      LoggerUtils.error("Error $e");
    }
  }

  @override
  void onInit() {
    fetchStudentCourse();
    super.onInit();
  }

  // Add these properties and methods to your controller
  final searchController = TextEditingController();
  final filteredCourses = <MyCourseData>[].obs;

  void searchCourses(String query) {
    if (query.isEmpty) {
      filteredCourses.clear();
    } else {
      final courses = myCourseModel.value?.myCourseData ?? [];
      filteredCourses.value =
          courses
              .where(
                (course) =>
                    course.title?.toLowerCase().contains(query.toLowerCase()) == true ||
                    course.description?.toLowerCase().contains(query.toLowerCase()) == true,
              )
              .toList();
    }
  }

  void clearSearch() {
    searchController.clear();
    filteredCourses.clear();
  }

  Future<void> fetchMyCourses() async {
    // Your API call implementation
  }
}
