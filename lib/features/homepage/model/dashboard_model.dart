class DashboardModel {
  final int deliveryBoyId;
  final String totalOrders;
  final String pendingOrders;
  final String deliveredOrders;
  final String assignedToday;
  final String totalEarnings;
  final String cancelledOrders;

  DashboardModel({
    required this.deliveryBoyId,
    required this.totalOrders,
    required this.pendingOrders,
    required this.deliveredOrders,
    required this.assignedToday,
    required this.totalEarnings,
    required this.cancelledOrders,
  });

  factory DashboardModel.fromjson(Map<String, dynamic> json) {
    return DashboardModel(
      deliveryBoyId: (json['delivery_boy_id'] ?? 0) is int
          ? (json['delivery_boy_id'] ?? 0)
          : int.tryParse(json['delivery_boy_id']?.toString() ?? '0') ?? 0,
      totalOrders: (json['total_orders'] ?? "0").toString(),
      pendingOrders: (json['pending_orders'] ?? "0").toString(),
      deliveredOrders: (json['delivered_orders'] ?? "0").toString(),
      assignedToday: (json['assigned_today'] ?? "0").toString(),
      totalEarnings: (json['total_earnings'] ?? "0").toString(),
      cancelledOrders: (json['cancelled_orders'] ?? "0").toString(),
    );
  }
}
