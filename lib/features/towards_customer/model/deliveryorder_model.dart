class DeliveryOrder {
  final String customerName;
  final String phone;
  final String address;
  final String orderId;
  final String paymentMode;
  final int amount;
  final int items;

  DeliveryOrder({
    required this.customerName,
    required this.phone,
    required this.address,
    required this.orderId,
    required this.paymentMode,
    required this.amount,
    required this.items,
  });
}
