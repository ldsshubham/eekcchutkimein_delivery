import 'package:eekcchutkimein_delivery/features/homepage/view/homepage.dart';
import 'package:eekcchutkimein_delivery/features/splashscreen/view/splashscreen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String notReg = '/splashscreen';
  static const String homepage = '/homepage';

  static final routes = [
    GetPage(name: notReg, page: () => Splashscreen()),
    GetPage(name: homepage, page: () => Homepage()),
  ];
}
