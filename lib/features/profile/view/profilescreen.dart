import 'package:eekcchutkimein_delivery/constants/colors.dart';
import 'package:eekcchutkimein_delivery/features/profile/api/profile_api_service.dart';
import 'package:eekcchutkimein_delivery/features/profile/controller/profile_controller.dart';
import 'package:eekcchutkimein_delivery/features/profile/profile_model.dart';
import 'package:eekcchutkimein_delivery/features/profile/view/update_profile_screen.dart';
import 'package:eekcchutkimein_delivery/routes/routes.dart';
import 'package:eekcchutkimein_delivery/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Container(
      color: const Color(0xffF6F7F9),
      child: Obx(() {
        if (controller.isLoading.value) {
          return LoadingAnimationWidget.fourRotatingDots(
            color: AppColors.primaryColor,
            size: 48,
          );
        }

        final profile = controller.profile.value;
        if (profile == null) {
          return Scaffold(body: Center(child: Text("Failed to load profile")));
        }

        return ListView(
          padding: const EdgeInsets.all(14),
          children: [
            _profileHeader(profile),
            const SizedBox(height: 12),
            // _statsCard(profile),
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
          // Accent Bar
          Container(
            width: 4,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  profile.phone,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Partner ID: ${profile.partnerId}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xffEDEDED),
                backgroundImage: profile.imageUrl != null
                    ? NetworkImage(profile.imageUrl!)
                    : null,
                child: profile.imageUrl == null
                    ? const Icon(
                        Icons.person_outline,
                        size: 30,
                        color: Colors.black54,
                      )
                    : null,
              ),
              Positioned(
                bottom: 2,
                right: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: profile.isOnline ? Colors.green : Colors.grey,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ],
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
            onTap: () => _showDeleteAccountAlert(context, profile!.partnerId),
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

  void _showDeleteAccountAlert(BuildContext context, String partnerId) {
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
              print("Delete button pressed");
              try {
                final apiService = ProfileApiService();
                print("API service created");

                // Extract numeric ID from partnerId (e.g., "DP123" -> 123)
                print("partnerId: $partnerId");
                final id = int.parse(partnerId.replaceFirst('DP', ''));
                print("Parsed ID: $id");

                final response = await apiService.deleteProfile(id);
                print("API response received");
                print("Response body: ${response.body}");
                print("Response status: ${response.statusCode}");

                if (response.statusCode == 200) {
                  await TokenService.clearTokens();
                  print("Token cleared");
                  await GetStorage().erase();
                  Get.offAllNamed(AppRoutes.notReg);
                } else {
                  Get.snackbar(
                    "Error",
                    "Failed to delete account: ${response.statusCode}",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              } catch (e) {
                print("Error in delete profile: $e");
                Get.snackbar(
                  "Error",
                  "Something went wrong: $e",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
