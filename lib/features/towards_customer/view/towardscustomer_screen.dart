import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:eekcchutkimein_delivery/features/orders/util/slidetostart_btn.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/model/deliveryorder_model.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/otpverification.dart';
import 'package:flutter/material.dart';

class TowardsCustomerScreen extends StatelessWidget {
  final DeliveryOrder order;

  const TowardsCustomerScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
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

                /// LOG OTP FOR NOW
                debugPrint("DELIVERY OTP: $otp");

                // showModalBottomSheet(
                //   context: context,
                //   isScrollControlled: true,
                //   shape: const RoundedRectangleBorder(
                //     borderRadius: BorderRadius.vertical(
                //       top: Radius.circular(20),
                //     ),
                //   ),
                //   builder: (_) => OtpVerificationSheet(
                //     generatedOtp: otp,

                //     onVerified: () {
                //       print('THIS IS OTP $otp');
                //       Navigator.pop(context); // close sheet
                //       Navigator.pushReplacement(
                //         context,
                //         MaterialPageRoute(
                //           builder: (_) => const OrderCompletedScreen(),
                //         ),
                //       );
                //     },
                //   ),
                // );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 👤 CUSTOMER CARD
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

  /// 📍 ADDRESS CARD
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

  /// 📦 ORDER DETAILS
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

  /// 🗺 MAP PREVIEW
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
      builder: (_) => const OtpVerificationSheet(),
    );
  }
}
