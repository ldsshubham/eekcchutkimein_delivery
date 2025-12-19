import 'package:flutter/material.dart';
import 'package:get/get.dart';


class MyDrawerController extends GetxController {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  closeDrawer() {
    scaffoldKey.currentState?.closeDrawer();
  }

}
