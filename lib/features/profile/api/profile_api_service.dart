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

  Future<Response> getRiderProfile() async {
    try {
      final token = await TokenService.getAccessToken();
      return get(
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

  Future<Response> updateProfile(Map<String, dynamic> data) async {
    try {
      final token = await TokenService.getAccessToken();
      return post(
        '$_baseUrl/delivery/employee/rider/update/profile',
        data,
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }

  Future<Response> updateAvailability(bool availability) async {
    try {
      final token = await TokenService.getAccessToken();
      return post(
        '$_baseUrl/delivery/employee/rider/availability',
        {'availability': availability},
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
