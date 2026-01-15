import 'package:eekcchutkimein_delivery/routes/routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(Duration(seconds: 2), () {
      Get.offNamed(AppRoutes.registration);
    });
  }
}
