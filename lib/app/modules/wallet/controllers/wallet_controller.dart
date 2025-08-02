import 'dart:convert';

import 'package:get/get.dart';
import 'package:uttham_gyaan/app/core/utils/logger_utils.dart';
import 'package:uttham_gyaan/app/data/baseclient/base_client.dart';
import 'package:uttham_gyaan/app/data/endpoint/end_point.dart';
import 'package:uttham_gyaan/app/data/model/wallet/wallet_model.dart';

class WalletController extends GetxController {
  final loading = false.obs;
  final Rxn<WalletModel> _walletModel = Rxn<WalletModel>();
  Rxn<WalletModel> get walletModel => _walletModel;
  Future<void> fetchWallet() async {
    loading.value = true;
    try {
      final res = await BaseClient.get(api: "${EndPoint.orderDashBoard}?userId=1");

      if (res != null && res.statusCode == 200) {
        _walletModel.value = walletModelFromJson(jsonEncode(res.data));
        LoggerUtils.debug(json.encode(_walletModel.value), tag: "Response");
      } else {
        LoggerUtils.error("Wallet API Failed Try Again Latter");
      }
    } catch (e) {
      LoggerUtils.error("error: $e");
    } finally {
      loading.value = false;
    }
  }

  @override
  void onInit() {
    fetchWallet();
    super.onInit();
  }
}
