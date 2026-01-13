// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';

// class BankController extends GetxController {
//   // var bankDetails = Rxn<BankDetailModel>();
//   final RxBool isLoading = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchBankDetails();
//   }

//   Future<void> fetchBankDetails() async {
//     // try {
//     //   isLoading.value = true;
//     //   final result = await BankApi.getBankDetails();
//     //   bankDetails.value = result; // can be null → that's fine
//     //   print("Bank Details controller--------------- ${bankDetails.value}");
//     // } catch (e) {
//     //   print("BankController.fetchBankDetails error: $e");
//     //   bankDetails.value = null; // explicitly set null on error
//     // } finally {
//     //   isLoading.value = false;
//     // }
//   }
// }
