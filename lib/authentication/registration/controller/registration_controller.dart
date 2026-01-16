import 'package:eekcchutkimein_delivery/authentication/registration/api/otp_verification.dart';
import 'package:eekcchutkimein_delivery/authentication/registration/api/registration_api_service.dart';
import 'package:eekcchutkimein_delivery/authentication/registration/otp_verification_screen.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/toastification_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class RegistrationController extends GetxController {
  final OtpVerificationService _otpService = OtpVerificationService();
  final RegistrationApiService _registrationService = RegistrationApiService();
  final ImagePicker _picker = ImagePicker();

  var isLoading = false.obs;

  // Image observables
  var selfieImage = Rxn<XFile>();
  var panImage = Rxn<XFile>();

  Future<void> pickImage(ImageSource source, String type) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        if (type == 'selfie') {
          selfieImage.value = pickedFile;
        } else if (type == 'pan') {
          panImage.value = pickedFile;
        }
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to pick image: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  Future<void> registerEmployee(Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      final formData = FormData({
        ...data,
        if (selfieImage.value != null)
          'selfie': MultipartFile(
            selfieImage.value!.path,
            filename: 'selfie.jpg',
          ),
        if (panImage.value != null)
          'pan': MultipartFile(panImage.value!.path, filename: 'pan.jpg'),
      });

      final response = await _registrationService.register(formData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastHelper.showSuccessToast(
          message: "Registration completed successfully",
        );
      } else {
        ToastHelper.showErrorToast(
          message: "Registration failed ${response.body['message']}",
        );
      }
    } catch (e) {
      ToastHelper.showErrorToast(message: "An unexpected error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendOtp(String phone) async {
    isLoading.value = true;
    print("DEBUG: Sending OTP to $phone");
    try {
      final response = await _otpService.sendOtp(phone);
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
