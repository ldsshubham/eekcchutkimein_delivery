import 'package:eekcchutkimein_delivery/features/ordercompleted/view/ordercomplete_screen.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/controller/towardscustomer_controller.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/textinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class OtpVerificationSheet extends StatefulWidget {
  final int orderId;
  final String otp;
  const OtpVerificationSheet({
    super.key,
    required this.orderId,
    required this.otp,
  });

  @override
  State<OtpVerificationSheet> createState() => _OtpVerificationSheetState();
}

class _OtpVerificationSheetState extends State<OtpVerificationSheet> {
  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  final TowardsCustomerController controller =
      Get.find<TowardsCustomerController>();

  final TextEditingController otpController = TextEditingController();

  String get otp => otpController.text;

  @override
  void dispose() {
    otpController.dispose();
    for (var c in controllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
  }

  Future<void> _handleEndDelivery() async {
    final result = await controller.endDelivery(widget.orderId, otp);

    if (result != null) {
      Navigator.pop(context); // close bottom sheet
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OrderCompletedScreen(earnings: result.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Color(0xffF6F7F9), // light grey sheet bg (Blinkit-like)
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// drag handle
          Container(
            width: 42,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            "Verify Delivery OTP",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),

          const SizedBox(height: 6),

          const Text(
            "Ask customer for the 4-digit OTP",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),

          const SizedBox(height: 26),

          MinimalInput(
            label: 'Enter 4-digit OTP',
            controller: otpController,
            onChanged: (val) {
              setState(() {});
            },
            keyboardType: TextInputType.number,
            maxLength: 4,
          ),

          const SizedBox(height: 30),

          /// VERIFY BUTTON
          SizedBox(
            width: double.infinity,
            height: 52,
            child: Obx(() {
              final isOtpValid = otp.length == 4;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOtpValid
                      ? Colors.green
                      : Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: isOtpValid ? 4 : 0,
                ),
                onPressed: (isOtpValid && !controller.isLoading.value)
                    ? () => _handleEndDelivery()
                    : null,
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Verify & Complete Delivery",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              );
            }),
          ),

          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 60,
      height: 56,
      child: TextField(
        controller: controllers[index],
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.grey.shade300,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            focusNodes[index + 1].requestFocus();
          }
          if (value.isEmpty && index > 0) {
            focusNodes[index - 1].requestFocus();
          }
          setState(() {});
        },
      ),
    );
  }
}
