import 'package:eekcchutkimein_delivery/constants/appstring.dart';
import 'package:eekcchutkimein_delivery/routes/routes.dart';
import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:eekcchutkimein_delivery/features/homepage/controller/bottomnavcontroller.dart';
import 'package:eekcchutkimein_delivery/features/homepage/controller/mydrawercontroller.dart';
import 'package:eekcchutkimein_delivery/features/homepage/view/pages.dart';
import 'package:eekcchutkimein_delivery/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:eekcchutkimein_delivery/features/homepage/controller/dashboard_controller.dart';
import 'package:eekcchutkimein_delivery/features/orders_home/controller/order_controller.dart';
import 'package:eekcchutkimein_delivery/features/profile/controller/profile_controller.dart';
import 'package:eekcchutkimein_delivery/features/towards_customer/controller/towardscustomer_controller.dart';
import 'package:iconsax/iconsax.dart';

class CompleteAdminPanel extends StatelessWidget {
  CompleteAdminPanel({super.key});

  final controller = Get.put(MyDrawerController());
  final BottomNavController navController = Get.put(BottomNavController());
  final ProfileController profileController = Get.put(ProfileController());
  final OrderController orderController = Get.put(OrderController());
  final DashboardController dashboardController = Get.put(
    DashboardController(),
  );
  final TowardsCustomerController towardsCustomerController = Get.put(
    TowardsCustomerController(),
  );

  final GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: controller.openDrawer,
          icon: const Icon(Iconsax.menu),
        ),
        actions: [
          Obx(
            () => Row(
              children: [
                Text(
                  profileController.isOnline.value ? 'ONLINE' : 'OFFLINE',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: profileController.isOnline.value
                        ? AppColors.success
                        : Colors.red,
                  ),
                ),
                Switch(
                  value: profileController.isOnline.value,
                  activeThumbColor: AppColors.success,
                  onChanged: (value) {
                    if (value == profileController.isOnline.value) return;
                    if (!value) {
                      _showOfflineAlert(context);
                    } else {
                      profileController.toggleAvailability(true);
                    }
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: AppColors.deliveryBlue),
              padding: EdgeInsets.zero,
              child: SizedBox.expand(
                child: Image.asset(AppString.delivery, fit: BoxFit.cover),
              ),
            ),

            ListTile(
              leading: const Icon(Iconsax.activity),
              title: const Text('Dashboard'),
              onTap: () {
                navController.changePage(0);
                controller.closeDrawer();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.shopping_bag),
              title: const Text('Orders'),
              onTap: () {
                navController.changePage(1);
                controller.closeDrawer();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.wallet),
              title: const Text('Balance'),
              onTap: () {
                navController.changePage(2);
                controller.closeDrawer();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.user),
              title: const Text('Profile'),
              onTap: () {
                navController.changePage(3);
                controller.closeDrawer();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.logout),
              title: const Text('Logout'),
              onTap: () {
                controller.closeDrawer();
                _showLogoutAlert(context);
              },
            ),
          ],
        ),
      ),

      body: Obx(() => pages[navController.currentPage.value]),

      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navController.currentPage.value,
          onTap: navController.changePage,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.activity),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.shopping_bag),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.wallet),
              label: 'Balance',
            ),
            BottomNavigationBarItem(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  void _showOfflineAlert(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Go Offline?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'You will stop receiving new orders while you are offline.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // cancel
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              profileController.toggleAvailability(false);
              Get.back();
            },
            child: const Text('Go Offline'),
          ),
        ],
      ),
    );
  }

  void _showLogoutAlert(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Logout?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // cancel
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              // 1. Close the dialog immediately
              Get.back();

              // 2. Perform cleanup
              try {
                await TokenService.clearTokens();
                await box.erase();

                // 3. Navigate away
                Get.offAllNamed(AppRoutes.notReg);
              } catch (e) {
                // If something fails, at least navigate
                Get.offAllNamed(AppRoutes.notReg);
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
