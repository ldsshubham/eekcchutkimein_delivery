import 'package:eekcchutkimein_delivery/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toastification/toastification.dart';
import 'routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        title: 'Delivery',
        initialRoute: AppRoutes.notReg,
        getPages: AppRoutes.routes,
      ),
    );
  }
}
