import 'package:eekcchutkimein_delivery/features/ordercompleted/view/ordercomplete_screen.dart';
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

  Future<bool> endDelivery(int orderId, String otp) async {
    try {
      isLoading.value = true;
      final response = await _apiService.endDelivery(orderId, otp);

      if (response.statusCode == 200) {
        ToastHelper.showSuccessToast(
          message: response.body['message'] ?? "Operation successful",
        );
        return true;
      } else {
        ToastHelper.showErrorToast(
          response.body['message'] ?? 'Operation failed',
        );
        return false;
      }
    } catch (e) {
      ToastHelper.showErrorToast("Connection failed");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> cancelOrder(int orderId, String reason) async {
    try {
      isLoading.value = true;
      final response = await _apiService.cancelOrder(orderId, reason);
      print("CANCEL RESPOSNE ${response.body}");

      if (response.statusCode == 200) {
        ToastHelper.showSuccessToast(
          message: response.body['message'] ?? "Order cancelled successfully",
        );
        return true;
      } else {
        print("CANCEL RESPOSNE:ERROR ${response.body}");
        ToastHelper.showErrorToast(
          response.body['message'] ?? 'Cancellation failed',
        );
        return false;
      }
    } catch (e) {
      ToastHelper.showErrorToast("Connection failed");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
