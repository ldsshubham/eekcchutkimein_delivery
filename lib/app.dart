import 'package:eekcchutkimein_delivery/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      title: 'Eek Cchutki Mein - Delivery',
      initialRoute: AppRoutes.notReg,
      getPages: AppRoutes.routes,
    );
  }
}
