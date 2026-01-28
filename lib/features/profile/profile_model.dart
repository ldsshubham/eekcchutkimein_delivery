class DeliveryPartnerProfile {
  final String firstName;
  final String lastName;
  final String name;
  final String phone;
  final String partnerId;
  final double rating;
  final int totalOrders;
  final double todayEarnings;
  final String fatherName;
  final String dob;
  final String email;
  final String vehicleNumber;
  final String vehicleType;
  final bool isOnline;

  DeliveryPartnerProfile({
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.phone,
    required this.partnerId,
    required this.rating,
    required this.totalOrders,
    required this.todayEarnings,
    required this.fatherName,
    required this.dob,
    required this.email,
    required this.vehicleNumber,
    required this.vehicleType,
    required this.isOnline,
  });
  factory DeliveryPartnerProfile.fromJson(Map<String, dynamic> json) {
    final firstName = json['firstname']?.toString() ?? '';
    final lastName = json['lastname']?.toString() ?? '';
    return DeliveryPartnerProfile(
      firstName: firstName,
      lastName: lastName,
      name: "$firstName $lastName".trim(),
      phone: json['phone']?.toString() ?? '',
      partnerId: "DP${json['id']?.toString() ?? ''}",
      rating: double.tryParse(json['rating']?.toString() ?? '4.5') ?? 4.5,
      totalOrders: int.tryParse(json['total_orders']?.toString() ?? '0') ?? 0,
      todayEarnings:
          double.tryParse(json['today_earnings']?.toString() ?? '0') ?? 0,
      fatherName: json['father_name']?.toString() ?? '',
      dob: json['dob']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      vehicleNumber: json['vehical_number']?.toString() ?? '',
      vehicleType: json['vehical_type']?.toString() ?? '',
      isOnline: true,
    );
  }
}
