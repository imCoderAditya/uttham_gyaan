import 'package:uttham_gyaan/app/core/utils/logger_utils.dart';
import 'package:uttham_gyaan/app/data/baseclient/base_client.dart';
import 'package:uttham_gyaan/app/data/endpoint/end_point.dart';

abstract class APIRepoRistory {
  Future<dynamic> fetchAllCourse();
  Future<dynamic> fetchAllCourseVideo();
  Future<dynamic> fetchMyCourseVideo();
}

class APIRepo extends APIRepoRistory {
  @override
  Future fetchAllCourse({String? query, int? courseId}) async {
    try {
      final res = await BaseClient.post(api: EndPoint.allcourse, data: {"courseid": courseId, "search": query});

      if (res != null && res.statusCode == 200) {
        return res;
      } else {
        return null;
      }
    } catch (e) {
      LoggerUtils.error("error: $e");
      return null;
    }
  }

  @override
  Future<dynamic> fetchAllCourseVideo({String? query, int? courseId}) async {
    try {
      final res = await BaseClient.post(
        api: EndPoint.allCourseVideo,
        data: {"CourseID": 1, "search": "", "Language": "English"},
      );

      if (res != null && res.statusCode == 200) {
        return res;
      } else {
        return null;
      }
    } catch (e) {
      LoggerUtils.error("error: $e");
      return null;
    }
  }

  @override
  Future<dynamic> fetchMyCourseVideo({String? query}) async {
    try {
      final res = await BaseClient.post(api: EndPoint.myCourse, data: {"UserID": 1, "Search": query ?? ""});
      if (res != null && res.statusCode == 200) {
        return res;
      } else {
        return null;
      }
    } catch (e) {
      LoggerUtils.error("Error $e");
      return null;
    }
  }
}
