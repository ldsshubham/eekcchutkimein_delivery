import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:eekcchutkimein_delivery/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderCompletedScreen extends StatelessWidget {
  final bool isCancelled;
  const OrderCompletedScreen({super.key, this.isCancelled = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7F9),
      body: Column(
        children: [
          /// HEADER (NO GAP, CURVED)
          Container(
            width: double.infinity,
            height: 260,
            decoration: BoxDecoration(
              color: isCancelled ? Colors.red : Colors.green,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(0),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                Container(
                  width: 104,
                  height: 104,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    width: 84,
                    height: 84,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 64,
                      height: 64,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCancelled ? Icons.close_rounded : Icons.check_rounded,
                        color: isCancelled
                            ? Colors.red
                            : const Color(0xFF16A34A),
                        size: 38,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  isCancelled ? "Order Cancelled!" : "Order Delivered!",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  isCancelled
                      ? "The order has been cancelled."
                      : "Delivery completed successfully",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          /// EARNINGS CARD (Only if not cancelled, or show zero)
          if (!isCancelled)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _earningRow("Delivery Fee", "₹45"),
                    const SizedBox(height: 14),
                    _earningRow("Bonus", "₹10"),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(height: 1),
                    ),
                    _earningRow("Total Earnings", "₹55", isTotal: true),
                  ],
                ),
              ),
            ),

          const Spacer(),

          /// CTA BUTTON
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                onPressed: () {
                  Get.offAllNamed(AppRoutes.homepage);
                },
                child: const Text(
                  "Go for Next Order",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _earningRow(String title, String amount, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: isTotal ? Colors.black : Colors.grey.shade600,
          ),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}
