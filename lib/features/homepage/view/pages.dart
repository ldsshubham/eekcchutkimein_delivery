import 'package:eekcchutkimein_delivery/features/balance/view/balancescreen.dart';
import 'package:eekcchutkimein_delivery/features/homepage/view/dashboard.dart';
import 'package:eekcchutkimein_delivery/features/map/view/mapscreen.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/view/orderscreen.dart';
import 'package:eekcchutkimein_delivery/features/profile/view/profilescreen.dart';
import 'package:flutter/material.dart';

final List<Widget> pages = [
  OrderDetails(),
  DashboardScreen(),
  // MapScreen(),
  BalanceScreen(),
  ProfileScreen(),
];
