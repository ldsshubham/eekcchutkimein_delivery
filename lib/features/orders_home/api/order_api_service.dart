import 'package:eekcchutkimein_delivery/constants/appstring.dart';
import 'package:eekcchutkimein_delivery/services/token_service.dart';
import 'package:get/get.dart';

class OrderApiService extends GetConnect {
  final String _baseUrl = AppString.baseUrl;

  Future<Response> fetchOrders() async {
    try {
      final token = await TokenService.getAccessToken();
      return get(
        '$_baseUrl/delivery/employee/rider/order-list',
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }

  Future<Response> startDelivery(int orderId) async {
    try {
      final token = await TokenService.getAccessToken();
      return post(
        '$_baseUrl/delivery/employee/start',
        {'orderId': orderId},
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }

  Future<Response> endDelivery({
    required int orderId,
    required String otp,
  }) async {
    try {
      final token = await TokenService.getAccessToken();
      return post(
        '$_baseUrl/delivery/employee/end',
        {"orderId": orderId, "otp": otp},
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }
}
