class BalanceResponse {
  final double availableBalance;
  final int totalOrders;
  final double tips;
  final double incentives;
  final List<PaymentHistory> history;

  BalanceResponse({
    required this.availableBalance,
    required this.totalOrders,
    required this.tips,
    required this.incentives,
    required this.history,
  });

  factory BalanceResponse.fromJson(Map<String, dynamic> json) {
    return BalanceResponse(
      availableBalance: json['available_balance'].toDouble(),
      totalOrders: json['orders'],
      tips: json['tips'].toDouble(),
      incentives: json['incentives'].toDouble(),
      history: (json['history'] as List)
          .map((e) => PaymentHistory.fromJson(e))
          .toList(),
    );
  }
}

class PaymentHistory {
  final String orderId;
  final int amount;
  final String date;
  final bool isCredit;

  PaymentHistory({
    required this.orderId,
    required this.amount,
    required this.date,
    required this.isCredit,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      orderId: json['order_id'],
      amount: json['amount'],
      date: json['date'],
      isCredit: json['is_credit'],
    );
  }
}
