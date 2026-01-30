import 'package:eekcchutkimein_delivery/authentication/registration/api/registration_api_service.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/toastification_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PickImageController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final RegistrationApiService _registrationService = RegistrationApiService();

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

  Future<void> resetImage(String type) async {
    if (type == 'selfie') {
      selfieImage.value = null;
      selfieImageId.value = null;
    } else if (type == 'pan') {
      panImage.value = null;
      panImageId.value = null;
    }
  }

  Future<void> uploadCapturedImage(String type) async {
    final file = type == 'selfie' ? selfieImage.value : panImage.value;
    if (file == null) {
      ToastHelper.showErrorToast("No $type image selected", message: '');
      return;
    }

    if (type == 'selfie') {
      isSelfieUploading.value = true;
    } else {
      isPanUploading.value = true;
    }

    try {
      debugPrint("STARTING UPLOAD ($type): ${file.path}");
      final response = await _registrationService.uploadImage(file);
      debugPrint("UPLOAD RESPONSE ($type) STATUS: ${response.statusCode}");
      debugPrint("UPLOAD RESPONSE ($type) BODY: ${response.body}");

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.body != null) {
        final rawData = response.body['data'];
        debugPrint("PARSING UPLOAD ID ($type) FROM: $rawData");
        final rawId = rawData != null ? rawData['id'] : null;

        // Robust ID parsing (handle String or Int from API)
        int? id;
        if (rawId is int) {
          id = rawId;
          debugPrint("ID PARSED AS INT: $id");
        } else if (rawId != null) {
          id = int.tryParse(rawId.toString());
          debugPrint("ID PARSED VIA TRYPARSE: $id");
        }

        if (id != null) {
          if (type == 'selfie') {
            selfieImageId.value = id;
          } else if (type == 'pan') {
            panImageId.value = id;
          }
          ToastHelper.showSuccessToast(message: "$type uploaded successfully");
          debugPrint("UPLOAD SUCCESS ($type): ID set to $id");
        } else {
          debugPrint("FAILED TO PARSE ID ($type): rawId was $rawId");
          ToastHelper.showErrorToast(
            "Failed to parse $type ID from response",
            message: '',
          );
        }
      } else {
        final errorMsg =
            (response.body is Map && response.body['message'] != null)
            ? response.body['message'].toString()
            : "Server error (${response.statusCode})";
        debugPrint("UPLOAD FAILED ($type): $errorMsg");
        ToastHelper.showErrorToast(
          "Failed to upload $type: $errorMsg",
          message: '',
        );
      }
    } catch (e, stackTrace) {
      debugPrint("UPLOAD ERROR ($type) EXCEPTION: $e");
      debugPrint("UPLOAD ERROR ($type) STACKTRACE: $stackTrace");
      ToastHelper.showErrorToast("Error uploading $type: $e", message: '');
    } finally {
      if (type == 'selfie') {
        isSelfieUploading.value = false;
      } else {
        isPanUploading.value = false;
      }
    }
  }
}
