import 'package:eekcchutkimein_delivery/features/homepage/view/dashboard.dart';
import 'package:eekcchutkimein_delivery/features/homepage/view/homepage.dart';
import 'package:eekcchutkimein_delivery/features/map/view/mapscreen.dart';
import 'package:eekcchutkimein_delivery/features/orders/view/orderscreen.dart';
import 'package:eekcchutkimein_delivery/features/profile/view/profilescreen.dart';
import 'package:eekcchutkimein_delivery/features/splashscreen/view/splashscreen.dart';
import 'package:flutter/material.dart';

final List<Widget> pages = [
  DashboardScreen(),
  OrderDetails(),
  MapScreen(),
  ProfileScreen(),
  Splashscreen(),
  Homepage(),
];
