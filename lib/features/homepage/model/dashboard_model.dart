class DashboardModel {
  final int deliveryBoyId;
  final String totalOrders;
  final String pendingOrders;
  final String deliveredOrders;
  final String assignedToday;
  final String totalEarnings;

  //  {
  //         "delivery_boy_id": 1,
  //         "total_orders": "300",
  //         "pending_orders": "297",
  //         "delivered_orders": "3",
  //         "assigned_today": "0",
  //         "total_earnings": "200.00"
  //     }
  DashboardModel({
    required this.deliveryBoyId,
    required this.totalOrders,
    required this.pendingOrders,
    required this.deliveredOrders,
    required this.assignedToday,
    required this.totalEarnings,
  });

  factory DashboardModel.fromjson(Map<String, dynamic> json) {
    return DashboardModel(
      deliveryBoyId: json['delivery_boy_id'] ?? 0,
      totalOrders: json['total_orders'] ?? "0",
      pendingOrders: json['pending_orders'] ?? "0",
      deliveredOrders: json['delivered_orders'] ?? 0,
      assignedToday: json['assigned_today'] ?? 0,
      totalEarnings: json['total_earnings'] ?? 0,
    );
  }
}
