import 'package:eekcchutkimein_delivery/authentication/registration/api/registration_api_service.dart';
import 'package:eekcchutkimein_delivery/features/profile/profile_model.dart';
import 'package:eekcchutkimein_delivery/features/profile/api/profile_api_service.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/toastification_helper.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  final RegistrationApiService _registrationApiService = Get.put(
    RegistrationApiService(),
  );
  final ProfileApiService _profileApiService = Get.put(ProfileApiService());

  var isLoading = true.obs;
  var profile = Rxn<DeliveryPartnerProfile>();
  var isOnline = true.obs;
  final _box = GetStorage();
  DateTime? _lastToggleTime;

  @override
  void onInit() {
    super.onInit();
    // Default to true if never set, otherwise use persisted value
    isOnline.value = _box.read('isOnline') ?? true;
    _lastToggleTime = DateTime.now();
    fetchProfile();
  }

  Future<void> toggleAvailability(bool value) async {
    try {
      // Optimistic update
      final previousValue = isOnline.value;
      isOnline.value = value;
      _box.write('isOnline', value);
      _lastToggleTime = DateTime.now();

      final response = await _profileApiService.updateAvailability(value);

      // Relaxed success check: as long as it's 2xx and doesn't explicitly fail
      final isSuccess =
          response.status.isOk &&
          (response.body == null ||
              response.body['status'] == 'success' ||
              response.body['status'] == 200 ||
              response.body['message']?.toString().toLowerCase().contains(
                    'success',
                  ) ==
                  true);

      if (isSuccess) {
        ToastHelper.showSuccessToast(
          message:
              response.body?['message'] ??
              "Availability updated to ${value ? 'Online' : 'Offline'}",
        );
      } else {
        // Revert on failure
        isOnline.value = previousValue;
        _box.write('isOnline', previousValue);
        ToastHelper.showErrorToast(
          "Failed to update availability",
          subMessage: response.body?['message'] ?? 'Response error',
        );
      }
    } catch (e) {
      // Revert on error
      isOnline.value = !value;
      _box.write('isOnline', !value);
      ToastHelper.showErrorToast(
        "Something went wrong",
        subMessage: e.toString(),
      );
    }
  }

  Future<void> fetchProfile() async {
    try {
      isLoading(true);
      final response = await _registrationApiService.getRiderProfile();

      if (response.statusCode == 200 && response.body['status'] == 'success') {
        final List data = response.body['data'];
        if (data.isNotEmpty) {
          final profileData = DeliveryPartnerProfile.fromJson(data[0]);
          profile.value = profileData;

          // Sync online status with backend value, but ignore if a toggle just happened
          // or if the app just started (wait at least 15 seconds for stability)
          final timeSinceToggle = _lastToggleTime == null
              ? const Duration(seconds: 0)
              : DateTime.now().difference(_lastToggleTime!);

          if (timeSinceToggle.inSeconds > 15) {
            if (isOnline.value != profileData.isOnline) {
              isOnline.value = profileData.isOnline;
              _box.write('isOnline', profileData.isOnline);
            }
          }
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

  Future<void> deleteProfile() async {
    isLoading(true);
    try {
      print("=== DELETE PROFILE START ===");
      print("Partner ID: ${profile.value!.partnerId}");

      final response = await _registrationApiService.deleteProfile(
        profile.value!.partnerId,
      );

      print("DELETE RESPONSE Status Code: ${response.statusCode}");
      print("DELETE RESPONSE Body: ${response.body}");
      print("DELETE RESPONSE Body Type: ${response.body.runtimeType}");

      if (response.body != null && response.body is Map) {
        print("DELETE RESPONSE Status Field: ${response.body['status']}");
        print("DELETE RESPONSE Message Field: ${response.body['message']}");
      }

      if (response.statusCode == 200 && response.body['status'] == 'success') {
        print("✅ DELETE SUCCESS - Navigating to login");
        ToastHelper.showSuccessToast(
          message: response.body['message'] ?? "Profile deleted successfully!",
        );
        _box.write('isOnline', false);
        Get.offAllNamed('/login');
      } else {
        print(
          "❌ DELETE FAILED - Status: ${response.statusCode}, Body Status: ${response.body?['status']}",
        );
        ToastHelper.showErrorToast(
          response.body['message'] ?? "Failed to delete profile",
        );
      }
    } catch (e) {
      print("❌ DELETE ERROR - Exception: $e");
      ToastHelper.showErrorToast(
        "Something went wrong",
        subMessage: e.toString(),
      );
    } finally {
      isLoading(false);
      print("=== DELETE PROFILE END ===");
    }
  }

  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? fatherName,
    String? dob,
    String? email,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? state,
    String? pinCode,
    String? vehicleType,
    String? vehicleNumber,
    String? vehicleName,
    String? licenseNumber,
  }) async {
    try {
      isLoading(true);
      final Map<String, dynamic> data = {};
      if (firstName != null) data['firstName'] = firstName;
      if (lastName != null) data['lastName'] = lastName;
      if (fatherName != null) data['fatherName'] = fatherName;
      if (dob != null) data['dob'] = dob;
      if (email != null) data['email'] = email;
      if (addressLine1 != null) data['Addressline_1'] = addressLine1;
      if (addressLine2 != null) data['Addressline_2'] = addressLine2;
      if (city != null) data['city'] = city;
      if (state != null) data['state'] = state;
      if (pinCode != null) data['pinCode'] = int.tryParse(pinCode) ?? 0;
      if (vehicleType != null) data['vehicleType'] = vehicleType;
      if (vehicleNumber != null) data['vehicleNumber'] = vehicleNumber;
      if (vehicleName != null) data['vehicleName'] = vehicleName;
      if (licenseNumber != null) data['license_number'] = licenseNumber;

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
        );
      }
    } catch (e) {
      ToastHelper.showErrorToast(
        "Something went wrong",
        subMessage: e.toString(),
      );
    } finally {
      isLoading(false);
    }
  }
}
