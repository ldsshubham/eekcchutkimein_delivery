import 'package:eekcchutkimein_delivery/features/profile/profile_model.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = DeliveryPartnerProfile(
      name: "Rahul Sharma",
      phone: "+91 98XXXXXX21",
      partnerId: "DP10234",
      rating: 4.7,
      totalOrders: 1240,
      todayEarnings: 860,
      vehicleNumber: "DL 3S AB 4321",
      vehicleType: "Bike",
      isOnline: true,
    );

    return Container(
      color: const Color(0xffF6F7F9),
      child: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          _profileHeader(profile),
          const SizedBox(height: 12),
          _statsCard(profile),
          const SizedBox(height: 12),
          _infoCard("Vehicle Details", [
            _infoTile(
              Icons.directions_bike_outlined,
              "Vehicle Type",
              profile.vehicleType,
            ),
            _divider(),
            _infoTile(
              Icons.confirmation_number_outlined,
              "Vehicle Number",
              profile.vehicleNumber,
            ),
          ]),
          const SizedBox(height: 12),
          _actionsCard(),
        ],
      ),
    );
  }

  // ---------------- HEADER ----------------

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
                    fontSize: 16, // +2
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  profile.phone,
                  style: const TextStyle(
                    fontSize: 14, // +2
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Partner ID: ${profile.partnerId}",
                  style: const TextStyle(
                    fontSize: 13, // +2
                    color: Colors.black45,
                  ),
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
          _divider(),
          _statRow(
            icon: Icons.star_outline,
            label: "Rating",
            value: profile.rating.toString(),
          ),
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

  Widget _actionsCard() {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        children: [
          // _actionTile(Icons.edit_outlined, "Edit Profile"),
          // _divider(),
          _actionTile(Icons.account_balance_outlined, "Bank Details"),
          _divider(),
          _actionTile(Icons.support_agent_outlined, "Support"),
          _divider(),
          _actionTile(Icons.logout, "Logout", isLogout: true),
        ],
      ),
    );
  }

  Widget _actionTile(IconData icon, String title, {bool isLogout = false}) {
    return Padding(
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
}
