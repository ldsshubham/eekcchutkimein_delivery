import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:eekcchutkimein_delivery/features/homepage/controller/dashboard_controller.dart';
import 'package:eekcchutkimein_delivery/features/homepage/model/dashboard_model.dart';
import 'package:eekcchutkimein_delivery/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class DashboardScreen extends StatelessWidget {
  final DashboardController controller = Get.find<DashboardController>();
  final ProfileController profileController = Get.find<ProfileController>();
  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final name = profileController.profile.value?.name ?? "Delivery Hero";
    return Scaffold(
      backgroundColor: const Color(0xffF6F7F9),
      body: Obx(() {
        if (controller.isLoadining.value) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
              color: AppColors.primaryColor,
              size: 48,
            ),
          );
        } else {
          final data = controller.dashboardData.value!;
          return RefreshIndicator(
            onRefresh: controller.fetchDashboardDetails,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- ENHANCED HEADER ---
                  _buildHeader(data),
                  const SizedBox(height: 33),

                  // // --- XP & LEVEL PROGRESS SECTION ---
                  // _buildXPSection(data),
                  // const SizedBox(height: 24),

                  // // --- DAILY GOAL SECTION ---
                  // _buildDailyQuest(data),
                  // const SizedBox(height: 32),

                  // --- STATS GRID ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Your Performance",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      // Text(
                      //   "Last 24h",
                      //   style: TextStyle(
                      //     color: Colors.grey.shade500,
                      //     fontSize: 13,
                      //   ),
                      // ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildStatsGrid(data),

                  const SizedBox(height: 32),

                  // Refresh button at bottom
                  Center(
                    child: IntrinsicWidth(
                      child: TextButton(
                        onPressed: controller.fetchDashboardDetails,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.refresh,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Update Dashboard",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  Widget _buildHeader(DashboardModel data) {
    // Current time based greeting
    final hour = DateTime.now().hour;
    String greeting = "Good Morning";
    if (hour >= 12 && hour < 17) greeting = "Good Afternoon";
    if (hour >= 17) greeting = "Good Evening";

    return Row(
      children: [
        // Avatar with border
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.primaryColor.withOpacity(0.2),
              width: 2,
            ),
          ),
          child: CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              'https://ui-avatars.com/api/?name=${profileController.profile.value?.name}&background=0D8ABC&color=fff',
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                profileController.profile.value?.name ?? "Delivery Hero",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(DashboardModel data) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildStatCard(
          "Delivered",
          data.deliveredOrders,
          Icons.done_all,
          Colors.green,
        ),
        _buildStatCard(
          "Pending",
          data.pendingOrders,
          Icons.timer,
          Colors.orange,
        ),
        _buildStatCard(
          "Assigned Today",
          data.assignedToday,
          Icons.assignment_ind,
          Colors.blue,
        ),
        _buildStatCard(
          "Total Earnings",
          "₹${data.totalEarnings}",
          Icons.account_balance_wallet,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade50),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black.withOpacity(0.8),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
