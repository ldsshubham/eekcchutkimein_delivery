import 'package:eekcchutkimein_delivery/authentication/registration/api/otp_verification.dart';
import 'package:eekcchutkimein_delivery/authentication/registration/api/registration_api_service.dart';
import 'package:eekcchutkimein_delivery/authentication/registration/otp_verification_screen.dart';
import 'package:eekcchutkimein_delivery/authentication/registration/registration_page.dart';
import 'package:eekcchutkimein_delivery/features/homepage/view/homepage.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/toastification_helper.dart';
import 'package:eekcchutkimein_delivery/services/token_service.dart';
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

  // Image IDs returned from sequential upload
  var selfieImageId = Rxn<int>();
  var panImageId = Rxn<int>();

  // Granular loading states for uploads
  var isSelfieUploading = false.obs;
  var isPanUploading = false.obs;

  Future<void> pickImage(ImageSource source, String type) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        if (type == 'selfie') {
          selfieImage.value = pickedFile;
          selfieImageId.value = null; // Reset ID if new image picked
        } else if (type == 'pan') {
          panImage.value = pickedFile;
          panImageId.value = null; // Reset ID if new image picked
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

  Future<void> uploadCapturedImage(String type) async {
    final file = type == 'selfie' ? selfieImage.value : panImage.value;
    if (file == null) {
      ToastHelper.showErrorToast(message: "No $type image selected");
      return;
    }

    if (type == 'selfie') {
      isSelfieUploading.value = true;
    } else {
      isPanUploading.value = true;
    }

    try {
      final response = await _registrationService.uploadImage(file);
      debugPrint(
        "UPLOAD RESPONSE ($type): ${response.statusCode} - ${response.body}",
      );

      if (response.statusCode == 200 && response.body != null) {
        final rawData = response.body['data'];
        final rawId = rawData != null ? rawData['id'] : null;

        // Robust ID parsing (handle String or Int from API)
        int? id;
        if (rawId is int) {
          id = rawId;
        } else if (rawId != null) {
          id = int.tryParse(rawId.toString());
        }

        if (id != null) {
          if (type == 'selfie') {
            selfieImageId.value = id;
          } else if (type == 'pan') {
            panImageId.value = id;
          }
          ToastHelper.showSuccessToast(message: "$type uploaded successfully");
        } else {
          ToastHelper.showErrorToast(
            message: "Failed to parse $type ID from response",
          );
        }
      } else {
        final errorMsg =
            response.body?['message']?.toString() ?? "Unknown error";
        ToastHelper.showErrorToast(
          message: "Failed to upload $type: $errorMsg",
        );
      }
    } catch (e) {
      debugPrint("UPLOAD ERROR ($type): $e");
      ToastHelper.showErrorToast(message: "Error uploading $type: $e");
    } finally {
      if (type == 'selfie') {
        isSelfieUploading.value = false;
      } else {
        isPanUploading.value = false;
      }
    }
  }

  Future<void> registerEmployee(Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      final response = await _registrationService.register(data);
      debugPrint(
        "REGISTER RESPONSE: ${response.statusCode} - ${response.body}",
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ToastHelper.showSuccessToast(
          message: "Registration completed successfully",
        );
      } else {
        final errorMsg =
            response.body?['message']?.toString() ?? "Registration failed";
        ToastHelper.showErrorToast(message: errorMsg);
      }
    } catch (e) {
      debugPrint("REGISTER ERROR: $e");
      ToastHelper.showErrorToast(message: "An unexpected error occurred: $e");
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
        );

        ToastHelper.showSuccessToast(message: "OTP Verified Successfully");

        // Check if profile exists
        final profileResponse = await _registrationService.getRiderProfile();

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
        ToastHelper.showErrorToast(message: errorMsg);
      }
    } catch (e) {
      ToastHelper.showErrorToast(message: "Verification failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
