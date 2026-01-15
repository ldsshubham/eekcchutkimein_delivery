import 'package:eekcchutkimein_delivery/authentication/registration/controller/registration_controller.dart';
import 'package:eekcchutkimein_delivery/authentication/registration/registration_page.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/textinput.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/util/toastification_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;
  final String otp;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
    required this.otp,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24.0, 100, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Verify Phone Number",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "We've sent a verification code to",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "+91 ${widget.phoneNumber}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 40),

            MinimalInput(
              label: "OTP Code",
              controller: _otpController,
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.lock_outline),
            ),

            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Didn't receive the code? "),
                TextButton(
                  onPressed: () {
                    final controller = Get.find<RegistrationController>();
                    controller.sendOtp(widget.phoneNumber);
                  },
                  child: const Text(
                    "Resend",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  if (_otpController.text == widget.otp) {
                    Get.to(() => const RegistrationPage());
                    ToastHelper.showSuccessToast(
                      message: "OTP Verified Successfully",
                    );
                  } else {
                    ToastHelper.showErrorToast(message: "Invalid OTP");
                  }
                },
                child: const Text(
                  "Verify & Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
