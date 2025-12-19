import 'package:eekcchutkimein_delivery/features/homepage/api/dashboard_api.dart';
import 'package:eekcchutkimein_delivery/features/homepage/model/dashboard_model.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  var isLoadining = false.obs;
  final DashboardApi dashboardApi = DashboardApi();
  var dashboardData = Rxn<DashboardModel>();
  final errorMessage = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchDashboardDetails(); // 🚀 fetch data automatically when controller loads
  }

  Future<void> fetchDashboardDetails() async {
    try {
      isLoadining.value = true;
      // final response = await dashboardApi.fetchDashboardDetails();
      // dashboardData.value = response;
    } catch (e) {
      // Handle any errors here
      errorMessage.value = "Failed to fetch dashboard details: $e";
    } finally {
      isLoadining.value = false;
    }
  }
}
