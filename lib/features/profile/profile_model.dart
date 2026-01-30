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
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String state;
  final String pinCode;
  final String vehicleName;
  final String licenseNumber;
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
    required this.addressLine1,
    required this.addressLine2,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.vehicleName,
    required this.licenseNumber,
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
      addressLine1: json['address']?.toString() ?? '',
      addressLine2: json['Addressline_2']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      pinCode: json['pin_code']?.toString() ?? '',
      vehicleName: json['vehical_name']?.toString() ?? '',
      licenseNumber: json['license']?.toString() ?? '',
      isOnline:
          _parseBool(json['availability']) || _parseBool(json['is_online']),
    );
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    final str = value.toString().toLowerCase();
    return str == '1' || str == 'true' || str == 'online';
  }
}
