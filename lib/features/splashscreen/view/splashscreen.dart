import 'package:eekcchutkimein_delivery/constants/appstring.dart';
import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:eekcchutkimein_delivery/features/splashscreen/controller/splashscren_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';

class Splashscreen extends StatelessWidget {
  SplashController controller = Get.put(SplashController());
  Splashscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: AppColors.white),
        child: Center(child: Image(image: AssetImage(AppString.logo))),
      ),
    );
  }
}
