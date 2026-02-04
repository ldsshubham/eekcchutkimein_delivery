class OrderDetailResponse {
  final String status;
  final OrderData data;
  final String message;

  OrderDetailResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) {
    return OrderDetailResponse(
      status: json['status'] ?? '',
      data: OrderData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class OrderData {
  final List<OrderDetail> orderDetails;
  final List<ProductTableDetail> detailsProductTable;

  OrderData({required this.orderDetails, required this.detailsProductTable});

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      orderDetails: (json['orderDetails'] as List? ?? [])
          .map((i) => OrderDetail.fromJson(i))
          .toList(),
      detailsProductTable: (json['detailsProductTable'] as List? ?? [])
          .map((i) => ProductTableDetail.fromJson(i))
          .toList(),
    );
  }
}

class OrderDetail {
  final int orderId;
  final String orderTotalAmount;
  final String orderStatus;
  final String gateway;
  final String orderDate;
  final String? paymentStatus;
  final int customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final int deliveryAddressId;
  final String deliveryName;
  final String deliveryPhone;
  final String deliveryAddress;
  final int productId;
  final String productName;
  final int quantity;
  final String price;
  final double finalAmount;
  final int vendorId;
  final String vendorName;
  final double vendorLatitude;
  final double vendorLongitude;
  final String vendorEmail;
  final String vendorPhone;
  final String vendorAddress;

  OrderDetail({
    required this.orderId,
    required this.orderTotalAmount,
    required this.orderStatus,
    required this.gateway,
    required this.orderDate,
    this.paymentStatus,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.deliveryAddressId,
    required this.deliveryName,
    required this.deliveryPhone,
    required this.deliveryAddress,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.finalAmount,
    required this.vendorId,
    required this.vendorName,
    required this.vendorLatitude,
    required this.vendorLongitude,
    required this.vendorEmail,
    required this.vendorPhone,
    required this.vendorAddress,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      orderId: json['order_id'] ?? 0,
      orderTotalAmount: json['order_total_amount']?.toString() ?? '0.00',
      orderStatus: json['order_status'] ?? '',
      gateway: json['gateway'] ?? '',
      orderDate: json['order_date'] ?? '',
      paymentStatus: json['payment_status'],
      customerId: json['customer_id'] ?? 0,
      customerName: json['customer_name'] ?? '',
      customerEmail: json['customer_email'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      deliveryAddressId: json['delivery_address_id'] ?? 0,
      deliveryName: json['delivery_name'] ?? '',
      deliveryPhone: json['delivery_phone'] ?? '',
      deliveryAddress: json['delivery_address'] ?? '',
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: json['price']?.toString() ?? '0',
      finalAmount: (json['final_amount'] ?? 0).toDouble(),
      vendorId: json['vendor_id'] ?? 0,
      vendorName: json['vendor_name'] ?? '',
      vendorLatitude: (json['vendor_latitude'] ?? 0).toDouble(),
      vendorLongitude: (json['vendor_longitude'] ?? 0).toDouble(),
      vendorEmail: json['vendor_email'] ?? '',
      vendorPhone: json['vendor_phone'] ?? '',
      vendorAddress: json['vendor_address'] ?? '',
    );
  }
}

class ProductTableDetail {
  final int productId;
  final String productName;
  final int quantity;
  final String grossPrice;
  final String extractedUnit;
  final double price;
  final double finalAmount;
  final int vendorId;
  final String vendorName;
  final String vendorEmail;
  final String vendorPhone;
  final String vendorAddress;

  ProductTableDetail({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.grossPrice,
    required this.extractedUnit,
    required this.price,
    required this.finalAmount,
    required this.vendorId,
    required this.vendorName,
    required this.vendorEmail,
    required this.vendorPhone,
    required this.vendorAddress,
  });

  factory ProductTableDetail.fromJson(Map<String, dynamic> json) {
    return ProductTableDetail(
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      quantity: json['quantity'] ?? 0,
      grossPrice: json['gross_price']?.toString() ?? '0',
      extractedUnit: json['extracted_unit'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      finalAmount: (json['final_amount'] ?? 0).toDouble(),
      vendorId: json['vendor_id'] ?? 0,
      vendorName: json['vendor_name'] ?? '',
      vendorEmail: json['vendor_email'] ?? '',
      vendorPhone: json['vendor_phone'] ?? '',
      vendorAddress: json['vendor_address'] ?? '',
    );
  }
}
