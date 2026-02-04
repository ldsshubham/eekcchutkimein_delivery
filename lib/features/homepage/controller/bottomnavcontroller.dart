import 'package:eekcchutkimein_delivery/features/homepage/controller/dashboard_controller.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/controller/order_controller.dart';
import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var currentPage = 0.obs;
  void changePage(int index) {
    currentPage.value = index;
    // Trigger refreshes when switching tabs
    if (index == 0) {
      Get.find<DashboardController>().fetchDashboardDetails();
    } else if (index == 1) {
      Get.find<OrderController>().fetchOrders();
    }
  }
}
