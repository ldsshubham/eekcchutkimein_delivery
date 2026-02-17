class WalletHistoryResponse {
  final String status;
  final List<WalletHistoryItem> data;
  final String message;

  WalletHistoryResponse({
    required this.status,
    required this.data,
    required this.message,
  });

  factory WalletHistoryResponse.fromJson(Map<String, dynamic> json) {
    return WalletHistoryResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => WalletHistoryItem.fromJson(e))
          .toList(),
      message: json['message'] ?? '',
    );
  }
}

class WalletHistoryItem {
  final String id;
  final String orderId;
  final String amount;
  final DateTime createdAt;
  final String status;

  WalletHistoryItem({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.createdAt,
    required this.status,
  });

  factory WalletHistoryItem.fromJson(Map<String, dynamic> json) {
    return WalletHistoryItem(
      id: json['id']?.toString() ?? '',
      orderId: json['OrderId']?.toString() ?? '',
      amount: json['OrderTotal']?.toString() ?? '0.00',
      createdAt: DateTime.tryParse(json['Date'] ?? '') ?? DateTime.now(),
      status: json['order_delivery'] ?? '',
    );
  }
}
