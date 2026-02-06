import 'package:eekcchutkimein_delivery/features/orders_home/api/order_api_service.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/model/order_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final OrderApiService _apiService = OrderApiService();
  var orders = <OrderModel>[].obs;
  var isLoading = false.obs;

  // TEMPORARY: Add specific order IDs you want to show here
  final List<int> selectiveOrderIds = [
    2240,
    2241,
    2242,
    2243,
    2244,
    2263,
    2264,
    2265,
    2266,
    2267,
    2268,
    2269,
    2270,
    2271,
  ];

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final response = await _apiService.fetchOrders();
      debugPrint("ORDER LIST STATUS: ${response.statusCode}");
      debugPrint("ORDER LIST BODY: ${response.body}");

      if (response.statusCode == 200 && response.body != null) {
        final dynamic responseData = response.body;
        List<dynamic>? orderList;

        if (responseData is List) {
          orderList = responseData;
        } else if (responseData is Map) {
          if (responseData['data'] != null && responseData['data'] is List) {
            orderList = responseData['data'];
          } else if (responseData['orders'] != null &&
              responseData['orders'] is List) {
            orderList = responseData['orders'];
          }
        }

        if (orderList != null) {
          var allOrders = orderList
              .whereType<Map<String, dynamic>>()
              .map((json) => OrderModel.fromJson(json))
              .toList();

          // TEMPORARY: Filter by selective order IDs if list is not empty
          if (selectiveOrderIds.isNotEmpty) {
            orders.value = allOrders
                .where((order) => selectiveOrderIds.contains(order.orderId))
                .toList();
            debugPrint(
              "FILTERED ${orders.length} ORDERS from selective IDs: $selectiveOrderIds",
            );
          } else {
            // If no selective IDs, show all orders (old behavior without .take(5))
            orders.value = allOrders;
            debugPrint("PARSED ${orders.length} ORDERS (no filter applied)");
          }
        } else {
          debugPrint("NO ORDER LIST FOUND IN RESPONSE DATA");
          orders.clear();
        }
      } else {
        debugPrint(
          "FAILED TO FETCH ORDERS: Status ${response.statusCode}, Body: ${response.body}",
        );
        // Optional: clear orders or keep old ones?
        // orders.clear();
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
      print('Start Delivery Response: ${response.body}');
      return response;
    } catch (e) {
      debugPrint("ERROR STARTING DELIVERY: $e");
      return Response(statusCode: 500, statusText: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<Response> endDelivery(int orderId, String otp) async {
    try {
      isLoading.value = true;
      final response = await _apiService.endDelivery(orderId, otp);
      return response;
    } catch (e) {
      debugPrint("ERROR ENDING DELIVERY: $e");
      return Response(statusCode: 500, statusText: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
