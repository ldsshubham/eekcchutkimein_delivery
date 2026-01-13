import 'package:get/get.dart';

class TowardsCustomerController extends GetxController {
  // Observable variables for payment state
  RxBool isPaymentCollected = false.obs;
  RxBool isPaymentVerified = false.obs;

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
}
