class OrderModel {
  final int orderId;
  final String orderDate;
  final String orderTime;
  final int orderAmount;
  final String orderStatus;
  final String vendorName;
  final String vendorAddress;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final List<OrderItem> productList;

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.orderTime,
    required this.orderAmount,
    required this.orderStatus,
    required this.vendorName,
    required this.vendorAddress,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.productList,
  });
}

class OrderItem {
  final String productName;
  final int productQuantity;

  OrderItem({required this.productName, required this.productQuantity});
}
