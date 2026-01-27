import 'package:eekcchutkimein_delivery/features/orders_home/api/order_api_service.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/model/order_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final OrderApiService _apiService = OrderApiService();
  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final response = await _apiService.fetchOrders();
      debugPrint("ORDER LIST RESPONSE: ${response.statusCode}");

      if (response.statusCode == 200 && response.body != null) {
        final data = response.body;
        print('Order -------------- $data');
        if (data['data'] != null && data['data'] is List) {
          final List<dynamic> orderList = data['data'];
          orders.value = orderList
              .map((json) => OrderModel.fromJson(json))
              .toList();
          debugPrint("PARSED ${orders.length} ORDERS");
        }
      } else {
        debugPrint("FAILED TO FETCH ORDERS: ${response.body}");
      }
    } catch (e) {
      debugPrint("ERROR FETCHING ORDERS-catch: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<Response> startDelivery(int orderId) async {
    try {
      isLoading.value = true;
      final response = await _apiService.startDelivery(orderId);
      return response;
    } catch (e) {
      debugPrint("ERROR STARTING DELIVERY: $e");
      return Response(statusCode: 500, statusText: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
