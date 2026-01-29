import 'package:eekcchutkimein_delivery/features/orders_home/api/order_api_service.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/toastification_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TowardsCustomerController extends GetxController {
  final OrderApiService _apiService = OrderApiService();

  // Observable variables for payment state
  RxBool isPaymentCollected = false.obs;
  RxBool isPaymentVerified = false.obs;
  RxBool isLoading = false.obs;

  // Toggle "Collect Cash" state
  void toggleCashCollection() {
    isPaymentCollected.value = !isPaymentCollected.value;
    _checkTotalPaymentStatus();
  }

  // Handle successful QR payment
  void confirmQrPayment() {
    isPaymentVerified.value = true;
    _checkTotalPaymentStatus();
  }

  // Internal check to update overall status if needed
  // For now, if either method is successful, we consider it done.
  void _checkTotalPaymentStatus() {
    if (isPaymentCollected.value || isPaymentVerified.value) {
      // Logic for overall completion can go here
    }
  }

  // Reset state (if needed for testing or new order)
  void resetPaymentState() {
    isPaymentCollected.value = false;
    isPaymentVerified.value = false;
  }

  Future<bool> endDelivery({required int orderId, required String otp}) async {
    try {
      isLoading.value = true;
      final response = await _apiService.endDelivery(
        orderId: orderId,
        otp: otp,
      );

      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          response.body['message'] ?? "Operation successful",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          response.body['message'] ?? "Something went wrong",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Connection failed",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
