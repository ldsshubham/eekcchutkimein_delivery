import 'package:eekcchutkimein_delivery/routes/routes.dart';
import 'package:eekcchutkimein_delivery/services/token_service.dart';
import 'package:eekcchutkimein_delivery/authentication/registration/api/registration_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final RegistrationApiService _registrationService = RegistrationApiService();

  @override
  void onReady() {
    super.onReady();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    final token = await TokenService.getAccessToken();
    debugPrint("ACCESS TOKEN $token");

    final profileResponse = await _registrationService.getRiderProfile();
    debugPrint("PROFILE RESPONSE $profileResponse");

    await Future.delayed(const Duration(seconds: 2));
    if (token != null && token.isNotEmpty) {
      print('PROFILE WE GET : ${profileResponse.body}');
      print('STATUS ${profileResponse.statusCode}');

      if (profileResponse.statusCode == 200 &&
          profileResponse.body['status'] == 'success') {
        print(
          'PROFILE ${profileResponse.statusCode} AND ${profileResponse.body['status']}',
        );
        Get.offNamed(AppRoutes.homepage);
      } else {
        Get.offNamed(AppRoutes.registration);
      }
    } else {
      Get.offNamed(AppRoutes.verifyPhone);
    }
  }
}
