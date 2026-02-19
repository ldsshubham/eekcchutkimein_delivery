import 'package:eekcchutkimein_delivery/authentication/api/otp_verification.dart';
import 'package:eekcchutkimein_delivery/authentication/api/registration_api_service.dart';
import 'package:eekcchutkimein_delivery/authentication/otp_verify.dart';
import 'package:eekcchutkimein_delivery/authentication/registration_page.dart';
import 'package:eekcchutkimein_delivery/features/homepage/view/homepage.dart';
import 'package:eekcchutkimein_delivery/helper/toastification_helper.dart';
import 'package:eekcchutkimein_delivery/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationController extends GetxController {
  final OtpVerificationService _otpService = OtpVerificationService();
  final RegistrationApiService _registrationService = Get.put(
    RegistrationApiService(),
  );
  final ImagePicker _picker = ImagePicker();

  var isLoading = false.obs;

  // Image observables
  var selfieImage = Rxn<XFile>();
  var panImage = Rxn<XFile>();

  // Image IDs returned from sequential upload
  var selfieImageId = Rxn<int>();
  var panImageId = Rxn<int>();

  Future<void> registerEmployee(Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      print('Registration API issue : ${data.toString()}');
      final response = await _registrationService.register(data);
      debugPrint(
        "REGISTER RESPONSE: ${response.statusCode} - ${response.body}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastHelper.showSuccessToast(
          message: "Registration completed successfully",
        );
        Get.to(() => const Homepage());
      } else {
        final errorMsg =
            response.body?['message']?.toString() ?? "Registration failed";

        ToastHelper.showErrorToast("Registration failed", subMessage: errorMsg);
      }
    } catch (e) {
      debugPrint("REGISTER ERROR: $e");
      ToastHelper.showErrorToast(
        "An unexpected error occurred",
        subMessage: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendOtp(String phone) async {
    isLoading.value = true;
    try {
      final response = await _otpService.sendOtp(phone);
      debugPrint(
        "SEND OTP RESPONSE: ${response.statusCode} - ${response.body}",
      );
      if (response.statusCode == 200 && response.body != null) {
        String otpValue = "";
        print("OTP VALUE: ${response.body['data']}");
        if (response.body['data'] is Map) {
          otpValue = (response.body['data']['otp']).toString();
        } else {
          otpValue = response.body['data'].toString();
        }

        Get.to(() => OtpVerificationScreen(phoneNumber: phone, otp: otpValue));
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

  Future<void> verifyOtp(String phone, String otp) async {
    isLoading.value = true;
    try {
      final response = await _otpService.verifyOtp(phone, otp);
      debugPrint(
        "VERIFY OTP RESPONSE: ${response.statusCode} - ${response.body}",
      );

      if (response.statusCode == 200 && response.body != null) {
        final data = response.body['data'];
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];

        // Save tokens
        await TokenService.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken,
          phone: phone,
        );

        ToastHelper.showSuccessToast(message: "OTP Verified Successfully");

        // Check if profile exists
        final profileResponse = await _registrationService.getRiderProfile();
        print("RIDER PROFILE : ${profileResponse.body}");

        if (profileResponse.statusCode == 200 &&
            profileResponse.body != null &&
            profileResponse.body['status'] == 'success') {
          // Profile exists, go to Homepage
          Get.offAll(() => const Homepage());
        } else {
          // Profile does not exist or error, go to Registration Page
          Get.offAll(() => RegistrationPage(phoneNumber: phone));
        }
      } else {
        String errorMsg = response.body?['message'] ?? "Invalid OTP";
        ToastHelper.showErrorToast(errorMsg);
      }
    } catch (e) {
      ToastHelper.showErrorToast(
        "Verification failed",
        subMessage: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
