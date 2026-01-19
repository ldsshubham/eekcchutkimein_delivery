class DeliveryPartnerProfile {
  final String name;
  final String phone;
  final String partnerId;
  final double rating;
  final int totalOrders;
  final double todayEarnings;
  final String vehicleNumber;
  final String vehicleType;
  final bool isOnline;

  DeliveryPartnerProfile({
    required this.name,
    required this.phone,
    required this.partnerId,
    required this.rating,
    required this.totalOrders,
    required this.todayEarnings,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.isOnline,
  });
  factory DeliveryPartnerProfile.fromJson(Map<String, dynamic> json) {
    return DeliveryPartnerProfile(
      name: "${json['firstname'] ?? ''} ${json['lastname'] ?? ''}".trim(),
      phone: json['phone']?.toString() ?? '',
      partnerId: "DP${json['id']?.toString() ?? ''}",
      rating:
          double.tryParse(json['rating']?.toString() ?? '4.5') ??
          4.5, // Default/Mock
      totalOrders:
          int.tryParse(json['total_orders']?.toString() ?? '0') ??
          0, // Default/Mock
      todayEarnings:
          double.tryParse(json['today_earnings']?.toString() ?? '0') ??
          0, // Default/Mock
      vehicleNumber: json['vehical_number']?.toString() ?? '',
      vehicleType: json['vehical_type']?.toString() ?? '',
      isOnline: true, // Managed locally or via another API usually
    );
  }
}
