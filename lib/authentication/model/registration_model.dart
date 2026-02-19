class RegistrationModel {
  final String phoneNumber;
  final String name;
  final String email;
  final String password;
  final String panNumber;
  final String vehicleType;
  final String address;

  RegistrationModel({
    required this.phoneNumber,
    required this.name,
    required this.email,
    required this.password,
    required this.panNumber,
    required this.vehicleType,
    required this.address,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) {
    return RegistrationModel(
      phoneNumber: json["phoneNumber"],
      name: json["name"],
      email: json["email"],
      password: json["password"],
      panNumber: json["panNumber"],
      vehicleType: json["vehicleType"],
      address: json["address"],
    );
  }
}
