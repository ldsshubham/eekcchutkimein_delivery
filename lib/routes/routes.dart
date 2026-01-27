import 'package:eekcchutkimein_delivery/authentication/registration/loginwith_otp.dart';
import 'package:eekcchutkimein_delivery/authentication/registration/registration_page.dart';
import 'package:eekcchutkimein_delivery/features/homepage/view/homepage.dart';
import 'package:eekcchutkimein_delivery/features/ordersummry/view/ordersummery_screen.dart';
import 'package:eekcchutkimein_delivery/features/splashscreen/view/splashscreen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String notReg = '/splashscreen';
  static const String homepage = '/homepage';
  static const String verifyPhone = '/authentication/registration';
  static const String registration = '/authentication';
  static const String orderSummery = '/ordersummry';

  static final routes = [
    GetPage(name: notReg, page: () => Splashscreen()),
    GetPage(name: homepage, page: () => Homepage()),
    GetPage(name: verifyPhone, page: () => PhoneVerifyScreen()),
    GetPage(name: registration, page: () => RegistrationPage()),
    GetPage(name: orderSummery, page: () => OrderSummery()),
  ];
}
