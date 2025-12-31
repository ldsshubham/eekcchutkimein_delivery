import 'package:get/get.dart';
import '../api/balance_api.dart';
import '../model/balance_model.dart';

class BalanceController extends GetxController {
  var isLoading = true.obs;
  var balanceData = Rxn<BalanceResponse>();

  @override
  void onInit() {
    fetchBalance();
    super.onInit();
  }

  Future<void> fetchBalance() async {
    try {
      isLoading.value = true;
      balanceData.value = await BalanceApi.fetchBalance();
    } finally {
      isLoading.value = false;
    }
  }
}
