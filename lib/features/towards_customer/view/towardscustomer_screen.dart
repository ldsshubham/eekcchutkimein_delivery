// Towards Customer Screen
import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/util/slidetostart_btn.dart';
import 'package:eekcchutkimein_delivery/features/ordercompleted/view/ordercomplete_screen.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/controller/towardscustomer_controller.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/model/order_detail_model.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/otpverification.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/view/paymentpage_cod.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class TowardsCustomerScreen extends StatefulWidget {
  final int orderId;
  const TowardsCustomerScreen({super.key, required this.orderId});

  @override
  State<TowardsCustomerScreen> createState() => _TowardsCustomerScreenState();
}

class _TowardsCustomerScreenState extends State<TowardsCustomerScreen> {
  final TowardsCustomerController controller =
      Get.find<TowardsCustomerController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetPaymentState();
      controller.fetchOrderDetails(widget.orderId);
    });
  }

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
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.orderDetails.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        print("RESPONSE AT TOWARDS${controller.orderDetails.value}");
        final response = controller.orderDetails.value;
        if (response == null || response.data.orderDetails.isEmpty) {
          return const Center(child: Text("No order details found"));
        }

        final order = response.data.orderDetails.first;
        print("ORDER AT TOWARDS${order}");

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _cancelOrderCard(context, order.orderId),
                    const SizedBox(height: 16),
                    _customerCard(order),
                    const SizedBox(height: 16),
                    _addressCard(order),
                    const SizedBox(height: 16),
                    _orderDetailsCard(order),
                    const SizedBox(height: 16),
                    if (order.paymentStatus != "success")
                      _codPaymentOption(context, order),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SlideToStartButton(
                textTitle: "Order Delivered",
                onSlideComplete: () {
                  showOtpSheet(context, order.orderId, "");
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _customerCard(OrderDetail order) {
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
                  "HH ${order.customerName}",
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
            onPressed: () {
              _makePhoneCall(order.customerPhone);
            },
          ),
        ],
      ),
    );
  }

  Widget _addressCard(OrderDetail order) {
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
          Text(
            order.deliveryAddress,
            style: TextStyle(color: Colors.grey.shade700),
          ),
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

  Widget _orderDetailsCard(OrderDetail order) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _iconCircle(Icons.receipt),
              const SizedBox(width: 12),
              const Text(
                "Order Details",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _detailRow("Order ID", "#${order.orderId}"),
          _detailRow("Payment", order.gateway),
          _detailRow("Amount", "₹${order.orderTotalAmount}"),
        ],
      ),
    );
  }

  Widget _codPaymentOption(BuildContext context, OrderDetail order) {
    final TowardsCustomerController paymentController =
        Get.find<TowardsCustomerController>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Obx(() {
        final isCollected = paymentController.isPaymentCollected.value;
        final isVerified = paymentController.isPaymentVerified.value;
        final isLoading = paymentController.isLoading.value;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Payment Method",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Text(
                      "Cash On Delivery",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (isCollected || isVerified)
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    (isCollected || isVerified) ? "PAID" : "PENDING",
                    style: TextStyle(
                      color: (isCollected || isVerified)
                          ? Colors.green
                          : Colors.orange,
                      fontWeight: FontWeight.w800,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Amount to Collect",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "₹${order.orderTotalAmount}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            if (!(isCollected || isVerified))
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () async {
                              final result = await Get.to(
                                () => PaymentpageCod(
                                  double.tryParse(order.orderTotalAmount) ??
                                      0.0,
                                ),
                              );
                              if (result == true) {
                                paymentController.collectPayment(
                                  order.orderId,
                                  'cash',
                                );
                              }
                            },
                      icon: const Icon(Icons.qr_code_scanner, size: 18),
                      label: const Text("Show QR"),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(color: Colors.grey.shade300),
                        foregroundColor: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: isLoading
                          ? null
                          : () => paymentController.collectPayment(
                              order.orderId,
                              'cash',
                            ),
                      icon: isLoading
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.payments_outlined, size: 18),
                      label: Text(isLoading ? "Processing..." : "Collect Cash"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isCollected ? "Cash Collected" : "Payment Verified",
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
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
    if (value == "razorpay") value = "Paid";
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

  void showOtpSheet(BuildContext context, int orderId, String otp) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => OtpVerificationSheet(orderId: orderId, otp: otp),
    );
  }

  Widget _cancelOrderCard(BuildContext context, int orderId) {
    return InkWell(
      onTap: () => _showCancellationBottomSheet(context, orderId),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red.shade100, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cancel_outlined,
                color: Colors.red.shade700,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Unable to deliver?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.red.shade900,
                    ),
                  ),
                  const Text(
                    "Tap here to cancel this order",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.red.shade200),
          ],
        ),
      ),
    );
  }

  void _showCancellationBottomSheet(BuildContext context, int orderId) {
    final List<String> reasons = [
      "Customer not reachable",
      "Address incorrect / unable to find",
      "Customer refused to accept",
      "Vehicle issue / breakdown",
      "Other",
    ];

    String? selectedReason;
    final TowardsCustomerController controller =
        Get.find<TowardsCustomerController>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Cancel Order",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Please select a reason for cancellation",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  ...reasons.map(
                    (reason) => RadioListTile<String>(
                      title: Text(reason, style: const TextStyle(fontSize: 14)),
                      value: reason,
                      groupValue: selectedReason,
                      activeColor: Colors.red,
                      contentPadding: EdgeInsets.zero,
                      onChanged: (value) {
                        setModalState(() {
                          selectedReason = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed:
                            controller.isLoading.value || selectedReason == null
                            ? null
                            : () async {
                                print(
                                  "CANCEL ORDER: ${selectedReason} ${orderId}",
                                );
                                final success = await controller.cancelOrder(
                                  orderId,
                                  selectedReason!,
                                );
                                if (success) {
                                  print("Order cancelled successfully");
                                  Get.offAll(
                                    () => const OrderCompletedScreen(
                                      isCancelled: true,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                "Confirm Cancellation",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(launchUri);
  }
}
