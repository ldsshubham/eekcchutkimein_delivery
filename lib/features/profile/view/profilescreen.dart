import 'package:eekcchutkimein_delivery/features/profile/api/profile_api_service.dart';
import 'package:eekcchutkimein_delivery/features/profile/controller/profile_controller.dart';
import 'package:eekcchutkimein_delivery/features/profile/profile_model.dart';
import 'package:eekcchutkimein_delivery/features/profile/view/update_profile_screen.dart';
import 'package:eekcchutkimein_delivery/routes/routes.dart';
import 'package:eekcchutkimein_delivery/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Container(
      color: const Color(0xffF6F7F9),
      child: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return const Center(child: Text("Failed to load profile"));
        }

        return ListView(
          padding: const EdgeInsets.all(14),
          children: [
            _profileHeader(profile),
            const SizedBox(height: 12),
            _statsCard(profile),
            const SizedBox(height: 12),
            _infoCard("Personal Details", [
              _infoTile(
                Icons.person_outline,
                "Father's Name",
                profile.fatherName,
              ),
              _divider(),
              _infoTile(
                Icons.calendar_today_outlined,
                "Date of Birth",
                profile.dob,
              ),
              _divider(),
              _infoTile(Icons.email_outlined, "Email Address", profile.email),
            ]),
            const SizedBox(height: 12),
            _actionsCard(context, profile),
          ],
        );
      }),
    );
  }

  Widget _profileHeader(DeliveryPartnerProfile profile) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Row(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundColor: Color(0xffEDEDED),
                child: Icon(
                  Icons.person_outline,
                  size: 30,
                  color: Colors.black54,
                ),
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: profile.isOnline ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  profile.phone,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 2),
                Text(
                  "Partner ID: ${profile.partnerId}",
                  style: const TextStyle(fontSize: 13, color: Colors.black45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- STATS ----------------

  Widget _statsCard(DeliveryPartnerProfile profile) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _statRow(
            icon: Icons.currency_rupee,
            label: "Today Earnings",
            value: "₹${profile.todayEarnings}",
          ),
          _divider(),
          _statRow(
            icon: Icons.local_shipping_outlined,
            label: "Completed Orders",
            value: profile.totalOrders.toString(),
          ),
          // _divider(),
          // _statRow(
          //   icon: Icons.star_outline,
          //   label: "Rating",
          //   value: profile.rating.toString(),
          // ),
        ],
      ),
    );
  }

  Widget _statRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black54), // slightly bigger
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14, // +2
                color: Colors.black54,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15, // +2
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- INFO ----------------

  Widget _infoCard(String title, List<Widget> children) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15, // +2
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          _divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black45), // bigger
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14, // +2
                color: Colors.black54,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15, // +2
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- ACTIONS ----------------

  Widget _actionsCard(BuildContext context, DeliveryPartnerProfile? profile) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _actionTile(
            Icons.edit_outlined,
            "Edit Profile",
            onTap: () => Get.to(() => UpdateProfileScreen(profile: profile!)),
          ),
          // _divider(),
          // _actionTile(
          //   Icons.account_balance_outlined,
          //   "Bank Details",
          //   onTap: () {},
          // ),
          // _divider(),
          // _actionTile(Icons.support_agent_outlined, "Support", onTap: () {}),
          _divider(),
          _actionTile(
            Icons.logout,
            "Logout",
            isLogout: true,
            onTap: () => _showLogoutAlert(context),
          ),
          _divider(),
          _actionTile(
            Icons.delete_outline,
            "Delete Account",
            isLogout: true, // Reuse red styling
            onTap: () => _showDeleteAccountAlert(context),
          ),
        ],
      ),
    );
  }

  Widget _actionTile(
    IconData icon,
    String title, {
    bool isLogout = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isLogout ? Colors.red : Colors.black54),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15, // +2
                  color: isLogout ? Colors.red : Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: Colors.black38),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return const Divider(height: 1, thickness: 0.7, color: Color(0xffE6E6E6));
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
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
                await GetStorage().erase();

                // 3. Navigate away
                Get.offAllNamed(AppRoutes.notReg);
              } catch (e) {
                // Return to splash even if cleanup fails
                Get.offAllNamed(AppRoutes.notReg);
              }
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountAlert(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Delete Account?',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              // 1. Close dialog
              Get.back();

              // 2. Call API
              try {
                final apiService = ProfileApiService();
                final response = await apiService.deleteProfile();

                if (response.statusCode == 200) {
                  // 3. Clear data and navigate to Splash
                  await TokenService.clearTokens();
                  await GetStorage().erase();
                  Get.offAllNamed(AppRoutes.notReg);
                } else {
                  Get.snackbar(
                    "Error",
                    "Failed to delete account. Please try again.",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              } catch (e) {
                Get.snackbar("Error", "Something went wrong.");
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
