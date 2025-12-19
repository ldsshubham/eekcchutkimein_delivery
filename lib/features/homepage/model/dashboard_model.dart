class DashboardModel {
  final int totalOrders;
  final int deliveredOrders;
  final int pendingOrders;
  final int totalSales;
  final int totalLeads;
  final int totalProducts;
  final int totalServices;

  DashboardModel({
    required this.totalOrders,
    required this.deliveredOrders,
    required this.pendingOrders,
    required this.totalSales,
    required this.totalLeads,
    required this.totalProducts,
    required this.totalServices,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalOrders: json['total_orders'] ?? 0,
      deliveredOrders: json['delivered_order'] ?? 0,
      pendingOrders: json['pending_order'] ?? 0,
      totalSales: json['total_sales'] ?? 0,
      totalLeads: json['total_leads'] ?? 0,
      totalProducts: json['total_products'] ?? 0,
      totalServices: json['total_services'] ?? 0,
    );
  }
}
