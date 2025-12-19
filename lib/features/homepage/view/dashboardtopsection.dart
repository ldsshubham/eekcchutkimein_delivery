import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:eekcchutkimein_delivery/features/homepage/controller/bottomnavcontroller.dart';
import 'package:eekcchutkimein_delivery/features/homepage/view/dashboardcards.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class DashboardTopSection extends StatelessWidget {
  final BottomNavController controller = Get.find<BottomNavController>();
  final String totalOrder;
  final String deliveredOrders;
  final String pendingOrders;
  // final String totalSales;
  final String totalLeads;
  final String totalProducts;

  // final String totalServices;
  DashboardTopSection({
    super.key,
    required this.totalOrder,
    required this.deliveredOrders,
    required this.pendingOrders,
    // required this.totalSales,
    required this.totalProducts,
    // required this.totalServices,
    required this.totalLeads,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, double> orderData = {
      "Pending Orders": int.parse(pendingOrders).toDouble(),
      "Delivered Orders": int.parse(deliveredOrders).toDouble(),
    };
    final totalNum = int.parse(totalOrder);
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          // DashboardCards(
          //   title: 'Total Sales',
          //   data: '25',
          //   color: AppColors.white.withAlpha(100),
          //   gradient: LinearGradient(
          //     colors: [
          //       Color.fromARGB(255, 24, 117, 27),
          //       Color.fromARGB(255, 99, 206, 104),
          //     ],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //   ),
          //   icon: Icon(Iconsax.shop, color: AppColors.white),
          // ),
          // InkWell(
          //   onTap: () {
          //     controller.changePage(3);
          //   },
          //   child: DashboardCards(
          //     title: 'Total Leads',
          //     data: totalLeads,
          //     color: AppColors.white.withAlpha(100),
          //     gradient: LinearGradient(
          //       colors: [
          //         Color.fromARGB(255, 222, 63, 15),
          //         Color.fromARGB(255, 236, 125, 66),
          //       ],
          //       begin: Alignment.topRight,
          //       end: Alignment.bottomLeft,
          //     ),
          //     icon: Icon(Iconsax.call, color: Colors.white),
          //   ),
          // ),
          //   ],
          // ),

          // SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  controller.changePage(1);
                },
                child: DashboardCards(
                  title: 'Today\'s Orders',
                  data: totalOrder,
                  color: AppColors.white.withAlpha(100),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 216, 65, 51),
                      Color.fromARGB(255, 229, 171, 73),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icon(Iconsax.graph, color: AppColors.white),
                ),
              ),
              InkWell(
                onTap: () {
                  controller.changePage(1);
                },
                child: DashboardCards(
                  title: 'Pending Orders',
                  data: pendingOrders,
                  color: AppColors.white.withAlpha(100),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 101, 38, 211),
                      Color.fromARGB(255, 171, 141, 225),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icon(Iconsax.clock, color: AppColors.white),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  controller.changePage(2);
                },
                child: DashboardCards(
                  title: 'Total Orders',
                  data: totalProducts,
                  color: AppColors.white.withAlpha(100),
                  gradient: LinearGradient(
                    colors: [Color(0xFF2E7D32), Color(0xFF81C784)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  icon: Icon(Iconsax.box, color: AppColors.white),
                ),
              ),
              // InkWell(
              //   onTap: () {
              //     controller.changePage(4);
              //   },
              //   child: DashboardCards(
              //     title: 'Services',
              //     data: totalServices,
              //     color: AppColors.white.withAlpha(100),
              //     gradient: LinearGradient(
              //       colors: [Color(0xFF01579B), Color(0xFF4FC3F7)],
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ),
              //     icon: Icon(Iconsax.setting, color: AppColors.white),
              //   ),
              // ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
