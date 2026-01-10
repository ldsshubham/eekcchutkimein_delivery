class PaymentHistoryItem {
  final String orderId;
  final double amount;
  final String date;  // e.g., "30 Dec, 4:15 PM" - simplified for UI
  final bool isCredit; // true for earnings, false for deductions
  final String description; // e.g. "Order delivered", "Weekly Incentive"

  PaymentHistoryItem({
    required this.orderId,
    required this.amount,
    required this.date,
    required this.isCredit,
    required this.description,
  });
}
