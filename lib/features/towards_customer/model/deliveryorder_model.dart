class DeliveryOrder {
  final String customerName;
  final String phone;
  final String address;
  final int orderId;
  final String paymentMode;
  final double amount;
  final int items;
  final String? otp;

  DeliveryOrder({
    required this.customerName,
    required this.phone,
    required this.address,
    required this.orderId,
    required this.paymentMode,
    required this.amount,
    required this.items,
    this.otp,
  });
}
