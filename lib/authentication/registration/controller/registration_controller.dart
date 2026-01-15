import 'package:eekcchutkimein_delivery/authentication/registration/api/otp_verification.dart';
import 'package:eekcchutkimein_delivery/authentication/registration/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationController extends GetxController {
  final OtpVerificationService _apiService = OtpVerificationService();
  var isLoading = false.obs;

  Future<void> sendOtp(String phone) async {
    isLoading.value = true;
    print("DEBUG: Sending OTP to $phone");
    try {
      final response = await _apiService.sendOtp(phone);
      print("DEBUG: Response Status: ${response.statusCode}");
      print("DEBUG: Response Body: ${response.body}");

      if (response.statusCode == 200 &&
          response.body != null &&
          response.body['status'] == 'success') {
        Get.snackbar(
          "Success",
          "OTP sent successfully",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.to(
          () => OtpVerificationScreen(
            phoneNumber: phone,
            otp: response.body['data'],
          ),
        );
      } else {
        String errorMsg = "Failed to send OTP";
        if (response.body != null && response.body['message'] != null) {
          errorMsg = response.body['message'];
        } else if (response.statusText != null) {
          errorMsg = response.statusText!;
        }

        Get.snackbar(
          "Error",
          errorMsg,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print("DEBUG: Error in sendOtp: $e");
      Get.snackbar(
        "Error",
        "An error occurred: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
