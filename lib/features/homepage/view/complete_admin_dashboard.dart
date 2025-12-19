import 'package:eekcchutkimein_delivery/constants/appstring.dart';
import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:eekcchutkimein_delivery/features/homepage/controller/bottomnavcontroller.dart';
import 'package:eekcchutkimein_delivery/features/homepage/controller/mydrawercontroller.dart';
import 'package:eekcchutkimein_delivery/features/homepage/view/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CompleteAdminPanel extends StatelessWidget {
  final controller = Get.put(MyDrawerController());
  // final LoginController logOutController = Get.put(LoginController());
  final BottomNavController navController = Get.put(BottomNavController());
  CompleteAdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: controller.openDrawer,
          icon: Icon(Iconsax.menu),
        ),
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
              leading: Icon(Iconsax.home),
              title: Text('Dashboard'),
              onTap: () {
                navController.changePage(0);
                controller.closeDrawer();
              },
            ),
            ListTile(
              leading: Icon(Iconsax.activity),
              title: Text('Order'),
              onTap: () {
                navController.changePage(1);
                controller.closeDrawer();
              },
            ),
            ListTile(
              leading: Icon(Iconsax.location),
              title: Text('Map'),
              onTap: () {
                navController.changePage(0);
                controller.closeDrawer();
              },
            ),
            ListTile(
              leading: Icon(Iconsax.user),
              title: Text('Profile'),
              onTap: () {
                navController.changePage(1);
                controller.closeDrawer();
              },
            ),
            ListTile(
              leading: Icon(Iconsax.logout),
              title: Text('Logout'),
              onTap: () {
                // logOutController.logOutUser();
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

          enableFeedback: false,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.home),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.activity),
              label: 'Orders',
            ),
            BottomNavigationBarItem(icon: Icon(Iconsax.box), label: 'Map'),

            // BottomNavigationBarItem(
            //   icon: Icon(Iconsax.message_question),
            //   label: '',
            // ),
            // BottomNavigationBarItem(icon: Icon(Iconsax.setting), label: ''),
            BottomNavigationBarItem(icon: Icon(Iconsax.user), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
