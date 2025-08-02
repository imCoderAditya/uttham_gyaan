import 'dart:convert';

import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/utils/logger_utils.dart';
import 'package:uttham_gyaan/app/data/model/course/course_model.dart';
import 'package:uttham_gyaan/app/data/repositories/api_repo.dart';
import 'package:uttham_gyaan/components/image_slider_ui.dart';

class HomeController extends GetxController {
  APIRepo apiRepo = APIRepo();

  final Rxn<CourseModel> _courseModel = Rxn<CourseModel>();

  Rxn<CourseModel> get courseModel => _courseModel;

  final Rxn<CourseModel> _searchCourseModel = Rxn<CourseModel>();
  Rxn<CourseModel> get searchCourseModel => _searchCourseModel;
  List<CarouselItem> sliderImage = [];
  RxBool isLoading = false.obs;

  Future<void> fetchAllCourse({String? query, int? courseId, bool? isSearch = false}) async {
    isLoading.value = true;
    try {
      final res = await apiRepo.fetchAllCourse(query: query, courseId: courseId);

      if (res != null) {
        // Handle search mode
        if (isSearch == true) {
          // If query is empty, fallback to main course model
          if (query?.isEmpty ?? true) {
            _searchCourseModel.value = _courseModel.value;
          } else {
            _searchCourseModel.value = courseModelFromJson(json.encode(res.data));
          }
        }
        // Handle initial fetch (not search)
        else {
          _courseModel.value = courseModelFromJson(json.encode(res.data));
          _searchCourseModel.value = _courseModel.value;
          // Clear and add new slider images
          sliderImage.clear();
          sliderImage.addAll(
            _courseModel.value?.courseData?.map(
                  (course) => CarouselItem(
                    id: course.courseId.toString(),
                    imageUrl: course.thumbnailUrl ?? '',
                    description: course.description ?? '',
                    title: course.title ?? '',
                  ),
                ) ??
                [],
          );
        }

        LoggerUtils.debug(jsonEncode(_courseModel.value), tag: "Response");
      } else {
        LoggerUtils.warning("Course not load", tag: "HomeController");
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
    fetchAllCourse();
    super.onInit();
  }
}
