import 'package:get/get.dart';

class RegistrationApiService extends GetConnect {
  final String _baseUrl = 'http://eekcchutkimein.com:5000';

  Future<Response> register(FormData formData) async {
    try {
      return post('$_baseUrl/employee/register', formData);
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }
}
