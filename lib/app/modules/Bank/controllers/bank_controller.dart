import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uttham_gyaan/app/modules/Bank/components/add_bank.dart';
import 'package:uttham_gyaan/app/services/storage/local_storage_service.dart';
import 'package:uttham_gyaan/components/Snack_bar_view.dart';
import 'package:uttham_gyaan/components/global_loader.dart';
import '../../../data/baseclient/base_client.dart';
import '../../../data/endpoint/end_point.dart';
import '../../../data/model/bank/bank_model.dart';
import '../../../data/model/commissions/commissions_model.dart';

class BankController extends GetxController {
  final Rx<BankModel?> bank = Rx<BankModel?>(null);
  String? userId = LocalStorageService.getUserId();
  final count = 0.obs;
  final RxString error = ''.obs;
  final RxBool isLoading = true.obs;
  final RxString accountHolderName = ''.obs;
  final RxString accountNumber = ''.obs;
  final RxString ifscCode = ''.obs;
  final RxString bankName = ''.obs;
  final RxString upiId = ''.obs;
  final RxString phonePe = ''.obs;
  final RxString googlePay = ''.obs;
  final RxString paytm = ''.obs;
  final RxInt Bankid = 0.obs;

  var commissionResponse =
      CommissionResponse(
        status: false,
        totalSuccessAmount: 0.0,
        commissions: [],
      ).obs;
  var filteredCommissions = <Commission>[].obs;
  var errorMessage = ''.obs;
  var sortBy = 'none'.obs; // none, amount, date
  var filterStatus = 'all'.obs;

  void applyFiltersAndSort() {
    var commissions = commissionResponse.value.commissions;

    // Apply status filter
    if (filterStatus.value != 'all') {
      commissions =
          commissions.where((c) => c.status == filterStatus.value).toList();
    }

    // Apply sorting
    if (sortBy.value == 'amount') {
      commissions.sort((a, b) => b.amount.compareTo(a.amount));
    } else if (sortBy.value == 'date') {
      commissions.sort(
        (a, b) => DateTime.parse(
          b.generatedDate,
        ).compareTo(DateTime.parse(a.generatedDate)),
      );
    }

    filteredCommissions.assignAll(commissions);
  }

  void setFilter(String status) {
    filterStatus(status);
    applyFiltersAndSort();
  }

  void setSort(String sort) {
    sortBy(sort);
    applyFiltersAndSort();
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  void init(BankModel? existing, int currentUserId) {
    userId = userId;
    if (existing != null) {
      accountHolderName.value = existing.accountHolderName;
      accountNumber.value = existing.accountNumber;
      ifscCode.value = existing.ifscCode;
      bankName.value = existing.bankName;
      upiId.value = existing.upiId;
      phonePe.value = existing.phonePe;
      googlePay.value = existing.googlePay;
      paytm.value = existing.paytm;
    } else {
      // Reset for add new
      accountHolderName.value = '';
      accountNumber.value = '';
      ifscCode.value = '';
      bankName.value = '';
      upiId.value = '';
      phonePe.value = '';
      googlePay.value = '';
      paytm.value = '';
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchBank();
    fetchCommissions();
  }

  Future<void> fetchBank() async {
    Future.microtask(() {
      GlobalLoader.show();
    });
    if (userId == null) {
      error.value = 'user_id_missing'.tr;
      isLoading.value = false;
      Get.snackbar('error'.tr, error.value);
      return;
    }

    try {
      isLoading.value = true;
      error.value = '';
      final response = await BaseClient.get(
        api: "${EndPoint.getbank}?userId=$userId",
      );

      if (response?.statusCode == 200) {
        final responseData = response?.data as Map<String, dynamic>?;
        if (responseData != null && responseData['status'] == true) {
          final bankData = responseData['data'] as Map<String, dynamic>?;
          if (bankData != null) {
            bank.value = BankModel.fromJson(bankData);
          } else {
            bank.value = null;
            error.value = 'no_bank_details'.tr;
          }
        } else {
          bank.value = null;
          error.value = 'failed_to_fetch'.tr;
        }
      } else {
        bank.value = null;
        error.value = '${'failed_to_fetch'.tr}: ${response?.statusCode}';
      }
      GlobalLoader.hide();
    } catch (e) {
      GlobalLoader.hide();
      bank.value = null;
      error.value = '${'failed_to_fetch'.tr}: $e';
      Get.snackbar('error'.tr, error.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addUpdate(BankModel model) async {
    GlobalLoader.show();
    try {
      isLoading.value = true;
      error.value = '';
      final response = await BaseClient.post(
        api: EndPoint.Addbank,
        data: model.toJson(),
      );

      if (response?.statusCode == 200 || response?.statusCode == 201) {
        await fetchBank();
        GlobalLoader.hide();
        SnackBarView.showError(message: 'Bank details saved successfully'.tr);
      } else {
        error.value = '${'failed_to_save'.tr}: ${response?.statusCode}';
        SnackBarView.showError(message: error.value);
        GlobalLoader.hide();
      }
    } catch (e) {
      error.value = '${'failed_to_save'.tr}: $e';
      GlobalLoader.hide();
      SnackBarView.showError(message: "Error:$e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCommissions() async {
    try {
      if (userId == null) {
        error.value = 'user_id_missing'.tr;
        isLoading.value = false;
        Get.snackbar('error'.tr, error.value);
        return;
      }
      isLoading.value = true;
      error.value = '';
      final response = await BaseClient.get(
        api: "${EndPoint.getCommissions}?userId=$userId",
      );

      if (response?.statusCode == 200) {
        final responseData = response?.data as Map<String, dynamic>?;
        if (responseData != null) {
          commissionResponse.value = CommissionResponse.fromJson(responseData);
          applyFiltersAndSort(); // Update filtered commissions after fetching
        } else {
          throw Exception('Response data is null');
        }
      } else {
        throw Exception('Failed to load commissions: ${response?.statusCode}');
      }
    } catch (e) {
      error.value = 'Error fetching commissions: $e';
      Get.snackbar('error'.tr, error.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submit() async {
    if (formKey.currentState!.validate()) {
      final model = BankModel(
        userId: int.parse(userId.toString()),
        accountHolderName: accountHolderName.value,
        accountNumber: accountNumber.value,
        ifscCode: ifscCode.value,
        bankName: bankName.value,
        upiId: upiId.value,
        phonePe: phonePe.value,
        googlePay: googlePay.value,
        paytm: paytm.value,
        bankDetailId: Bankid.value,
        createdDate: '',
        updatedDate: '',
      );
      final bankCtrl = Get.find<BankController>();
      await bankCtrl.addUpdate(model);
      Get.back();
    }
  }

  void openDialog() {
    final addCtrl = Get.put(BankController());
    addCtrl.init(bank.value, int.parse(userId.toString()));
    Get.dialog(const AddBankView());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
