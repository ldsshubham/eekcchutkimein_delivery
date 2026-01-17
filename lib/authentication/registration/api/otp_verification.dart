import 'package:get/get.dart';

class OtpVerificationService extends GetConnect {
  final String _baseUrl = 'http://eekcchutkimein.com:5000';

  Future<Response> sendOtp(String phone) async {
    try {
      final body = {"phone": int.parse(phone), "role": "rider"};

      return post('$_baseUrl/employee/send-otp', body);
    } catch (e) {
      return Future.value(Response(statusCode: 500, statusText: e.toString()));
    }
  }

  Future<Response> verifyOtp(String phone, String otp) async {
    try {
      final body = {"phone": phone, "otp": otp};
      return post('$_baseUrl/auth/customer/verify-otp', body);
    } catch (e) {
      return Future.value(Response(statusCode: 500, statusText: e.toString()));
    }
  }
}
