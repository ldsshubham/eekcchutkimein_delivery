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
}
