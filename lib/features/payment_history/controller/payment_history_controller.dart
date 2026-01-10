import 'package:get/get.dart';
import '../model/payment_history_model.dart';

class PaymentHistoryController extends GetxController {
  var isLoading = true.obs;
  var historyList = <PaymentHistoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  void fetchHistory() async {
    try {
      isLoading.value = true;
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock Data - similar to what might come from backend
      var mockData = [
        PaymentHistoryItem(
          orderId: "#ORD-78452",
          amount: 85.0,
          date: "30 Dec, 4:15 PM",
          isCredit: true,
          description: "Order Delivered",
        ),
        PaymentHistoryItem(
          orderId: "#ORD-78421",
          amount: 120.0,
          date: "30 Dec, 2:10 PM",
          isCredit: true,
          description: "Order Delivered",
        ),
        PaymentHistoryItem(
          orderId: "#ORD-78311",
          amount: 60.0,
          date: "29 Dec, 9:30 PM",
          isCredit: false,
          description: "Cash Collected",
        ),
        PaymentHistoryItem(
          orderId: "#INC-001",
          amount: 500.0,
          date: "25 Dec, 10:00 AM",
          isCredit: true,
          description: "Weekly Incentive",
        ),
         PaymentHistoryItem(
          orderId: "#ORD-78100",
          amount: 45.0,
          date: "24 Dec, 1:15 PM",
          isCredit: true,
          description: "Order Delivered",
        ),
      ];

      historyList.assignAll(mockData);
    } finally {
      isLoading.value = false;
    }
  }
}
