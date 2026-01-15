// import 'package:flutter/widgets.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// // import '../../../routing/apppages.dart';

// class LoginController extends GetxController {
//   final mobileController = TextEditingController();
//   final otpController = TextEditingController();
//   var currentStep = 0.obs;
//   var isMobileValid = false.obs;
//   var isLoading = false.obs;
//   // String? _serverOtp;

//   bool _isMobileValidFunction(String number) {
//     final RegExp mobileNumber = RegExp(r'^\+?[6-9]\d{9}$');
//     final trimmed = number.trim();
//     final valid = mobileNumber.hasMatch(trimmed);
//     // if (!valid) {
//     //   ToastHelper.showErrorToast(message: 'Invalid Mobile Number');
//     // }
//     return valid;
//   }

//   Future<String?> requestOtp() async {
//     final number = mobileController.text;
//     if (!_isMobileValidFunction(number)) return null;
//     try {
//       isLoading.value = true;
//       print("Requesting OTP for: $number");
//       // final otp = await OtpApiServices.requestOTP(number);
//       otpController.text = otp;
//       // _serverOtp = otp;
//       otpController.clear();
//       ToastHelper.showSuccessToast(message: 'OTP sent successfully to $number');
//       goToNextStep();
//       print("OTP requested successfully: $otp");
//       return otp;
//     } catch (e, stackTrace) {
//       print("❌ Exception caught: $e");
//       print("📛 StackTrace: $stackTrace");
//       ToastHelper.showErrorToast(
//         message: 'Failed to request OTP. Please try again.',
//       );
//       return null;
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   Future<void> verifyOtpAndSaveOtp(String otp) async {
//     print('step1');
//     if (!_isMobileValidFunction(mobileController.text)) return;

//     try {
//       isLoading.value = true;
//       print('under try');

//       // 1️⃣ Verify OTP
//       final TokenModel tokenModel = await OtpApiServices.verifyOtp(
//         mobileController.text,
//         otp,
//       );

//       // 2️⃣ Save tokens
//       final storage = const FlutterSecureStorage();
//       final tempStorage = GetStorage();

//       await storage.write(key: 'accessToken', value: tokenModel.accessToken);
//       await storage.write(key: 'refreshToken', value: tokenModel.refreshToken);
//       await tempStorage.write('skipLogin', true);

//       // 3️⃣ Read saved pincode
//       final String? pincode = tempStorage.read('userPincode');
//       // final String? denied = tempStorage.read('locationDeclined');

//       // final String? pincode;;
//       print("Using pincode: $pincode");

//       if (pincode == null) {
//         ToastHelper.showErrorToast(message: 'Location not detected');
//         // if (denied == true || denied == null) {
//         //   Get.offAll(NotFoundAppLocation());
//         // }
//         Get.offAllNamed(AppRoutes.comingSoonPage);
//         return;
//       }

//       // Call PINCODE API
//       final bool isServiceable = await FeatureShopApi.checkPincodeFeature(
//         pincode,
//       );

//       print('IS THIS SERVICEABLE: $isServiceable');

//       // 5️⃣ Navigate based on response
//       if (isServiceable) {
//         ToastHelper.showSuccessToast(message: 'OTP Verified Successfully');
//         Get.offAllNamed(AppRoutes.home);
//       } else {
//         Get.offAllNamed(AppRoutes.comingSoonPage);
//       }
//     } catch (e) {
//       ToastHelper.showErrorToast(
//         message: 'Verification failed. Please try again.',
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void logOutUser() async {
//     final tempstorage = GetStorage();
//     final storage = FlutterSecureStorage();
//     try {
//       clearFields();
//       Get.offAll(LoginScreen());
//       await tempstorage.erase();
//       await storage.deleteAll();
//       ToastHelper.showSuccessToast(message: 'Logged out successfully');
//     } catch (e) {
//       print("Error during logout: $e");
//       throw Exception('Failed to log out. Please try again.');
//     }
//   }

//   void clearFields() {
//     currentStep.value = 0;
//     mobileController.clear();
//     otpController.clear();
//   }

//   void goToNextStep() {
//     currentStep.value++;
//   }
// }

// extension on Future<TokenModel> {
//   String? get accessToken => null;
// }
