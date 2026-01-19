import 'package:eekcchutkimein_delivery/authentication/registration/api/registration_api_service.dart';
import 'package:eekcchutkimein_delivery/features/profile/profile_model.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final RegistrationApiService _apiService = Get.put(RegistrationApiService());

  var isLoading = true.obs;
  var profile = Rxn<DeliveryPartnerProfile>();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  void fetchProfile() async {
    try {
      isLoading(true);
      final response = await _apiService.getRiderProfile();

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
}
