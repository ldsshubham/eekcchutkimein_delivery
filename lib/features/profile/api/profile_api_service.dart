import 'package:eekcchutkimein_delivery/constants/appstring.dart';
import 'package:eekcchutkimein_delivery/services/token_service.dart';
import 'package:get/get.dart';

class ProfileApiService extends GetConnect {
  final String _baseUrl = AppString.baseUrl;

  Future<Response> deleteProfile() async {
    try {
      final token = await TokenService.getAccessToken();
      return delete(
        '$_baseUrl/delivery/employee/rider/profile',
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
