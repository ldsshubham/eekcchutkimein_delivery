class OrderModel {
  final int orderId;
  final String orderDate;
  final String orderTime;
  final double orderAmount;
  final String orderStatus;
  final String vendorName;
  final String vendorAddress;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final List<OrderItem> productList;
  final String paymentGateway;

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
    required this.paymentGateway,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Basic Date Parsing
    String dateStr = json['Date'] ?? '';
    String formattedDate = dateStr;
    String formattedTime = '';

    if (dateStr.isNotEmpty) {
      try {
        final dt = DateTime.parse(dateStr).toLocal();
        // Simple manual formatting to avoid external dependencies for now
        // Format: DD/MM/YYYY
        formattedDate =
            "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";

        // Format: HH:MM AM/PM
        int hour = dt.hour;
        String ampm = 'AM';
        if (hour >= 12) {
          ampm = 'PM';
          if (hour > 12) hour -= 12;
        }
        if (hour == 0) hour = 12;
        formattedTime =
            "${hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} $ampm";
      } catch (e) {
        // Fallback checks could go here
      }
    }

    // Maps
    final customer = json['Customer'] is Map ? json['Customer'] : {};
    final vendor = json['Vendor'] is Map ? json['Vendor'] : {};

    // Items
    var list = json['Items'] as List? ?? [];
    List<OrderItem> itemsList = list.map((i) => OrderItem.fromJson(i)).toList();

    return OrderModel(
      orderId: (json['OrderId'] is int)
          ? json['OrderId']
          : int.tryParse(json['OrderId']?.toString() ?? '0') ?? 0,
      orderDate: formattedDate,
      orderTime: formattedTime,
      orderAmount:
          double.tryParse(json['OrderTotal']?.toString() ?? '0') ?? 0.0,
      orderStatus: json['OrderStatus'] ?? 'Pending',
      vendorName: vendor['name'] ?? 'Multiple Vendors',
      vendorAddress: vendor['address'] ?? '',
      customerName: customer['name'] ?? 'Unknown',
      customerAddress: customer['address'] ?? '',
      customerPhone: customer['phone'] ?? '',
      productList: itemsList,
      paymentGateway: json['PaymentGateway'] ?? 'Cash On Delivery',
    );
  }
}

class OrderItem {
  final int itemId;
  final String productName;
  final int productQuantity;
  final double price;
  final double total;

  OrderItem({
    required this.itemId,
    required this.productName,
    required this.productQuantity,
    required this.price,
    required this.total,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemId: (json['item_id'] is int)
          ? json['item_id']
          : int.tryParse(json['item_id']?.toString() ?? '0') ?? 0,
      productName: json['item_name'] ?? '',
      productQuantity: (json['quantity'] is int)
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
    );
  }
}
