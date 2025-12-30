import 'package:eekcchutkimein_delivery/features/ordercompleted/view/ordercomplete_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpVerificationSheet extends StatefulWidget {
  const OtpVerificationSheet({super.key});

  @override
  State<OtpVerificationSheet> createState() => _OtpVerificationSheetState();
}

class _OtpVerificationSheetState extends State<OtpVerificationSheet> {
  final List<TextEditingController> controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(4, (_) => FocusNode());

  String get otp => controllers.map((c) => c.text).join();

  @override
  void dispose() {
    for (var c in controllers) c.dispose();
    for (var f in focusNodes) f.dispose();
    super.dispose();
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

          /// OTP INPUT ROW
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (index) => _otpBox(index)),
          ),

          const SizedBox(height: 30),

          /// VERIFY BUTTON
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: otp.length == 4
                    ? Colors.green
                    : Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: otp.length == 4 ? 4 : 0,
              ),
              onPressed: otp.length == 4
                  ? () {
                      debugPrint("Entered OTP: $otp");

                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderCompletedScreen(),
                        ),
                      );
                    }
                  : null,
              child: const Text(
                "Verify & Complete Delivery",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
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
