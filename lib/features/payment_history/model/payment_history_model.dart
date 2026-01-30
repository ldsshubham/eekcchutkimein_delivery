class PaymentHistoryItem {
  final String orderId;
  final double amount;
  final String date;
  final bool isCredit;
  final String description;

  PaymentHistoryItem({
    required this.orderId,
    required this.amount,
    required this.date,
    required this.isCredit,
    required this.description,
  });
}
