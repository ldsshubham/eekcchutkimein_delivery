import 'package:eekcchutkimein_delivery/features/wallet_history/wallet_api_service.dart';
import 'package:eekcchutkimein_delivery/features/wallet_history/wallet_history_model.dart';
import 'package:eekcchutkimein_delivery/helper/toastification_helper.dart';
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
      } else if (response.statusCode == 404) {
        historyList.clear();
      } else {
        ToastHelper.showErrorToast(
          "Failed to fetch history: ${{response.statusText}}",
        );
      }
    } catch (e) {
      ToastHelper.showErrorToast("An unexpected error occurred");
    } finally {
      isLoading.value = false;
    }
  }
}
