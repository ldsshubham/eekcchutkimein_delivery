import 'package:eekcchutkimein_delivery/constants/appstring.dart';
import 'package:eekcchutkimein_delivery/services/token_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationApiService extends GetConnect {
  final String _baseUrl = AppString.baseUrl;

  Future<Response> uploadImage(XFile file) async {
    try {
      final token = await TokenService.getAccessToken();
      final formData = FormData({
        'file': MultipartFile(file.path, filename: file.name),
      });

      return post(
        '${_baseUrl}/uploads/',
        formData,
        headers: {if (token != null) 'Authorization': 'Bearer $token'},
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }

  Future<Response> register(Map<String, dynamic> data) async {
    try {
      final token = await TokenService.getAccessToken();
      print(
        'Registration API issue : ${data.toString()} and ${token.toString()}',
      );
      return post(
        '$_baseUrl/employee/register',
        data,
        contentType: 'application/json',
        headers: {
          if (token != null) 'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      print('Registration API issue : ${e.toString()}');
      return Response(statusCode: 500, statusText: e.toString());
    }
  }

  Future<Response> getRiderProfile() async {
    try {
      final token = await TokenService.getAccessToken();
      return get(
        '$_baseUrl/delivery/employee/rider/profile',
        headers: {if (token != null) 'Authorization': 'Bearer $token'},
      );
    } catch (e) {
      return Response(statusCode: 500, statusText: e.toString());
    }
  }
}
