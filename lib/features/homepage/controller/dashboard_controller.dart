import 'package:eekcchutkimein_delivery/features/homepage/api/dashboard_api.dart';
import 'package:eekcchutkimein_delivery/features/homepage/model/dashboard_model.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var isLoadining = false.obs;
  final DashboardApi dashboardApi = DashboardApi();
  var dashboardData = Rx<DashboardModel>(
    DashboardModel(
      deliveryBoyId: 0,
      totalOrders: "0",
      pendingOrders: "0",
      deliveredOrders: "0",
      assignedToday: "0",
      totalEarnings: "0",
    ),
  );
  final errorMessage = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchDashboardDetails(); // 🚀 fetch data automatically when controller loads
  }

  Future<void> fetchDashboardDetails() async {
    try {
      isLoadining.value = true;
      await Future.delayed(const Duration(milliseconds: 800));
      final response = await dashboardApi.fetchDashboardDetails();
      dashboardData.value = response;
    } catch (e) {
      // On error, show 0 values instead of error message
      dashboardData.value = DashboardModel(
        deliveryBoyId: 0,
        totalOrders: "0",
        pendingOrders: "0",
        deliveredOrders: "0",
        assignedToday: "0",
        totalEarnings: "0",
      );
    } finally {
      isLoadining.value = false;
    }
  }
}
