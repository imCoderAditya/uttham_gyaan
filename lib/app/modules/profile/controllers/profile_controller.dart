import 'dart:convert';


import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/utils/logger_utils.dart';
import 'package:uttham_gyaan/app/data/baseclient/base_client.dart';
import 'package:uttham_gyaan/app/data/endpoint/end_point.dart';
import 'package:uttham_gyaan/app/data/model/profile/profile_model.dart';
import 'package:uttham_gyaan/app/services/storage/local_storage_service.dart';

class ProfileController extends GetxController {
  Rxn<ProfileModel> profileModel = Rxn<ProfileModel>();
  Future<void> fetchProfile() async {
  
    try {
      final userId = LocalStorageService.getUserId();
      final res = await BaseClient.get(api: "${EndPoint.profileAPI}?userid=$userId");

      if (res != null && res.statusCode == 200) {
        profileModel.value = profileModelFromJson(json.encode(res.data));
        LoggerUtils.debug(json.encode(profileModel.value), tag: "Profile Response");
      } else {
        LoggerUtils.error("Failed Profile Fetch");
      }
    } catch (e) {
      LoggerUtils.error(e.toString(), tag: "Error");
    }
  }

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }
}
