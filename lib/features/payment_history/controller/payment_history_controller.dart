import 'package:eekcchutkimein_delivery/features/payment_history/api/wallet_api_service.dart';
import 'package:eekcchutkimein_delivery/features/payment_history/model/wallet_history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentHistoryController extends GetxController {
  final WalletApiService _apiService = WalletApiService();

  var isLoading = true.obs;
  var historyList = <WalletHistoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      isLoading.value = true;
      final response = await _apiService.fetchWalletHistory();

      if (response.statusCode == 200 && response.body != null) {
        final walletResponse = WalletHistoryResponse.fromJson(response.body);
        historyList.assignAll(walletResponse.data);
      } else {
        Get.snackbar(
          "Error",
          "Failed to fetch history: ${response.statusText}",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
