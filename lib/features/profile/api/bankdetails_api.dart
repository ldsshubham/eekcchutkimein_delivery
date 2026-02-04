import 'package:eekcchutkimein_delivery/constants/appstring.dart';
import 'package:eekcchutkimein_delivery/services/token_service.dart';
import 'package:get/get_connect.dart';

class BankDetailsApi extends GetConnect {
  final _baseUrl = AppString.baseUrl;

  Future<Response> getBankDetails() async {
    try {
      final token = await TokenService.getAccessToken();
      return await get(
        '${_baseUrl}/customer/bank/getdetails',
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      return Future.value(Response(statusCode: 500, statusText: e.toString()));
    }
  }
}
