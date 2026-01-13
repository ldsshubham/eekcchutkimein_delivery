import 'package:eekcchutkimein_delivery/authentication/registration/registrationscreen.dart';
import 'package:eekcchutkimein_delivery/features/homepage/view/homepage.dart';
import 'package:eekcchutkimein_delivery/features/ordersummry/view/ordersummery_screen.dart';
import 'package:eekcchutkimein_delivery/features/splashscreen/view/splashscreen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String notReg = '/splashscreen';
  static const String homepage = '/homepage';
  static const String register = '/authentication/registration';
  static const String orderSummery = '/ordersummry';

  static final routes = [
    GetPage(name: notReg, page: () => Splashscreen()),
    GetPage(name: homepage, page: () => Homepage()),
    GetPage(name: register, page: () => RegistraitonScreen()),
    GetPage(name: orderSummery, page: () => OrderSummery()),
  ];
}
