import 'package:flutter/foundation.dart';

class OrderModel {
  final int orderId;
  final String orderDate;
  final String orderTime;
  final double orderAmount;
  final bool orderStatus;
  final String vendorName;
  final String vendorAddress;
  final String vendorPhone;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final List<OrderItem> productList;
  final String paymentStatus;
  final String paymentGateway;

  OrderModel({
    required this.orderId,
    required this.orderDate,
    required this.orderTime,
    required this.orderAmount,
    required this.orderStatus,
    required this.vendorName,
    required this.vendorAddress,
    required this.vendorPhone,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.productList,
    required this.paymentStatus,
    required this.paymentGateway,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Basic Date Parsing
    String dateStr =
        (json['Date'] ??
                json['date'] ??
                json['orderdate'] ??
                json['created_at'] ??
                '')
            .toString();
    String formattedDate = dateStr;
    String formattedTime = '';

    if (dateStr.isNotEmpty) {
      try {
        final dt = DateTime.parse(dateStr).toLocal();
        formattedDate =
            "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";

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
        debugPrint("Error parsing date: $dateStr - $e");
      }
    }

    // Maps
    final customer = json['Customer'] is Map
        ? json['Customer']
        : (json['customer'] is Map ? json['customer'] : {});
    final vendor = json['Vendor'] is Map
        ? json['Vendor']
        : (json['vendor'] is Map ? json['vendor'] : {});

    // Items
    var list = json['Items'] ?? json['items'] ?? json['productList'] ?? [];
    List<OrderItem> itemsList = [];
    if (list is List) {
      itemsList = list
          .whereType<Map<String, dynamic>>()
          .map((i) => OrderItem.fromJson(i))
          .toList();
    }

    return OrderModel(
      orderId:
          (json['OrderId'] ?? json['orderid'] ?? json['order_id'] ?? 0) is int
          ? (json['OrderId'] ?? json['orderid'] ?? json['order_id'] ?? 0)
          : int.tryParse(
                  (json['OrderId'] ??
                          json['orderid'] ??
                          json['order_id'] ??
                          '0')
                      .toString(),
                ) ??
                0,
      orderDate: formattedDate.toString(),
      orderTime: formattedTime.toString(),
      orderAmount:
          double.tryParse(
            (json['OrderTotal'] ??
                    json['orderamount'] ??
                    json['total_amount'] ??
                    '0')
                .toString(),
          ) ??
          0.0,
      orderStatus:
          (json['OrderStatus'] ??
                      json['orderstatus'] ??
                      json['status'] ??
                      'Pending')
                  .toString()
                  .toLowerCase() ==
              'delivered' ||
          (json['OrderStatus'] ?? json['orderstatus'] ?? json['status']) ==
              true,
      vendorName: (vendor['name'] ?? vendor['vendorname'] ?? 'Multiple Vendors')
          .toString(),
      vendorAddress: (vendor['address'] ?? vendor['vendoraddress'] ?? '')
          .toString(),
      vendorPhone: (vendor['phone'] ?? vendor['vendorphone'] ?? '').toString(),
      customerName: (customer['name'] ?? customer['customername'] ?? 'Unknown')
          .toString(),
      customerAddress:
          (customer['address'] ?? customer['customeraddress'] ?? '').toString(),
      customerPhone: (customer['phone'] ?? customer['customerphone'] ?? '')
          .toString(),
      productList: itemsList,
      paymentGateway:
          (json['PaymentGateway'] ?? json['payment_mode'] ?? 'Cash On Delivery')
              .toString(),
      paymentStatus:
          (json['PaymentStatus'] ?? json['payment_status'] ?? 'Pending')
              .toString(),
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
      itemId: (json['item_id'] ?? json['productid'] ?? 0) is int
          ? (json['item_id'] ?? json['productid'] ?? 0)
          : int.tryParse(
                  (json['item_id'] ?? json['productid'] ?? '0').toString(),
                ) ??
                0,
      productName: (json['item_name'] ?? json['productname'] ?? '').toString(),
      productQuantity: (json['quantity'] ?? json['productquantity'] ?? 0) is int
          ? (json['quantity'] ?? json['productquantity'] ?? 0)
          : int.tryParse(
                  (json['quantity'] ?? json['productquantity'] ?? '0')
                      .toString(),
                ) ??
                0,
      price: double.tryParse((json['price'] ?? '0').toString()) ?? 0.0,
      total: double.tryParse((json['total'] ?? '0').toString()) ?? 0.0,
    );
  }
}
