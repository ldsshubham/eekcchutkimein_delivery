import 'package:eekcchutkimein_delivery/constants/appstring.dart';
import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:eekcchutkimein_delivery/features/homepage/controller/bottomnavcontroller.dart';
import 'package:eekcchutkimein_delivery/features/homepage/controller/mydrawercontroller.dart';
import 'package:eekcchutkimein_delivery/features/homepage/view/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';

class CompleteAdminPanel extends StatelessWidget {
  CompleteAdminPanel({super.key});

  final controller = Get.put(MyDrawerController());
  final BottomNavController navController = Get.put(BottomNavController());

  final GetStorage box = GetStorage();

  final RxBool isOnline = true.obs;

  @override
  Widget build(BuildContext context) {
    isOnline.value = box.read('isOnline') ?? true;

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
                  isOnline.value ? 'ONLINE' : 'OFFLINE',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isOnline.value ? AppColors.success : Colors.red,
                  ),
                ),
                Switch(
                  value: isOnline.value,
                  activeThumbColor: AppColors.success,
                  onChanged: (value) {
                    if (!value && isOnline.value) {
                      _showOfflineAlert(context);
                    } else {
                      isOnline.value = true;
                      box.write('isOnline', true);
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
              title: const Text('Order'),
              onTap: () {
                navController.changePage(0);
                controller.closeDrawer();
              },
            ),
            ListTile(
              leading: const Icon(Iconsax.location),
              title: const Text('Map'),
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
              },
            ),
          ],
        ),
      ),

      body: Obx(
        () => IndexedStack(
          index: navController.currentPage.value,
          children: pages,
        ),
      ),

      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: navController.currentPage.value,
          onTap: navController.changePage,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.activity),
              label: 'Orders',
            ),
            BottomNavigationBarItem(icon: Icon(Iconsax.map), label: 'Map'),
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
              isOnline.value = false;
              box.write('isOnline', false); // ✅ store offline
              Get.back();
            },
            child: const Text('Go Offline'),
          ),
        ],
      ),
    );
  }
}
