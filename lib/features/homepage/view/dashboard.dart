import 'package:eekcchutkimein_delivery/constants/app_sizes.dart';
import 'package:eekcchutkimein_delivery/constants/app_text_styles.dart';
import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:eekcchutkimein_delivery/features/homepage/controller/dashboard_controller.dart';
import 'package:eekcchutkimein_delivery/features/homepage/view/dashboardtopsection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller = Get.put(DashboardController());
  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Obx(() {
        if (controller.isLoadining.value) {
          return Center(
            child: LoadingAnimationWidget.waveDots(
              color: AppColors.white,
              size: 48,
            ),
          );
        } else if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage.value,
              style: AppTextStyles.bodyText.copyWith(fontSize: AppSizes.fontXL),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          // Map<String, double> dataMap = {
          //   // "Pending Orders": controller.dashboardData.value!.pendingOrders
          //       .toDouble(),
          //   "Delivered Orders": controller.dashboardData.value!.deliveredOrders
          //       .toDouble(),
          // };
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: RefreshIndicator(
              onRefresh: controller.fetchDashboardDetails,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DashboardTopSection(
                      // Total Order
                      totalOrder:
                          controller.dashboardData.value?.totalOrders
                              .toString() ??
                          '0',
                      deliveredOrders:
                          controller.dashboardData.value?.deliveredOrders
                              .toString() ??
                          '0',
                      pendingOrders:
                          controller.dashboardData.value?.pendingOrders
                              .toString() ??
                          '0',

                      // Pending Order

                      // Total Sale
                      // totalSales:
                      //     formatSales(
                      //       controller.dashboardData.value?.totalSales,
                      //     ) ??
                      //     '0',

                      // Total Leads
                      totalLeads:
                          controller.dashboardData.value?.totalLeads
                              .toString() ??
                          '0',

                      // Total Products
                      totalProducts:
                          controller.dashboardData.value?.totalProducts
                              .toString() ??
                          '0',

                      // Total Services
                      //   totalServices:
                      //       controller.dashboardData.value?.totalServices
                      //           .toString() ??
                      //       '0',
                    ),
                    SizedBox(height: 8),
                    // PieChart(
                    //   dataMap: dataMap,
                    //   centerText: "ORDER",
                    //   colorList: [AppColors.warning, AppColors.green],
                    // ),
                    TextButton(
                      onPressed: () {
                        controller.fetchDashboardDetails();
                      },
                      child: Text('Click To Refresh'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
