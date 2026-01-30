import 'package:eekcchutkimein_delivery/constants/appstring.dart';
import 'package:eekcchutkimein_delivery/services/token_service.dart';
import 'package:get/get.dart';

class WalletApiService extends GetConnect {
  final String _baseUrl = AppString.baseUrl;

  Future<Response> fetchWalletHistory() async {
    try {
      final token = await TokenService.getAccessToken();
      return get(
        '$_baseUrl/delivery/employee/rider/wallet/history',
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
