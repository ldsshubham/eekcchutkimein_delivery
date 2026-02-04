import 'dart:convert';
import 'package:eekcchutkimein_delivery/features/ordercompleted/view/ordercomplete_screen.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/api/order_api_service.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/model/order_detail_model.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/toastification_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TowardsCustomerController extends GetxController {
  final OrderApiService _apiService = OrderApiService();

  // Observable variables for payment state
  RxBool isPaymentCollected = false.obs;
  RxBool isPaymentVerified = false.obs;
  RxBool isLoading = false.obs;
  Rxn<OrderDetailResponse> orderDetails = Rxn<OrderDetailResponse>();

  Future<void> fetchOrderDetails(int orderId) async {
    try {
      isLoading.value = true;
      final response = await _apiService.fetchOrderDetails(orderId);
      print("FETCH STATUS: ${response.statusCode}");
      print("FETCH BODY: ${response.body}");

      if (response.statusCode == 200) {
        var body = response.body;
        print("FETCH ORDER DETAILS BODY TYPE: ${body.runtimeType}");
        if (body is String) {
          try {
            body = jsonDecode(body);
          } catch (e) {
            print("JSON DECODE ERROR: $e");
          }
        }

        if (body is Map<String, dynamic>) {
          orderDetails.value = OrderDetailResponse.fromJson(body);
        } else {
          print("UNEXPECTED BODY TYPE: ${body.runtimeType} - $body");
          ToastHelper.showErrorToast("Invalid server response format");
        }
      } else {
        var message = "Failed to fetch order details";
        if (response.body is Map && response.body.containsKey('message')) {
          message = response.body['message'];
        } else if (response.body is String) {
          message = response.body;
        }
        ToastHelper.showErrorToast(message);
      }
    } catch (e) {
      print("FETCH ORDER DETAILS EXCEPTION: $e");
      ToastHelper.showErrorToast("Connection failed");
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle "Collect Cash" state
  void toggleCashCollection() {
    isPaymentCollected.value = !isPaymentCollected.value;
    _checkTotalPaymentStatus();
  }

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

  Future<dynamic> endDelivery(int orderId, String otp) async {
    try {
      isLoading.value = true;
      final response = await _apiService.endDelivery(orderId, otp);

      if (response.statusCode == 200) {
        ToastHelper.showSuccessToast(
          message: response.body['message'] ?? "Operation successful",
        );
        return response.body['data']; // Return earnings amount
      } else {
        ToastHelper.showErrorToast(
          response.body['message'] ?? 'Operation failed',
        );
        return null;
      }
    } catch (e) {
      ToastHelper.showErrorToast("Connection failed");
      return null;
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

  Future<bool> collectPayment(int orderId, String mode) async {
    try {
      isLoading.value = true;
      final response = await _apiService.collectPayment(orderId, mode);
      print("COLLECT PAYMENT RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        if (mode == 'cash') {
          isPaymentCollected.value = true;
        } else {
          isPaymentVerified.value = true;
        }
        _checkTotalPaymentStatus();
        ToastHelper.showSuccessToast(
          message: response.body['message'] ?? "Payment collected successfully",
        );
        return true;
      } else {
        print("COLLECT PAYMENT ERROR: ${response.body}");
        ToastHelper.showErrorToast(
          response.body['message'] ?? 'Payment collection failed',
        );
        return false;
      }
    } catch (e) {
      print("COLLECT PAYMENT EXCEPTION: $e");
      ToastHelper.showErrorToast("Connection failed");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
