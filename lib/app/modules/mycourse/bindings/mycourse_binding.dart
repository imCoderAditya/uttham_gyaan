import 'package:get/get.dart';

import '../controllers/mycourse_controller.dart';

class MycourseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MycourseController>(
      () => MycourseController(),
    );
  }
}
