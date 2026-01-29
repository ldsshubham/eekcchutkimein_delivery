import 'package:eekcchutkimein_delivery/authentication/registration/api/registration_api_service.dart';
import 'package:eekcchutkimein_delivery/features/profile/profile_model.dart';
import 'package:eekcchutkimein_delivery/features/profile/api/profile_api_service.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/toastification_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final RegistrationApiService _registrationApiService = Get.put(
    RegistrationApiService(),
  );
  final ProfileApiService _profileApiService = Get.put(ProfileApiService());

  var isLoading = true.obs;
  var profile = Rxn<DeliveryPartnerProfile>();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading(true);
      final response = await _registrationApiService.getRiderProfile();

      if (response.statusCode == 200 && response.body['status'] == 'success') {
        final List data = response.body['data'];
        if (data.isNotEmpty) {
          profile.value = DeliveryPartnerProfile.fromJson(data[0]);
        }
      } else {
        Get.snackbar("Error", "Failed to fetch profile");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? fatherName,
    String? dob,
    String? email,
  }) async {
    try {
      isLoading(true);
      final Map<String, dynamic> data = {};
      if (firstName != null) data['firstName'] = firstName;
      if (lastName != null) data['lastName'] = lastName;
      if (fatherName != null) data['fatherName'] = fatherName;
      // if (dob != null) data['dob'] = dob;
      if (email != null) data['email'] = email;

      final response = await _profileApiService.updateProfile(data);

      if (response.statusCode == 200 && response.body['status'] == 'success') {
        ToastHelper.showSuccessToast(
          message: response.body['message'] ?? "Profile Updated Successfully!",
        );
        await fetchProfile(); // Refresh profile data
      } else {
        print("UPDATE ${response.status} ${response.body}");
        ToastHelper.showErrorToast(
          response.body['message'] ?? "Failed to update profile",
          message: '',
        );
        // Get.snackbar(
        //   "Error",
        //   response.body['message'] ?? "Failed to update profile",
        //   snackPosition: SnackPosition.BOTTOM,
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        // );
      }
    } catch (e) {
      ToastHelper.showErrorToast("Something went wrong: $e", message: '');
      // Get.snackbar(
      //   "Error",
      //   "Something went wrong: $e",
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
    } finally {
      isLoading(false);
    }
  }
}
