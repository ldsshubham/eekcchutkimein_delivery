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
}
