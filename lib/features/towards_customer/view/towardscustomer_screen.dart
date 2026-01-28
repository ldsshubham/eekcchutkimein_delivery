import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/util/slidetostart_btn.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/controller/towardscustomer_controller.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/model/deliveryorder_model.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/otpverification.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/view/paymentpage_cod.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TowardsCustomerScreen extends StatelessWidget {
  final DeliveryOrder order;
  const TowardsCustomerScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    // var paymentReceivedLocal = false; // Simulated payment status
    //     if (order.paymentMode == "online") {
    //       paymentReceivedLocal=true;
    //     }
    return Scaffold(
      backgroundColor: const Color(0xffF6F7F9),

      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Towards Delivery',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _customerCard(),
                  const SizedBox(height: 16),
                  _addressCard(),
                  const SizedBox(height: 16),
                  _orderDetailsCard(),
                  const SizedBox(height: 16),
                  if (order.paymentMode != "Online") _codPaymentOption(context),
                  const SizedBox(height: 16),
                  _mapPreview(),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SlideToStartButton(
              textTitle: "Order Delivered",
              onSlideComplete: () {
                showOtpSheet(context);
                final otp = generateOtp();
                debugPrint("DELIVERY OTP: $otp");
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _customerCard() {
    return _card(
      child: Row(
        children: [
          _iconCircle(Icons.person),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.customerName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                const Text("Customer", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.green),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _addressCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconCircle(Icons.location_on),
              const SizedBox(width: 12),
              const Text(
                "Delivery Address",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(order.address, style: TextStyle(color: Colors.grey.shade700)),
          const SizedBox(height: 8),
          Text(
            "Navigate",
            style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderDetailsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconCircle(Icons.receipt),
              const SizedBox(width: 12),
              Text(
                "Order Details",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _detailRow("Order ID", order.orderId),
          _detailRow("Payment", order.paymentMode),
          _detailRow("Amount", "₹${order.amount}"),
        ],
      ),
    );
  }

  Widget _codPaymentOption(context) {
    // Inject controller
    final TowardsCustomerController paymentController = Get.put(
      TowardsCustomerController(),
    );

    return _card(
      child: Obx(() {
        final isPaymentDone =
            paymentController.isPaymentCollected.value ||
            paymentController.isPaymentVerified.value;

        return Column(
          children: [
            _detailRow("Cash on Delivery", "₹${(order.amount)}"),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // SHOW QR BUTTON
                InkWell(
                  onTap: () async {
                    // Navigate to PaymentPage and wait for result
                    final result = await Get.to(
                      () => PaymentpageCod(order.amount),
                    );
                    if (result == true) {
                      paymentController.confirmQrPayment();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 44,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Show QR",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),

                // COLLECT CASH BUTTON (Toggle)
                InkWell(
                  onTap: () {
                    // Pass 'true' to indicate payment success
                    // Get.back(result: true);
                    Get.snackbar(
                      "Success",
                      "Payment marked as collected",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      margin: const EdgeInsets.all(20),
                    );
                    paymentController.toggleCashCollection();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 28,
                    ),
                    decoration: BoxDecoration(
                      color: paymentController.isPaymentCollected.value
                          ? Colors
                                .green
                                .shade600 // Green if collected
                          : Colors.blue.shade300, // Blue if pending
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      paymentController.isPaymentCollected.value
                          ? "Collected"
                          : "Collect Cash",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // PAYMENT RECEIVED INDICATOR
            if (isPaymentDone)
              Text(
                'Payment Received!',
                style: TextStyle(
                  color: AppColors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _mapPreview() {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          "Map Preview\n(Google Maps here)",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  /// 🔹 REUSABLE CARD
  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10),
        ],
      ),
      child: child,
    );
  }

  /// 🔹 ICON CIRCLE
  Widget _iconCircle(IconData icon) {
    return CircleAvatar(
      backgroundColor: Colors.green.shade100,
      child: Icon(icon, color: Colors.green),
    );
  }

  /// 🔹 DETAIL ROW
  Widget _detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey.shade600)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  String generateOtp() {
    return (1000 +
            (9999 - 1000) *
                (DateTime.now().millisecondsSinceEpoch % 1000) ~/
                1000)
        .toString();
  }

  void showOtpSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => OtpVerificationSheet(orderId: order.orderId),
    );
  }
}
