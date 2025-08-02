import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/modules/home/views/home_view.dart';
import 'package:uttham_gyaan/app/modules/mycourse/views/mycourse_view.dart';

class NavController extends GetxController {
  var currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  final page = [HomeView(), MycourseView(), HomeView(), Scaffold()];
}
