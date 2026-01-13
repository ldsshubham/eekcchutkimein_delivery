import 'package:country_code_picker/country_code_picker.dart';
import 'package:eekcchutkimein_delivery/authentication/registration/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistraitonScreen extends StatelessWidget {
  const RegistraitonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top 75% Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/delivery_image.jpg'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Center(
                    child: const Text(
                      "Start Delivering Orders",
                      style: TextStyle(
                        fontSize: 18,
                        // fontFamily: 'Roboto',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Log in or sign up",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CountryCodePicker(
                          initialSelection: 'IN',
                          margin: EdgeInsets.all(0),
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        // Text(
                        //   "+91",
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.black,
                        //   ),
                        // ),
                      ),
                      hintText: "Enter mobile number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                        ),
                        onPressed: () {
                          Get.to(() => const OtpVerificationScreen());
                        },
                        child: const Icon(Icons.arrow_forward),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// 