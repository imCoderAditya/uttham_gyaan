import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TimeController extends GetxController with WidgetsBindingObserver {
  var elapsedSeconds = 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    startTimer();
  }

  @override
  void onClose() {
    stopTimer();
    WidgetsBinding.instance.removeObserver(this);
    debugPrint("Closing......");
    super.onClose();
  }

  // Listen for app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      stopTimer(); // Pause when minimized or background
    } else if (state == AppLifecycleState.resumed) {
      startTimer(); // Resume when app comes back
    }
  }

  void startTimer() {
    _timer ??= Timer.periodic(Duration(seconds: 1), (timer) {
      elapsedSeconds.value++;
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
