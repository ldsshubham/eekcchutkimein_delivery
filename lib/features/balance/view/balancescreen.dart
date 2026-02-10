import 'package:eekcchutkimein_delivery/features/homepage/controller/dashboard_controller.dart';
import 'package:eekcchutkimein_delivery/features/payment_history/controller/payment_history_controller.dart';
import 'package:eekcchutkimein_delivery/features/payment_history/model/wallet_history_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../constants/colors.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DashboardController dashboardController = Get.put(
      DashboardController(),
    );
    final PaymentHistoryController historyController = Get.put(
      PaymentHistoryController(),
    );

    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: () async {
        await dashboardController.fetchDashboardDetails();
        await historyController.fetchHistory();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final dashboard = dashboardController.dashboardData.value;
          final balance = dashboard?.totalEarnings ?? "0.00";
          final isLoading =
              dashboardController.isLoadining.value ||
              historyController.isLoading.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// BALANCE CARD
              // Container(
              //   width: double.infinity,
              //   padding: const EdgeInsets.all(24),
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [
              //         AppColors.primaryColor,
              //         AppColors.primaryColor.withOpacity(0.8),
              //       ],
              //       begin: Alignment.topLeft,
              //       end: Alignment.bottomRight,
              //     ),
              //     borderRadius: BorderRadius.circular(24),
              //     boxShadow: [
              //       BoxShadow(
              //         color: AppColors.primaryColor.withOpacity(0.3),
              //         blurRadius: 6,
              //         offset: const Offset(0, 4),
              //       ),
              //     ],
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       const Text(
              //         "TOTAL EARNINGS",
              //         style: TextStyle(
              //           color: Colors.white70,
              //           fontSize: 12,
              //           fontWeight: FontWeight.w600,
              //           letterSpacing: 1.2,
              //         ),
              //       ),
              //       const SizedBox(height: 12),
              //       Text(
              //         "₹$balance",
              //         style: const TextStyle(
              //           color: Colors.white,
              //           fontSize: 36,
              //           fontWeight: FontWeight.w900,
              //         ),
              //       ),
              //       const SizedBox(height: 12),
              //       Row(
              //         children: [
              //           const Icon(
              //             Icons.update,
              //             color: Colors.white70,
              //             size: 14,
              //           ),
              //           const SizedBox(width: 4),
              //           Text(
              //             "Last updated: ${DateFormat('hh:mm a').format(DateTime.now())}",
              //             style: const TextStyle(
              //               color: Colors.white70,
              //               fontSize: 11,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),

              // const SizedBox(height: 24),

              /// QUICK STATS
              // if (dashboard != null)
              //   Row(
              //     children: [
              //       _StatTile(title: "Orders", value: dashboard.totalOrders),
              //       _StatTile(title: "Today", value: dashboard.assignedToday),
              //       _StatTile(title: "Pending", value: dashboard.pendingOrders),
              //     ],
              //   ),

              // const SizedBox(height: 32),

              /// TRANSACTIONS TITLE
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Payment History",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          "Your transaction records",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isLoading)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              /// TRANSACTIONS LIST
              if (historyController.historyList.isEmpty && !isLoading)
                Scaffold(
                  body: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        "No transactions found",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: historyController.historyList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = historyController.historyList[index];
                    return _PaymentTile(item: item);
                  },
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final WalletHistoryItem item;
  const _PaymentTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('MMM dd, hh:mm a').format(item.createdAt);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        // color: item.status == "cancelled" ? Colors.red.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.status == "cancelled"
                  ? Colors.red.shade50
                  : Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.account_balance_wallet_rounded,
              color: item.status == "cancelled" ? Colors.red : Colors.green,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order #${item.orderId}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateStr,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
          Text(
            "₹${item.amount}",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: item.status == "cancelled" ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String title;
  final String value;

  const _StatTile({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
